import 'package:flutter/material.dart';

import '../../../../app/app_motion.dart';
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
    this.saveFailed = false,
    this.onRetry,
    this.backButtonKey,
    this.ctaButtonKey,
    super.key,
  }) : assert(!saveFailed || onRetry != null);

  final String selectedColorKey;
  final String selectedIconKey;
  final ValueChanged<String> onColorSelected;
  final ValueChanged<String> onIconSelected;
  final VoidCallback onBack;
  final VoidCallback onCreate;
  final bool isCreating;
  final bool saveFailed;
  final VoidCallback? onRetry;
  final Key? backButtonKey;
  final Key? ctaButtonKey;

  @override
  Widget build(BuildContext context) {
    final selectedPalette = WalletColorPalette.resolve(selectedColorKey);

    return WalletCreationFlowScaffold(
      step: 3,
      accentColor: selectedPalette.accentColor,
      onBack: onBack,
      ctaLabel: 'Create Wallet',
      ctaLoadingLabel: 'Creating wallet',
      isCtaLoading: isCreating,
      onCtaPressed: onCreate,
      ctaMessage: saveFailed
          ? WalletSaveFailureMessage(isCreating: isCreating, onRetry: onRetry!)
          : null,
      backButtonKey: backButtonKey,
      ctaButtonKey: ctaButtonKey,
      body: WalletAppearanceStepBody(
        selectedColorKey: selectedColorKey,
        selectedIconKey: selectedIconKey,
        onColorSelected: onColorSelected,
        onIconSelected: onIconSelected,
      ),
    );
  }
}

class WalletAppearanceStepBody extends StatelessWidget {
  const WalletAppearanceStepBody({
    required this.onColorSelected,
    required this.onIconSelected,
    this.selectedColorKey = WalletAppearance.defaultColorKey,
    this.selectedIconKey = WalletAppearance.defaultIconKey,
    super.key,
  });

  final String selectedColorKey;
  final String selectedIconKey;
  final ValueChanged<String> onColorSelected;
  final ValueChanged<String> onIconSelected;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final selectedPalette = WalletColorPalette.resolve(selectedColorKey);
    final selectedIcon = WalletIconOption.resolve(selectedIconKey);
    final colorAnimationDuration = MediaQuery.disableAnimationsOf(context)
        ? Duration.zero
        : AppMotion.colorTransitionDuration;

    return SingleChildScrollView(
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
                  selectedPalette: selectedPalette,
                  colorAnimationDuration: colorAnimationDuration,
                  onSelected: onIconSelected,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class WalletSaveFailureMessage extends StatelessWidget {
  const WalletSaveFailureMessage({
    required this.isCreating,
    required this.onRetry,
    super.key,
  });

  final bool isCreating;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Semantics(
      liveRegion: true,
      child: Row(
        children: [
          Icon(Icons.error_outline_rounded, color: colors.error),
          const SizedBox(width: 8),
          const Expanded(child: Text('Could not save Wallet.')),
          TextButton(
            onPressed: isCreating ? null : onRetry,
            child: const Text('Try again'),
          ),
        ],
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
  const _IconPicker({
    required this.selectedIcon,
    required this.selectedPalette,
    required this.colorAnimationDuration,
    required this.onSelected,
  });

  final WalletIconOption selectedIcon;
  final WalletColorPalette selectedPalette;
  final Duration colorAnimationDuration;
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
              selectedPalette: selectedPalette,
              colorAnimationDuration: colorAnimationDuration,
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
    required this.selectedPalette,
    required this.colorAnimationDuration,
    required this.onSelected,
  });

  final WalletIconOption option;
  final bool isSelected;
  final WalletColorPalette selectedPalette;
  final Duration colorAnimationDuration;
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
      child: AnimatedContainer(
        key: ValueKey('wallet-creation-icon-card-${option.key}'),
        duration: colorAnimationDuration,
        curve: AppMotion.colorTransitionCurve,
        decoration: BoxDecoration(
          color: isSelected
              ? selectedPalette.cardColor
              : colors.surfaceContainerLowest,
          borderRadius: radius,
          border: Border.all(
            color: isSelected
                ? selectedPalette.borderColor
                : colors.outlineVariant,
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onSelected,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(4, 12, 4, 10),
              child: Column(
                children: [
                  AnimatedContainer(
                    key: ValueKey('wallet-creation-icon-accent-${option.key}'),
                    width: 36,
                    height: 36,
                    duration: colorAnimationDuration,
                    curve: AppMotion.colorTransitionCurve,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? selectedPalette.accentColor
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
                    child: AnimatedDefaultTextStyle(
                      duration: colorAnimationDuration,
                      curve: AppMotion.colorTransitionCurve,
                      style: TextStyle(
                        color: isSelected
                            ? selectedPalette.accentColor
                            : colors.onSurfaceVariant,
                        fontSize: 11,
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.w500,
                      ),
                      child: Text(
                        option.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                      ),
                    ),
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
