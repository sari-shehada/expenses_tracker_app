import 'package:flutter/material.dart';

import '../../../../app/widgets/app_spacing.dart';
import '../../domain/wallet_appearance.dart';
import '../wallet_color_palette.dart';

class WalletColorSelectionPage extends StatefulWidget {
  const WalletColorSelectionPage({
    this.initialColorKey = WalletAppearance.defaultColorKey,
    this.walletName = 'Wallet',
    super.key,
  });

  final String initialColorKey;
  final String walletName;

  @override
  State<WalletColorSelectionPage> createState() =>
      _WalletColorSelectionPageState();
}

class _WalletColorSelectionPageState extends State<WalletColorSelectionPage> {
  late String _selectedColorKey;

  @override
  void initState() {
    super.initState();
    _selectedColorKey = WalletColorPalette.resolve(widget.initialColorKey).key;
  }

  @override
  Widget build(BuildContext context) {
    final selectedPalette = WalletColorPalette.resolve(_selectedColorKey);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Wallet color',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
                children: [
                  Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 560),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            'Preview',
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.w700),
                          ),
                          const AddVerticalSpacing(12),
                          _WalletColorPreview(
                            palette: selectedPalette,
                            walletName: widget.walletName,
                          ),
                          const AddVerticalSpacing(32),
                          Text(
                            'Choose a color',
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.w700),
                          ),
                          const AddVerticalSpacing(12),
                          GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  mainAxisExtent: 80,
                                  crossAxisSpacing: 12,
                                  mainAxisSpacing: 12,
                                ),
                            itemCount: WalletColorPalette.values.length,
                            itemBuilder: (context, index) {
                              final palette = WalletColorPalette.values[index];
                              return _WalletColorOption(
                                palette: palette,
                                isSelected: palette.key == _selectedColorKey,
                                onSelected: () => setState(
                                  () => _selectedColorKey = palette.key,
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            _WalletColorSelectionFooter(
              onUseColor: () => Navigator.pop(context, _selectedColorKey),
            ),
          ],
        ),
      ),
    );
  }
}

class _WalletColorPreview extends StatelessWidget {
  const _WalletColorPreview({required this.palette, required this.walletName});

  final WalletColorPalette palette;
  final String walletName;

  @override
  Widget build(BuildContext context) {
    final previewName = walletName.trim().isEmpty ? 'Wallet' : walletName;

    return AnimatedContainer(
      key: const ValueKey('wallet-color-preview'),
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOut,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: palette.cardColor,
        border: Border.all(color: palette.borderColor),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: palette.accentColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              Icons.account_balance_wallet_outlined,
              color: palette.accentColor,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              previewName,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }
}

class _WalletColorOption extends StatelessWidget {
  const _WalletColorOption({
    required this.palette,
    required this.isSelected,
    required this.onSelected,
  });

  final WalletColorPalette palette;
  final bool isSelected;
  final VoidCallback onSelected;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      key: ValueKey('wallet-color-${palette.key}'),
      button: true,
      selected: isSelected,
      label: palette.name,
      excludeSemantics: true,
      child: Material(
        color: palette.cardColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: isSelected ? palette.accentColor : palette.borderColor,
            width: isSelected ? 2 : 1,
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onSelected,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: palette.accentColor,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    palette.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                if (isSelected)
                  Icon(
                    Icons.check_circle,
                    color: palette.accentColor,
                    size: 22,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _WalletColorSelectionFooter extends StatelessWidget {
  const _WalletColorSelectionFooter({required this.onUseColor});

  final VoidCallback onUseColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 16),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 560),
          child: SizedBox(
            width: double.infinity,
            child: FilledButton(
              key: const ValueKey('use-wallet-color-button'),
              onPressed: onUseColor,
              style: FilledButton.styleFrom(
                minimumSize: const Size.fromHeight(60),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                textStyle: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
              ),
              child: const Text('Use this color'),
            ),
          ),
        ),
      ),
    );
  }
}
