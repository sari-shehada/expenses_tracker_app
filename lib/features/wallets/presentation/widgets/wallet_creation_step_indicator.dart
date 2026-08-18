import 'package:flutter/material.dart';

import '../../../../app/app_motion.dart';
import '../../../../app/widgets/app_spacing.dart';
import 'wallet_creation_motion.dart';

class WalletCreationStepIndicator extends StatelessWidget {
  const WalletCreationStepIndicator({
    required this.step,
    this.accentColor,
    super.key,
  }) : assert(step >= 1 && step <= totalSteps);

  static const totalSteps = 3;

  final int step;
  final Color? accentColor;

  int get _completionPercentage => switch (step) {
    1 => 33,
    2 => 67,
    3 => 100,
    _ => throw StateError('Unsupported Wallet creation step: $step'),
  };

  double get _fillFraction => switch (step) {
    1 => 118 / 354,
    2 => 237 / 354,
    3 => 1,
    _ => throw StateError('Unsupported Wallet creation step: $step'),
  };

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final completionPercentage = _completionPercentage;
    final disableAnimations = MediaQuery.disableAnimationsOf(context);
    final animationDuration = disableAnimations
        ? Duration.zero
        : WalletCreationMotion.stepTransitionDuration;
    final colorAnimationDuration = disableAnimations || accentColor == null
        ? Duration.zero
        : AppMotion.colorTransitionDuration;

    return Semantics(
      container: true,
      label: 'Step $step of $totalSteps, $completionPercentage% complete',
      excludeSemantics: true,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: AnimatedDefaultTextStyle(
                    key: const ValueKey('wallet-step-count-label-style'),
                    duration: colorAnimationDuration,
                    curve: AppMotion.colorTransitionCurve,
                    style: TextStyle(
                      color: accentColor ?? colors.primary,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                    child: Text(
                      'Step $step of $totalSteps',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '$completionPercentage% Complete',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.end,
                    style: TextStyle(
                      color: colors.outline,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            const AddVerticalSpacing(8),
            ClipRRect(
              key: const ValueKey('wallet-step-progress-track'),
              borderRadius: BorderRadius.circular(3),
              child: SizedBox(
                height: 6,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    ColoredBox(color: colors.outlineVariant),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: AnimatedFractionallySizedBox(
                        key: const ValueKey('wallet-step-progress-fill'),
                        widthFactor: _fillFraction,
                        heightFactor: 1,
                        duration: animationDuration,
                        curve: WalletCreationMotion.stepTransitionCurve,
                        child: AnimatedContainer(
                          duration: colorAnimationDuration,
                          curve: AppMotion.colorTransitionCurve,
                          color: accentColor ?? colors.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
