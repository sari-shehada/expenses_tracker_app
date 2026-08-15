import 'dart:ui' as ui;

import 'package:expenses_tracker/app/app_theme.dart';
import 'package:expenses_tracker/features/currencies/domain/currency.dart';
import 'package:expenses_tracker/features/currencies/presentation/widgets/currency_selector.dart';
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
  testWidgets('leaves search unfocused by default', (tester) async {
    await _pumpSelector(tester, selectedCode: null, onSelected: (_) {});

    final searchFinder = find.byKey(const ValueKey('currency-search-field'));
    final editableText = tester.widget<EditableText>(
      find.descendant(of: searchFinder, matching: find.byType(EditableText)),
    );

    expect(editableText.focusNode.hasFocus, isFalse);
  });

  testWidgets('reports taps while leaving selection controlled by its parent', (
    tester,
  ) async {
    Currency? selectedCurrency;
    await _pumpSelector(
      tester,
      selectedCode: 'USD',
      onSelected: (currency) => selectedCurrency = currency,
    );

    final usdBefore = tester.getSemantics(find.byKey(const ValueKey('USD')));
    expect(usdBefore.flagsCollection.isSelected, ui.Tristate.isTrue);

    await tester.tap(find.byKey(const ValueKey('AED')));
    await tester.pump();

    expect(selectedCurrency?.code, 'AED');
    expect(find.byType(CurrencySelector), findsOneWidget);
    final usdAfter = tester.getSemantics(find.byKey(const ValueKey('USD')));
    expect(usdAfter.flagsCollection.isSelected, ui.Tristate.isTrue);
  });

  testWidgets('owns search filtering without changing caller selection', (
    tester,
  ) async {
    await _pumpSelector(tester, selectedCode: 'USD', onSelected: (_) {});

    await tester.enterText(
      find.byKey(const ValueKey('currency-search-field')),
      'dirham',
    );
    await tester.pump();

    expect(find.byKey(const ValueKey('AED')), findsOneWidget);
    expect(find.byKey(const ValueKey('USD')), findsNothing);

    await tester.enterText(
      find.byKey(const ValueKey('currency-search-field')),
      '',
    );
    await tester.pump();

    final usdSemantics = tester.getSemantics(find.byKey(const ValueKey('USD')));
    expect(usdSemantics.flagsCollection.isSelected, ui.Tristate.isTrue);
  });

  testWidgets('restores search and filtering from an external controller', (
    tester,
  ) async {
    final controller = TextEditingController(text: 'dirham');
    addTearDown(controller.dispose);

    await _pumpSelector(
      tester,
      selectedCode: null,
      searchController: controller,
      onSelected: (_) {},
    );

    expect(find.byKey(const ValueKey('AED')), findsOneWidget);
    expect(find.byKey(const ValueKey('USD')), findsNothing);
    expect(
      tester
          .widget<TextField>(
            find.byKey(const ValueKey('currency-search-field')),
          )
          .controller
          ?.text,
      'dirham',
    );
  });
}

Future<void> _pumpSelector(
  WidgetTester tester, {
  required String? selectedCode,
  required ValueChanged<Currency> onSelected,
  TextEditingController? searchController,
}) {
  tester.view.physicalSize = const Size(390, 780);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);

  return tester.pumpWidget(
    MaterialApp(
      theme: AppTheme.light,
      home: Scaffold(
        body: CurrencySelector(
          currencies: currencies,
          selectedCode: selectedCode,
          searchController: searchController,
          onSelected: onSelected,
        ),
      ),
    ),
  );
}
