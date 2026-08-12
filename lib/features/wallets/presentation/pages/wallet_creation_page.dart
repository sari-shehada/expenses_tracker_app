import 'package:flutter/material.dart';

import '../../../currencies/domain/currency.dart';
import '../../../currencies/domain/currency_catalog.dart';
import '../../../currencies/presentation/currency_picker_field.dart';
import '../../domain/wallet_appearance.dart';
import '../../domain/wallet_repository.dart';
import '../wallet_color_palette.dart';
import '../wallet_icon_catalog.dart';
import 'wallet_color_selection_page.dart';
import 'wallet_icon_selection_page.dart';

class WalletCreationPage extends StatefulWidget {
  const WalletCreationPage({
    required this.userId,
    required this.repository,
    required this.currencyCatalog,
    super.key,
  });

  final String userId;
  final WalletRepository repository;
  final CurrencyCatalog currencyCatalog;

  @override
  State<WalletCreationPage> createState() => _WalletCreationPageState();
}

class _WalletCreationPageState extends State<WalletCreationPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  Currency? _currency;
  String _colorKey = WalletAppearance.defaultColorKey;
  String _iconKey = WalletAppearance.defaultIconKey;
  bool _isSaving = false;
  bool _currencyIsMissing = false;
  bool _saveFailed = false;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final selectedPalette = WalletColorPalette.resolve(_colorKey);
    final selectedIcon = WalletIconOption.resolve(_iconKey);
    final inputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(24),
      borderSide: BorderSide(color: colorScheme.outlineVariant),
    );

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Add wallet',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
                  children: [
                    Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 560),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const _WalletCreationHero(),
                            const SizedBox(height: 24),
                            TextFormField(
                              controller: _nameController,
                              decoration: InputDecoration(
                                labelText: 'Wallet name',
                                filled: true,
                                fillColor: Color.alphaBlend(
                                  colorScheme.primaryContainer.withAlpha(48),
                                  colorScheme.surface,
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 22,
                                ),
                                border: inputBorder,
                                enabledBorder: inputBorder,
                                focusedBorder: inputBorder.copyWith(
                                  borderSide: BorderSide(
                                    color: colorScheme.primary,
                                    width: 1.5,
                                  ),
                                ),
                                errorBorder: inputBorder.copyWith(
                                  borderSide: BorderSide(
                                    color: colorScheme.error,
                                  ),
                                ),
                                focusedErrorBorder: inputBorder.copyWith(
                                  borderSide: BorderSide(
                                    color: colorScheme.error,
                                    width: 1.5,
                                  ),
                                ),
                              ),
                              style: Theme.of(context).textTheme.titleMedium,
                              textInputAction: TextInputAction.done,
                              validator: _validateName,
                            ),
                            const SizedBox(height: 16),
                            CurrencyPickerField(
                              catalog: widget.currencyCatalog,
                              selectedCurrency: _currency,
                              onSelected: _selectCurrency,
                            ),
                            if (_currencyIsMissing) ...[
                              const SizedBox(height: 8),
                              Text(
                                'Select a currency.',
                                style: TextStyle(color: colorScheme.error),
                              ),
                            ],
                            const SizedBox(height: 24),
                            Text(
                              'Appearance',
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(fontWeight: FontWeight.w700),
                            ),
                            const SizedBox(height: 12),
                            _WalletAppearanceField(
                              key: const ValueKey('wallet-color-field'),
                              label: 'Color',
                              value: selectedPalette.name,
                              semanticsLabel:
                                  'Wallet color, ${selectedPalette.name}',
                              backgroundColor: selectedPalette.cardColor,
                              borderColor: selectedPalette.borderColor,
                              leading: Container(
                                width: 32,
                                height: 32,
                                decoration: BoxDecoration(
                                  color: selectedPalette.accentColor,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              onTap: _openColorSelection,
                            ),
                            const SizedBox(height: 12),
                            _WalletAppearanceField(
                              key: const ValueKey('wallet-icon-field'),
                              label: 'Icon',
                              value: selectedIcon.name,
                              semanticsLabel:
                                  'Wallet icon, ${selectedIcon.name}',
                              backgroundColor: selectedPalette.cardColor,
                              borderColor: selectedPalette.borderColor,
                              leading: Icon(
                                selectedIcon.icon,
                                color: selectedPalette.accentColor,
                              ),
                              onTap: _openIconSelection,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              _WalletCreationFooter(
                isSaving: _isSaving,
                saveFailed: _saveFailed,
                onCreate: _createWallet,
              ),
            ],
          ),
        ),
      ),
    );
  }

  String? _validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Enter a Wallet name.';
    }
    return null;
  }

  void _selectCurrency(Currency currency) {
    setState(() {
      _currency = currency;
      _currencyIsMissing = false;
    });
  }

  Future<void> _openColorSelection() async {
    FocusManager.instance.primaryFocus?.unfocus();
    final colorKey = await Navigator.push<String>(
      context,
      MaterialPageRoute(
        builder: (_) => WalletColorSelectionPage(
          initialColorKey: _colorKey,
          walletName: _walletPreviewName,
        ),
      ),
    );

    if (colorKey != null && mounted) {
      setState(() => _colorKey = colorKey);
    }
  }

  Future<void> _openIconSelection() async {
    FocusManager.instance.primaryFocus?.unfocus();
    final iconKey = await Navigator.push<String>(
      context,
      MaterialPageRoute(
        builder: (_) => WalletIconSelectionPage(
          initialIconKey: _iconKey,
          colorKey: _colorKey,
          walletName: _walletPreviewName,
        ),
      ),
    );

    if (iconKey != null && mounted) {
      setState(() => _iconKey = iconKey);
    }
  }

  String get _walletPreviewName {
    final name = _nameController.text.trim();
    return name.isEmpty ? 'Wallet' : name;
  }

  Future<void> _createWallet() async {
    final nameIsValid = _formKey.currentState!.validate();
    final currencyIsSelected = _currency != null;

    setState(() {
      _currencyIsMissing = !currencyIsSelected;
      _saveFailed = false;
    });

    if (!nameIsValid || !currencyIsSelected) {
      return;
    }

    setState(() => _isSaving = true);

    try {
      await widget.repository.createWallet(
        userId: widget.userId,
        name: _nameController.text,
        currencyCode: _currency!.code,
        colorKey: _colorKey,
        iconKey: _iconKey,
      );
      if (mounted) {
        Navigator.pop(context, true);
      }
    } catch (_) {
      if (mounted) {
        setState(() => _saveFailed = true);
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }
}

class _WalletAppearanceField extends StatelessWidget {
  const _WalletAppearanceField({
    required this.label,
    required this.value,
    required this.semanticsLabel,
    required this.backgroundColor,
    required this.borderColor,
    required this.leading,
    required this.onTap,
    super.key,
  });

  final String label;
  final String value;
  final String semanticsLabel;
  final Color backgroundColor;
  final Color borderColor;
  final Widget leading;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Semantics(
      button: true,
      label: semanticsLabel,
      excludeSemantics: true,
      child: Material(
        color: backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: BorderSide(color: borderColor),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 88),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Row(
                children: [
                  SizedBox.square(dimension: 40, child: Center(child: leading)),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          label,
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(color: colorScheme.onSurfaceVariant),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          value,
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.chevron_right,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _WalletCreationFooter extends StatelessWidget {
  const _WalletCreationFooter({
    required this.isSaving,
    required this.saveFailed,
    required this.onCreate,
  });

  final bool isSaving;
  final bool saveFailed;
  final VoidCallback onCreate;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      key: const ValueKey('wallet-creation-footer'),
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 16),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 560),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (saveFailed) ...[
                Semantics(
                  liveRegion: true,
                  child: Row(
                    children: [
                      Icon(
                        Icons.error_outline_rounded,
                        color: colorScheme.error,
                      ),
                      const SizedBox(width: 8),
                      const Expanded(child: Text('Could not save Wallet.')),
                      TextButton(
                        onPressed: isSaving ? null : onCreate,
                        child: const Text('Try again'),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
              ],
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  key: const ValueKey('create-wallet-button'),
                  onPressed: isSaving ? null : onCreate,
                  style: FilledButton.styleFrom(
                    minimumSize: const Size.fromHeight(60),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    disabledBackgroundColor: colorScheme.primary,
                    disabledForegroundColor: colorScheme.onPrimary,
                    textStyle: Theme.of(context).textTheme.titleMedium
                        ?.copyWith(fontWeight: FontWeight.w700),
                  ),
                  child: Semantics(
                    liveRegion: isSaving,
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 180),
                      child: isSaving
                          ? Row(
                              key: const ValueKey('creating-wallet'),
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox.square(
                                  dimension: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: colorScheme.onPrimary,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                const Text('Creating wallet'),
                              ],
                            )
                          : const Text(
                              'Create wallet',
                              key: ValueKey('create-wallet'),
                            ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _WalletCreationHero extends StatelessWidget {
  const _WalletCreationHero();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 320),
          child: const AspectRatio(
            aspectRatio: 1.35,
            child: Image(
              key: ValueKey('wallet-creation-hero'),
              image: AssetImage('assets/images/wallet_creation_hero.png'),
              fit: BoxFit.cover,
              excludeFromSemantics: true,
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Keep track of where your\nmoney comes from.',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            color: Theme.of(context).colorScheme.onSurface,
            fontWeight: FontWeight.w700,
            height: 1.35,
          ),
        ),
      ],
    );
  }
}
