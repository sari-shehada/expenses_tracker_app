import 'package:flutter/material.dart';

class WalletCreationStepIndicator extends StatelessWidget {
  const WalletCreationStepIndicator({required this.step, super.key})
    : assert(step >= 1 && step <= totalSteps);

  static const totalSteps = 3;

  final int step;

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
                  child: Text(
                    'Step $step of $totalSteps',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: colors.primary,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Flexible(
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
            const SizedBox(height: 8),
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
                      child: FractionallySizedBox(
                        key: const ValueKey('wallet-step-progress-fill'),
                        widthFactor: _fillFraction,
                        heightFactor: 1,
                        child: ColoredBox(color: colors.primary),
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
