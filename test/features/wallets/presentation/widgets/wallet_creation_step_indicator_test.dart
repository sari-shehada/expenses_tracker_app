import 'package:expenses_tracker/app/app_theme.dart';
import 'package:expenses_tracker/features/wallets/presentation/widgets/wallet_creation_motion.dart';
import 'package:expenses_tracker/features/wallets/presentation/widgets/wallet_creation_step_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  for (final variant in const [
    (step: 1, percentage: 33, fillWidth: 118.0),
    (step: 2, percentage: 67, fillWidth: 237.0),
    (step: 3, percentage: 100, fillWidth: 354.0),
  ]) {
    testWidgets('matches the Figma treatment for step ${variant.step}', (
      tester,
    ) async {
      await _pumpIndicator(tester, step: variant.step);

      expect(find.text('Step ${variant.step} of 3'), findsOneWidget);
      expect(find.text('${variant.percentage}% Complete'), findsOneWidget);
      expect(
        tester.getSize(
          find.byKey(const ValueKey('wallet-step-progress-track')),
        ),
        const Size(354, 6),
      );
      expect(
        tester
            .getSize(find.byKey(const ValueKey('wallet-step-progress-fill')))
            .width,
        closeTo(variant.fillWidth, 0.01),
      );
      final animatedFill = tester.widget<AnimatedFractionallySizedBox>(
        find.byKey(const ValueKey('wallet-step-progress-fill')),
      );
      expect(
        animatedFill.duration,
        WalletCreationMotion.stepTransitionDuration,
      );
      expect(animatedFill.curve, WalletCreationMotion.stepTransitionCurve);
      expect(
        tester.getRect(find.text('${variant.percentage}% Complete')).right,
        tester
            .getRect(find.byKey(const ValueKey('wallet-step-progress-track')))
            .right,
      );

      final semantics = tester.getSemantics(
        find.byType(WalletCreationStepIndicator),
      );
      expect(
        semantics.label,
        'Step ${variant.step} of 3, ${variant.percentage}% complete',
      );
    });
  }

  testWidgets('animates between step widths with the shared step motion', (
    tester,
  ) async {
    final harnessKey = GlobalKey<_IndicatorHarnessState>();
    await _pumpIndicatorHarness(tester, harnessKey: harnessKey);

    harnessKey.currentState!.showStep(2);
    await tester.pump();
    await tester.pump(WalletCreationMotion.stepTransitionDuration * 0.5);

    final expectedWidth =
        118 +
        ((237 - 118) * WalletCreationMotion.stepTransitionCurve.transform(0.5));
    expect(
      tester
          .getSize(find.byKey(const ValueKey('wallet-step-progress-fill')))
          .width,
      closeTo(expectedWidth, 0.01),
    );

    await tester.pumpAndSettle();
    expect(
      tester
          .getSize(find.byKey(const ValueKey('wallet-step-progress-fill')))
          .width,
      closeTo(237, 0.01),
    );
  });

  testWidgets('updates immediately when animations are disabled', (
    tester,
  ) async {
    final harnessKey = GlobalKey<_IndicatorHarnessState>();
    await _pumpIndicatorHarness(
      tester,
      harnessKey: harnessKey,
      disableAnimations: true,
    );

    harnessKey.currentState!.showStep(2);
    await tester.pump();

    expect(
      tester
          .getSize(find.byKey(const ValueKey('wallet-step-progress-fill')))
          .width,
      closeTo(237, 0.01),
    );
    expect(tester.binding.hasScheduledFrame, isFalse);
  });
}

Future<void> _pumpIndicator(WidgetTester tester, {required int step}) {
  tester.view.physicalSize = const Size(402, 200);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);

  return tester.pumpWidget(
    MaterialApp(
      theme: AppTheme.light,
      home: Scaffold(body: WalletCreationStepIndicator(step: step)),
    ),
  );
}

Future<void> _pumpIndicatorHarness(
  WidgetTester tester, {
  required GlobalKey<_IndicatorHarnessState> harnessKey,
  bool disableAnimations = false,
}) {
  tester.view.physicalSize = const Size(402, 200);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);

  return tester.pumpWidget(
    MaterialApp(
      theme: AppTheme.light,
      home: MediaQuery(
        data: MediaQueryData(disableAnimations: disableAnimations),
        child: Scaffold(body: _IndicatorHarness(key: harnessKey)),
      ),
    ),
  );
}

class _IndicatorHarness extends StatefulWidget {
  const _IndicatorHarness({super.key});

  @override
  State<_IndicatorHarness> createState() => _IndicatorHarnessState();
}

class _IndicatorHarnessState extends State<_IndicatorHarness> {
  int _step = 1;

  void showStep(int step) => setState(() => _step = step);

  @override
  Widget build(BuildContext context) {
    return WalletCreationStepIndicator(step: _step);
  }
}
