import 'package:flutter/material.dart';

class AppPrimaryCtaButton extends StatelessWidget {
  const AppPrimaryCtaButton({
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.loadingLabel = 'Loading',
    this.buttonKey,
    this.labelKey,
    this.loadingKey,
    super.key,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final String loadingLabel;
  final Key? buttonKey;
  final Key? labelKey;
  final Key? loadingKey;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return SizedBox(
      width: double.infinity,
      height: 48,
      child: FilledButton(
        key: buttonKey,
        onPressed: isLoading ? null : onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: colors.primary,
          foregroundColor: colors.onPrimary,
          disabledBackgroundColor: colors.primary,
          disabledForegroundColor: colors.onPrimary,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
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
