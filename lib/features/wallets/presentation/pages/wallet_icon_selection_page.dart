import 'package:flutter/material.dart';

import '../../../../app/widgets/app_spacing.dart';
import '../../domain/wallet_appearance.dart';
import '../wallet_color_palette.dart';
import '../wallet_icon_catalog.dart';

class WalletIconSelectionPage extends StatefulWidget {
  const WalletIconSelectionPage({
    this.initialIconKey = WalletAppearance.defaultIconKey,
    this.colorKey = WalletAppearance.defaultColorKey,
    this.walletName = 'Wallet',
    super.key,
  });

  final String initialIconKey;
  final String colorKey;
  final String walletName;

  @override
  State<WalletIconSelectionPage> createState() =>
      _WalletIconSelectionPageState();
}

class _WalletIconSelectionPageState extends State<WalletIconSelectionPage> {
  late String _selectedIconKey;

  @override
  void initState() {
    super.initState();
    _selectedIconKey = WalletIconOption.resolve(widget.initialIconKey).key;
  }

  @override
  Widget build(BuildContext context) {
    final palette = WalletColorPalette.resolve(widget.colorKey);
    final selectedIcon = WalletIconOption.resolve(_selectedIconKey);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Wallet icon',
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
                          _WalletIconPreview(
                            palette: palette,
                            iconOption: selectedIcon,
                            walletName: widget.walletName,
                          ),
                          const AddVerticalSpacing(32),
                          Text(
                            'Choose an icon',
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.w700),
                          ),
                          const AddVerticalSpacing(12),
                          GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 4,
                                  mainAxisExtent: 88,
                                  crossAxisSpacing: 12,
                                  mainAxisSpacing: 12,
                                ),
                            itemCount: WalletIconOption.values.length,
                            itemBuilder: (context, index) {
                              final option = WalletIconOption.values[index];
                              return _WalletIconChoice(
                                option: option,
                                palette: palette,
                                isSelected: option.key == _selectedIconKey,
                                onSelected: () => setState(
                                  () => _selectedIconKey = option.key,
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
            _WalletIconSelectionFooter(
              onUseIcon: () => Navigator.pop(context, _selectedIconKey),
            ),
          ],
        ),
      ),
    );
  }
}

class _WalletIconPreview extends StatelessWidget {
  const _WalletIconPreview({
    required this.palette,
    required this.iconOption,
    required this.walletName,
  });

  final WalletColorPalette palette;
  final WalletIconOption iconOption;
  final String walletName;

  @override
  Widget build(BuildContext context) {
    final previewName = walletName.trim().isEmpty ? 'Wallet' : walletName;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: palette.cardColor,
        border: Border.all(color: palette.borderColor),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: palette.accentColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(16),
            ),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 180),
              child: Icon(
                iconOption.icon,
                key: const ValueKey('wallet-icon-preview-icon'),
                color: palette.accentColor,
              ),
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

class _WalletIconChoice extends StatelessWidget {
  const _WalletIconChoice({
    required this.option,
    required this.palette,
    required this.isSelected,
    required this.onSelected,
  });

  final WalletIconOption option;
  final WalletColorPalette palette;
  final bool isSelected;
  final VoidCallback onSelected;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Semantics(
      key: ValueKey('wallet-icon-${option.key}'),
      button: true,
      selected: isSelected,
      label: option.name,
      excludeSemantics: true,
      child: Material(
        color: isSelected ? palette.cardColor : colorScheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: isSelected
                ? palette.accentColor
                : colorScheme.outlineVariant,
            width: isSelected ? 2 : 1,
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onSelected,
          child: Stack(
            children: [
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      option.icon,
                      color: isSelected
                          ? palette.accentColor
                          : colorScheme.onSurfaceVariant,
                    ),
                    const AddVerticalSpacing(6),
                    Text(
                      option.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              if (isSelected)
                Positioned(
                  top: 6,
                  right: 6,
                  child: Icon(
                    Icons.check_circle,
                    color: palette.accentColor,
                    size: 18,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _WalletIconSelectionFooter extends StatelessWidget {
  const _WalletIconSelectionFooter({required this.onUseIcon});

  final VoidCallback onUseIcon;

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
              key: const ValueKey('use-wallet-icon-button'),
              onPressed: onUseIcon,
              style: FilledButton.styleFrom(
                minimumSize: const Size.fromHeight(60),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                textStyle: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
              ),
              child: const Text('Use this icon'),
            ),
          ),
        ),
      ),
    );
  }
}
