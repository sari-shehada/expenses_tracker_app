import 'package:expenses_tracker/app/app_theme.dart';
import 'package:expenses_tracker/app/widgets/app_primary_cta_button.dart';
import 'package:expenses_tracker/features/wallets/presentation/widgets/wallet_creation_flow_scaffold.dart';
import 'package:expenses_tracker/features/wallets/presentation/widgets/wallet_creation_step_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('composes the shared flow chrome around step content', (
    tester,
  ) async {
    var backCalls = 0;
    var continueCalls = 0;

    await _pumpScaffold(
      tester,
      step: 2,
      onBack: () => backCalls++,
      onCtaPressed: () => continueCalls++,
    );

    expect(find.text('Create Wallet'), findsOneWidget);
    expect(find.text('Step 2 of 3'), findsOneWidget);
    expect(find.text('67% Complete'), findsOneWidget);
    expect(find.text('Step content'), findsOneWidget);
    expect(find.text('Continue'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('flow-back-button')));
    await tester.tap(find.byKey(const ValueKey('flow-cta-button')));

    expect(backCalls, 1);
    expect(continueCalls, 1);
  });

  testWidgets('keeps the CTA visible on a compact screen', (tester) async {
    await _pumpScaffold(
      tester,
      step: 1,
      size: const Size(320, 568),
      onBack: () {},
      onCtaPressed: () {},
    );

    expect(
      find.byKey(const ValueKey('flow-cta-button')).hitTestable(),
      findsOneWidget,
    );
    expect(
      tester.getSize(find.byKey(const ValueKey('flow-cta-button'))).height,
      48,
    );
  });

  testWidgets('forwards an optional accent to the progress and CTA', (
    tester,
  ) async {
    await _pumpScaffold(
      tester,
      step: 3,
      accentColor: Colors.green,
      onBack: () {},
      onCtaPressed: () {},
    );

    expect(
      tester
          .widget<WalletCreationStepIndicator>(
            find.byType(WalletCreationStepIndicator),
          )
          .accentColor,
      Colors.green,
    );
    expect(
      tester
          .widget<AppPrimaryCtaButton>(find.byType(AppPrimaryCtaButton))
          .backgroundColor,
      Colors.green,
    );
  });

  testWidgets('animates the CTA above changing keyboard insets', (
    tester,
  ) async {
    await _pumpScaffold(
      tester,
      step: 1,
      size: const Size(320, 568),
      onBack: () {},
      onCtaPressed: () {},
    );

    final ctaFinder = find.byKey(const ValueKey('flow-cta-button'));
    final initialTop = tester.getTopLeft(ctaFinder).dy;

    tester.view.viewInsets = const FakeViewPadding(bottom: 220);
    addTearDown(tester.view.resetViewInsets);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 125));

    final animatedTop = tester.getTopLeft(ctaFinder).dy;
    expect(animatedTop, lessThan(initialTop));
    expect(animatedTop, greaterThan(initialTop - 220));

    await tester.pumpAndSettle();

    final settledTop = tester.getTopLeft(ctaFinder).dy;
    expect(settledTop, lessThan(animatedTop));
    expect(settledTop, initialTop - 220);
    expect(tester.getBottomRight(ctaFinder).dy, lessThanOrEqualTo(568 - 220));
  });

  testWidgets('shows and disables the CTA loading state', (tester) async {
    var continueCalls = 0;

    await _pumpScaffold(
      tester,
      step: 3,
      isCtaLoading: true,
      onBack: () {},
      onCtaPressed: () => continueCalls++,
    );

    expect(find.text('Creating wallet'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('flow-cta-button')));

    expect(continueCalls, 0);
  });
}

Future<void> _pumpScaffold(
  WidgetTester tester, {
  required int step,
  required VoidCallback onBack,
  required VoidCallback onCtaPressed,
  bool isCtaLoading = false,
  Color? accentColor,
  Size size = const Size(402, 874),
}) {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);

  return tester.pumpWidget(
    MaterialApp(
      theme: AppTheme.light,
      home: WalletCreationFlowScaffold(
        step: step,
        body: const Center(child: Text('Step content')),
        onBack: onBack,
        ctaLabel: step == 3 ? 'Create Wallet' : 'Continue',
        ctaLoadingLabel: 'Creating wallet',
        isCtaLoading: isCtaLoading,
        accentColor: accentColor,
        onCtaPressed: onCtaPressed,
        backButtonKey: const ValueKey('flow-back-button'),
        ctaButtonKey: const ValueKey('flow-cta-button'),
      ),
    ),
  );
}
