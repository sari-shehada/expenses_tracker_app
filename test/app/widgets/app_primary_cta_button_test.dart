import 'package:expenses_tracker/app/app_theme.dart';
import 'package:expenses_tracker/app/widgets/app_primary_cta_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('matches the Figma primary CTA dimensions and styling', (
    tester,
  ) async {
    await _pumpButton(tester);

    final buttonFinder = find.byKey(const ValueKey('primary-cta'));
    final button = tester.widget<FilledButton>(buttonFinder);
    final states = <WidgetState>{};

    expect(tester.getSize(buttonFinder), const Size(354, 48));
    expect(
      button.style?.padding?.resolve(states),
      const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
    );
    expect(
      button.style?.backgroundColor?.resolve(states),
      AppTheme.light.colorScheme.primary,
    );
    expect(
      button.style?.foregroundColor?.resolve(states),
      AppTheme.light.colorScheme.onPrimary,
    );

    final shape =
        button.style?.shape?.resolve(states)! as RoundedRectangleBorder;
    expect(shape.borderRadius, BorderRadius.circular(16));

    final textStyle = button.style?.textStyle?.resolve(states);
    expect(textStyle?.fontSize, 15);
    expect(textStyle?.fontWeight, FontWeight.w600);
  });

  testWidgets('invokes its callback when pressed', (tester) async {
    var presses = 0;
    await _pumpButton(tester, onPressed: () => presses++);

    await tester.tap(find.byKey(const ValueKey('primary-cta')));

    expect(presses, 1);
  });

  testWidgets('shows progress and disables presses while loading', (
    tester,
  ) async {
    var presses = 0;
    await _pumpButton(tester, isLoading: true, onPressed: () => presses++);

    expect(find.text('Continue'), findsNothing);
    expect(find.text('Working'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('primary-cta')));

    expect(presses, 0);
  });

  testWidgets('meets tap-target and labeling accessibility guidelines', (
    tester,
  ) async {
    final semantics = tester.ensureSemantics();
    try {
      await _pumpButton(tester);

      await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
      await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
    } finally {
      semantics.dispose();
    }
  });
}

Future<void> _pumpButton(
  WidgetTester tester, {
  bool isLoading = false,
  VoidCallback? onPressed,
}) {
  return tester.pumpWidget(
    MaterialApp(
      theme: AppTheme.light,
      home: Scaffold(
        body: Center(
          child: SizedBox(
            width: 354,
            child: AppPrimaryCtaButton(
              label: 'Continue',
              loadingLabel: 'Working',
              isLoading: isLoading,
              onPressed: onPressed ?? () {},
              buttonKey: const ValueKey('primary-cta'),
            ),
          ),
        ),
      ),
    ),
  );
}
