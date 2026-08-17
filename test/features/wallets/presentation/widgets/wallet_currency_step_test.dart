import 'dart:ui' as ui;

import 'package:expenses_tracker/app/app_theme.dart';
import 'package:expenses_tracker/features/currencies/domain/currency.dart';
import 'package:expenses_tracker/features/currencies/presentation/widgets/currency_selector.dart';
import 'package:expenses_tracker/features/wallets/presentation/widgets/wallet_currency_step.dart';
import 'package:expenses_tracker/features/wallets/presentation/widgets/wallet_creation_step_scroll_view.dart';
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

const longCurrencyList = [
  ...currencies,
  Currency(
    code: 'EUR',
    name: 'Euro',
    symbol: '€',
    nativeSymbol: '€',
    decimalDigits: 2,
  ),
  Currency(
    code: 'GBP',
    name: 'British Pound',
    symbol: '£',
    nativeSymbol: '£',
    decimalDigits: 2,
  ),
  Currency(
    code: 'JPY',
    name: 'Japanese Yen',
    symbol: '¥',
    nativeSymbol: '￥',
    decimalDigits: 0,
  ),
  Currency(
    code: 'CAD',
    name: 'Canadian Dollar',
    symbol: r'CA$',
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
    expect(selector.listPadding, const EdgeInsets.fromLTRB(20, 0, 20, 0));
    expect(find.byType(WalletCreationStepScrollView), findsOneWidget);
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

  testWidgets('allows currency rows to scroll beneath the CTA', (tester) async {
    await _pumpStep(
      tester,
      currencyOptions: longCurrencyList,
      size: const Size(320, 568),
    );

    final ctaRect = tester.getRect(
      find.byKey(const ValueKey('wallet-currency-continue')),
    );
    Rect? overlappingRowRect;

    for (final currency in longCurrencyList) {
      final rowFinder = find.byKey(ValueKey(currency.code));
      if (rowFinder.evaluate().isEmpty) {
        continue;
      }

      final rowRect = tester.getRect(rowFinder);
      if (rowRect.overlaps(ctaRect)) {
        overlappingRowRect = rowRect;
        break;
      }
    }

    expect(overlappingRowRect, isNotNull);
    expect(overlappingRowRect!.left, lessThan(ctaRect.left));
    expect(overlappingRowRect.right, greaterThan(ctaRect.right));
  });

  testWidgets('scrolls the final currency above the CTA', (tester) async {
    await _pumpStep(
      tester,
      currencyOptions: longCurrencyList,
      size: const Size(320, 568),
    );

    final scrollable = find.descendant(
      of: find.byType(WalletCreationStepScrollView),
      matching: find.byType(Scrollable),
    );
    final position = tester.state<ScrollableState>(scrollable).position;
    position.jumpTo(position.maxScrollExtent);
    await tester.pump();

    final finalCurrencyRect = tester.getRect(find.byKey(const ValueKey('CAD')));
    final ctaRect = tester.getRect(
      find.byKey(const ValueKey('wallet-currency-continue')),
    );

    expect(ctaRect.top - finalCurrencyRect.bottom, closeTo(24, 0.01));
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
  List<Currency> currencyOptions = currencies,
  Size size = const Size(402, 874),
}) {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);

  return tester.pumpWidget(
    MaterialApp(
      theme: AppTheme.light,
      home: _WalletCurrencyStepHarness(
        currencies: currencyOptions,
        initialSelectedCode: selectedCode,
        onContinue: onContinue ?? () {},
      ),
    ),
  );
}

class _WalletCurrencyStepHarness extends StatefulWidget {
  const _WalletCurrencyStepHarness({
    required this.currencies,
    required this.initialSelectedCode,
    required this.onContinue,
  });

  final List<Currency> currencies;
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
      currencies: widget.currencies,
      selectedCode: _selectedCode,
      onSelected: (currency) => setState(() => _selectedCode = currency.code),
      onBack: () {},
      onContinue: widget.onContinue,
      ctaButtonKey: const ValueKey('wallet-currency-continue'),
    );
  }
}
