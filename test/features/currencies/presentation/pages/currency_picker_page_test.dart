import 'package:expenses_tracker/features/currencies/domain/currency.dart';
import 'package:expenses_tracker/features/currencies/presentation/pages/currency_picker_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
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

  testWidgets('searches currencies by code and name', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: CurrencyPickerPage(currencies: currencies)),
    );

    await tester.enterText(find.byType(TextField), 'dirham');
    await tester.pump();

    expect(find.byKey(const ValueKey('AED')), findsOneWidget);
    expect(find.byKey(const ValueKey('USD')), findsNothing);
  });

  testWidgets('returns the selected currency', (tester) async {
    Currency? selectedCurrency;

    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) => ElevatedButton(
            onPressed: () async {
              selectedCurrency = await Navigator.push<Currency>(
                context,
                MaterialPageRoute(
                  builder: (_) => const CurrencyPickerPage(
                    currencies: currencies,
                    selectedCode: 'USD',
                  ),
                ),
              );
            },
            child: const Text('Open picker'),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Open picker'));
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.check), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('AED')));
    await tester.pumpAndSettle();

    expect(selectedCurrency?.code, 'AED');
  });
}
