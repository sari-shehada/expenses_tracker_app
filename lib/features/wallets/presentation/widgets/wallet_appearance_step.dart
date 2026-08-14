import 'package:flutter/material.dart';

import '../../domain/wallet_appearance.dart';
import '../wallet_color_palette.dart';
import '../wallet_icon_catalog.dart';
import 'wallet_creation_flow_scaffold.dart';

class WalletAppearanceStep extends StatelessWidget {
  const WalletAppearanceStep({
    required this.onColorSelected,
    required this.onIconSelected,
    required this.onBack,
    required this.onCreate,
    this.selectedColorKey = WalletAppearance.defaultColorKey,
    this.selectedIconKey = WalletAppearance.defaultIconKey,
    this.isCreating = false,
    this.backButtonKey,
    this.ctaButtonKey,
    super.key,
  });

  final String selectedColorKey;
  final String selectedIconKey;
  final ValueChanged<String> onColorSelected;
  final ValueChanged<String> onIconSelected;
  final VoidCallback onBack;
  final VoidCallback onCreate;
  final bool isCreating;
  final Key? backButtonKey;
  final Key? ctaButtonKey;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final selectedPalette = WalletColorPalette.resolve(selectedColorKey);
    final selectedIcon = WalletIconOption.resolve(selectedIconKey);

    return WalletCreationFlowScaffold(
      step: 3,
      onBack: onBack,
      ctaLabel: 'Create Wallet',
      ctaLoadingLabel: 'Creating wallet',
      isCtaLoading: isCreating,
      onCtaPressed: onCreate,
      backButtonKey: backButtonKey,
      ctaButtonKey: ctaButtonKey,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Personalize your wallet',
                    style: TextStyle(
                      color: colors.onSurface,
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Choose a color and icon to identify this wallet at a glance',
                    style: TextStyle(
                      color: colors.onSurfaceVariant,
                      fontSize: 14,
                      height: 20 / 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _ColorPicker(
                    selectedPalette: selectedPalette,
                    onSelected: onColorSelected,
                  ),
                  const SizedBox(height: 28),
                  _IconPicker(
                    selectedIcon: selectedIcon,
                    onSelected: onIconSelected,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ColorPicker extends StatelessWidget {
  const _ColorPicker({required this.selectedPalette, required this.onSelected});

  final WalletColorPalette selectedPalette;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const _PickerLabel('Wallet Color'),
        const SizedBox(height: 12),
        SizedBox(
          height: 48,
          child: Row(
            children: [
              for (final palette in WalletColorPalette.values)
                Expanded(
                  child: _ColorSwatch(
                    palette: palette,
                    isSelected: palette.key == selectedPalette.key,
                    onSelected: () => onSelected(palette.key),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ColorSwatch extends StatelessWidget {
  const _ColorSwatch({
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
      key: ValueKey('wallet-creation-color-${palette.key}'),
      button: true,
      selected: isSelected,
      label: palette.name,
      excludeSemantics: true,
      child: Material(
        color: Colors.transparent,
        child: InkResponse(
          onTap: onSelected,
          radius: 24,
          child: Center(
            child: Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: palette.accentColor,
                shape: BoxShape.circle,
                border: isSelected
                    ? Border.all(color: Colors.white, width: 2)
                    : null,
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: palette.accentColor.withValues(alpha: 0.25),
                          offset: const Offset(0, 4),
                          blurRadius: 4,
                        ),
                      ]
                    : null,
              ),
              child: isSelected
                  ? const Icon(
                      Icons.check_rounded,
                      color: Colors.white,
                      size: 12,
                    )
                  : null,
            ),
          ),
        ),
      ),
    );
  }
}

class _IconPicker extends StatelessWidget {
  const _IconPicker({required this.selectedIcon, required this.onSelected});

  final WalletIconOption selectedIcon;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const _PickerLabel('Wallet Icon'),
        const SizedBox(height: 12),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            mainAxisExtent: 80,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemCount: WalletIconOption.values.length,
          itemBuilder: (context, index) {
            final option = WalletIconOption.values[index];
            return _IconChoice(
              option: option,
              isSelected: option.key == selectedIcon.key,
              onSelected: () => onSelected(option.key),
            );
          },
        ),
      ],
    );
  }
}

class _IconChoice extends StatelessWidget {
  const _IconChoice({
    required this.option,
    required this.isSelected,
    required this.onSelected,
  });

  final WalletIconOption option;
  final bool isSelected;
  final VoidCallback onSelected;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final radius = BorderRadius.circular(14);

    return Semantics(
      key: ValueKey('wallet-creation-icon-${option.key}'),
      button: true,
      selected: isSelected,
      label: option.name,
      excludeSemantics: true,
      child: Material(
        color: isSelected
            ? colors.primaryContainer
            : colors.surfaceContainerLowest,
        shape: RoundedRectangleBorder(
          borderRadius: radius,
          side: BorderSide(
            color: isSelected
                ? colors.secondaryContainer
                : colors.outlineVariant,
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onSelected,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(4, 12, 4, 10),
            child: Column(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? colors.primary
                        : const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    option.icon,
                    color: isSelected
                        ? colors.onPrimary
                        : colors.onSurfaceVariant,
                    size: 20,
                  ),
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: Text(
                    option.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: isSelected
                          ? colors.primary
                          : colors.onSurfaceVariant,
                      fontSize: 11,
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PickerLabel extends StatelessWidget {
  const _PickerLabel(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: const TextStyle(
        color: Color(0xFF475569),
        fontSize: 13,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}
