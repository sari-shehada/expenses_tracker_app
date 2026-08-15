import 'package:flutter/material.dart';

import '../app_motion.dart';

class AppPrimaryCtaButton extends StatelessWidget {
  const AppPrimaryCtaButton({
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.loadingLabel = 'Loading',
    this.backgroundColor,
    this.buttonKey,
    this.labelKey,
    this.loadingKey,
    super.key,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final String loadingLabel;
  final Color? backgroundColor;
  final Key? buttonKey;
  final Key? labelKey;
  final Key? loadingKey;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    if (backgroundColor == null) {
      return _buildButton(context, backgroundColor: colors.primary);
    }

    return TweenAnimationBuilder<Color?>(
      tween: ColorTween(end: backgroundColor),
      duration: MediaQuery.disableAnimationsOf(context)
          ? Duration.zero
          : AppMotion.colorTransitionDuration,
      curve: AppMotion.colorTransitionCurve,
      builder: (context, animatedBackgroundColor, _) => _buildButton(
        context,
        backgroundColor: animatedBackgroundColor ?? colors.primary,
        buttonAnimationDuration: Duration.zero,
      ),
    );
  }

  Widget _buildButton(
    BuildContext context, {
    required Color backgroundColor,
    Duration? buttonAnimationDuration,
  }) {
    final colors = Theme.of(context).colorScheme;

    return SizedBox(
      width: double.infinity,
      height: 48,
      child: FilledButton(
        key: buttonKey,
        onPressed: isLoading ? null : onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: colors.onPrimary,
          disabledBackgroundColor: isLoading
              ? backgroundColor
              : colors.outlineVariant,
          disabledForegroundColor: isLoading
              ? colors.onPrimary
              : colors.onSurfaceVariant,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
          animationDuration: buttonAnimationDuration,
        ),
        child: Semantics(
          liveRegion: isLoading,
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 180),
            child: isLoading
                ? Row(
                    key: loadingKey,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox.square(
                        dimension: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: colors.onPrimary,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(loadingLabel),
                    ],
                  )
                : Text(label, key: labelKey),
          ),
        ),
      ),
    );
  }
}
