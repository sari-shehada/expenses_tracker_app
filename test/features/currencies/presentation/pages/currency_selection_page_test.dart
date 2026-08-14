import 'dart:ui' as ui;

import 'package:expenses_tracker/app/app_theme.dart';
import 'package:expenses_tracker/features/currencies/domain/currency.dart';
import 'package:expenses_tracker/features/currencies/presentation/currency_flag.dart';
import 'package:expenses_tracker/features/currencies/presentation/pages/currency_selection_page.dart';
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
  testWidgets('shows the redesigned catalog rows in caller order', (
    tester,
  ) async {
    await _pumpPage(tester, selectedCode: 'USD');

    expect(find.text('Select Currency'), findsOneWidget);
    expect(find.widgetWithText(TextField, 'Search currency'), findsOneWidget);
    expect(find.byType(CurrencyFlag), findsNWidgets(2));

    final aedTop = tester.getTopLeft(find.byKey(const ValueKey('AED'))).dy;
    final usdTop = tester.getTopLeft(find.byKey(const ValueKey('USD'))).dy;
    expect(aedTop, lessThan(usdTop));

    final aedFlag = tester.widget<CurrencyFlag>(
      find.descendant(
        of: find.byKey(const ValueKey('AED')),
        matching: find.byType(CurrencyFlag),
      ),
    );
    expect(aedFlag.currencyCode, 'AED');
    expect(aedFlag.size, 40);

    final usdSemantics = tester.getSemantics(find.byKey(const ValueKey('USD')));
    expect(usdSemantics.label, r'USD, US Dollar, $');
    expect(usdSemantics.flagsCollection.isSelected, ui.Tristate.isTrue);
    expect(find.byIcon(Icons.check_rounded), findsOneWidget);
  });

  testWidgets('searches currencies by code and name', (tester) async {
    await _pumpPage(tester);

    await tester.enterText(
      find.byKey(const ValueKey('currency-search-field')),
      'dirham',
    );
    await tester.pump();

    expect(find.byKey(const ValueKey('AED')), findsOneWidget);
    expect(find.byKey(const ValueKey('USD')), findsNothing);

    await tester.enterText(
      find.byKey(const ValueKey('currency-search-field')),
      'usd',
    );
    await tester.pump();

    expect(find.byKey(const ValueKey('AED')), findsNothing);
    expect(find.byKey(const ValueKey('USD')), findsOneWidget);
  });

  testWidgets('centers the search field content vertically', (tester) async {
    await _pumpPage(tester);

    final fieldCenter = tester
        .getCenter(find.byKey(const ValueKey('currency-search-field')))
        .dy;
    final textCenter = tester.getCenter(find.byType(EditableText)).dy;
    final iconCenter = tester.getCenter(find.byIcon(Icons.search_rounded)).dy;

    expect(textCenter, closeTo(fieldCenter, 0.5));
    expect(iconCenter, closeTo(fieldCenter, 0.5));
  });

  testWidgets('shows an empty state when search has no matches', (
    tester,
  ) async {
    await _pumpPage(tester);

    await tester.enterText(
      find.byKey(const ValueKey('currency-search-field')),
      'not-a-currency',
    );
    await tester.pump();

    expect(find.text('No currencies found'), findsOneWidget);
    expect(find.byType(CurrencyFlag), findsNothing);
  });

  testWidgets('returns the selected currency immediately', (tester) async {
    Currency? selectedCurrency;

    await _pumpLauncher(
      tester,
      onResult: (currency) => selectedCurrency = currency,
    );

    await tester.tap(find.text('Open picker'));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('AED')));
    await tester.pumpAndSettle();

    expect(selectedCurrency?.code, 'AED');
  });

  testWidgets('back button closes the page without a selection', (
    tester,
  ) async {
    Currency? selectedCurrency = currencies.first;

    await _pumpLauncher(
      tester,
      onResult: (currency) => selectedCurrency = currency,
    );

    await tester.tap(find.text('Open picker'));
    await tester.pumpAndSettle();
    await tester.tap(
      find.byKey(const ValueKey('currency-selection-back-button')),
    );
    await tester.pumpAndSettle();

    expect(selectedCurrency, isNull);
  });

  testWidgets('meets tap-target and labeling accessibility guidelines', (
    tester,
  ) async {
    final semantics = tester.ensureSemantics();
    try {
      await _pumpPage(tester, selectedCode: 'USD');

      await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
      await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
    } finally {
      semantics.dispose();
    }
  });
}

Future<void> _pumpPage(WidgetTester tester, {String? selectedCode}) {
  tester.view.physicalSize = const Size(390, 844);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);

  return tester.pumpWidget(
    MaterialApp(
      theme: AppTheme.light,
      home: CurrencySelectionPage(
        currencies: currencies,
        selectedCode: selectedCode,
      ),
    ),
  );
}

Future<void> _pumpLauncher(
  WidgetTester tester, {
  required ValueChanged<Currency?> onResult,
}) {
  tester.view.physicalSize = const Size(390, 844);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);

  return tester.pumpWidget(
    MaterialApp(
      theme: AppTheme.light,
      home: Builder(
        builder: (context) => Scaffold(
          body: Center(
            child: FilledButton(
              onPressed: () async {
                final result = await Navigator.push<Currency>(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const CurrencySelectionPage(
                      currencies: currencies,
                      selectedCode: 'USD',
                    ),
                  ),
                );
                onResult(result);
              },
              child: const Text('Open picker'),
            ),
          ),
        ),
      ),
    ),
  );
}
