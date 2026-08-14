import 'package:expenses_tracker/app/app_theme.dart';
import 'package:expenses_tracker/app/widgets/app_page_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('shows its title and invokes its Back callback', (tester) async {
    var backCalls = 0;

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: Scaffold(
          body: AppPageHeader(
            title: 'Create Wallet',
            backButtonKey: const ValueKey('test-back-button'),
            onBack: () => backCalls++,
          ),
        ),
      ),
    );

    expect(find.text('Create Wallet'), findsOneWidget);
    expect(find.byTooltip('Back'), findsOneWidget);
    expect(
      tester.getSize(find.byKey(const ValueKey('test-back-button'))),
      const Size.square(48),
    );
    expect(
      tester.getTopLeft(find.byKey(const ValueKey('test-back-button'))).dx,
      20,
    );
    expect(tester.getTopLeft(find.text('Create Wallet')).dx, 76);

    await tester.tap(find.byKey(const ValueKey('test-back-button')));

    expect(backCalls, 1);
  });

  testWidgets('meets tap-target and labeling accessibility guidelines', (
    tester,
  ) async {
    final semantics = tester.ensureSemantics();
    try {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light,
          home: Scaffold(
            body: AppPageHeader(title: 'Page title', onBack: () {}),
          ),
        ),
      );

      await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
      await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
    } finally {
      semantics.dispose();
    }
  });
}
