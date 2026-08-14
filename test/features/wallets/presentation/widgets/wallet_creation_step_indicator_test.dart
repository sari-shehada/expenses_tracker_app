import 'package:expenses_tracker/app/app_theme.dart';
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

      final semantics = tester.getSemantics(
        find.byType(WalletCreationStepIndicator),
      );
      expect(
        semantics.label,
        'Step ${variant.step} of 3, ${variant.percentage}% complete',
      );
    });
  }
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
