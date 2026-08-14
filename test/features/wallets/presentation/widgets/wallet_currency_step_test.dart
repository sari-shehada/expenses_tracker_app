import 'dart:ui' as ui;

import 'package:expenses_tracker/app/app_theme.dart';
import 'package:expenses_tracker/features/currencies/domain/currency.dart';
import 'package:expenses_tracker/features/currencies/presentation/widgets/currency_selector.dart';
import 'package:expenses_tracker/features/wallets/presentation/widgets/wallet_currency_step.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

const currencies = [
  Currency(
    code: 'AED',
    name: 'United Arab Emirates Dirham',
    symbol: 'AED',
    nativeSymbol: 'د.إ.‏',
    decimalDigits: 2,
  ),
  Currency(
    code: 'USD',
    name: 'US Dollar',
    symbol: r'$',
    nativeSymbol: r'$',
    decimalDigits: 2,
  ),
];

void main() {
  testWidgets('matches the Wallet currency step content and spacing', (
    tester,
  ) async {
    await _pumpStep(tester);

    expect(find.text('Create Wallet'), findsOneWidget);
    expect(find.text('Step 2 of 3'), findsOneWidget);
    expect(find.text('67% Complete'), findsOneWidget);
    expect(find.text('Select currency'), findsOneWidget);
    expect(find.text('Choose the currency for this wallet'), findsOneWidget);

    final selector = tester.widget<CurrencySelector>(
      find.byType(CurrencySelector),
    );
    expect(selector.searchPadding, const EdgeInsets.fromLTRB(20, 8, 20, 16));
    expect(selector.listPadding, const EdgeInsets.fromLTRB(20, 0, 20, 24));
  });

  testWidgets('keeps Continue disabled until the parent retains a selection', (
    tester,
  ) async {
    var continueCalls = 0;
    await _pumpStep(tester, onContinue: () => continueCalls++);

    final ctaFinder = find.byKey(const ValueKey('wallet-currency-continue'));
    expect(tester.widget<FilledButton>(ctaFinder).onPressed, isNull);
    expect(find.byIcon(Icons.check_rounded), findsNothing);

    await tester.tap(ctaFinder);
    expect(continueCalls, 0);

    await tester.tap(find.byKey(const ValueKey('USD')));
    await tester.pump();

    expect(find.byType(WalletCurrencyStep), findsOneWidget);
    expect(tester.widget<FilledButton>(ctaFinder).onPressed, isNotNull);
    expect(find.byIcon(Icons.check_rounded), findsOneWidget);
    expect(
      tester
          .getSemantics(find.byKey(const ValueKey('USD')))
          .flagsCollection
          .isSelected,
      ui.Tristate.isTrue,
    );

    await tester.tap(ctaFinder);
    expect(continueCalls, 1);
  });

  testWidgets('moves and restores the retained selection', (tester) async {
    await _pumpStep(tester, selectedCode: 'USD');

    expect(find.byIcon(Icons.check_rounded), findsOneWidget);
    expect(
      tester
          .getSemantics(find.byKey(const ValueKey('USD')))
          .flagsCollection
          .isSelected,
      ui.Tristate.isTrue,
    );

    await tester.tap(find.byKey(const ValueKey('AED')));
    await tester.pump();

    expect(find.byIcon(Icons.check_rounded), findsOneWidget);
    expect(
      tester
          .getSemantics(find.byKey(const ValueKey('AED')))
          .flagsCollection
          .isSelected,
      ui.Tristate.isTrue,
    );
    expect(
      tester
          .getSemantics(find.byKey(const ValueKey('USD')))
          .flagsCollection
          .isSelected,
      ui.Tristate.isFalse,
    );
  });

  testWidgets('meets tap-target and labeling accessibility guidelines', (
    tester,
  ) async {
    final semantics = tester.ensureSemantics();
    try {
      await _pumpStep(tester, selectedCode: 'USD');

      await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
      await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
    } finally {
      semantics.dispose();
    }
  });
}

Future<void> _pumpStep(
  WidgetTester tester, {
  String? selectedCode,
  VoidCallback? onContinue,
}) {
  tester.view.physicalSize = const Size(402, 874);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);

  return tester.pumpWidget(
    MaterialApp(
      theme: AppTheme.light,
      home: _WalletCurrencyStepHarness(
        initialSelectedCode: selectedCode,
        onContinue: onContinue ?? () {},
      ),
    ),
  );
}

class _WalletCurrencyStepHarness extends StatefulWidget {
  const _WalletCurrencyStepHarness({
    required this.initialSelectedCode,
    required this.onContinue,
  });

  final String? initialSelectedCode;
  final VoidCallback onContinue;

  @override
  State<_WalletCurrencyStepHarness> createState() =>
      _WalletCurrencyStepHarnessState();
}

class _WalletCurrencyStepHarnessState
    extends State<_WalletCurrencyStepHarness> {
  late String? _selectedCode = widget.initialSelectedCode;

  @override
  Widget build(BuildContext context) {
    return WalletCurrencyStep(
      currencies: currencies,
      selectedCode: _selectedCode,
      onSelected: (currency) => setState(() => _selectedCode = currency.code),
      onBack: () {},
      onContinue: widget.onContinue,
      ctaButtonKey: const ValueKey('wallet-currency-continue'),
    );
  }
}
