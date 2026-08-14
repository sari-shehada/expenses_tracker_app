import 'package:expenses_tracker/features/currencies/domain/currency.dart';
import 'package:expenses_tracker/features/currencies/domain/currency_catalog.dart';
import 'package:expenses_tracker/features/currencies/presentation/currency_picker_field.dart';
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

  testWidgets('opens the selector and reports a chosen currency', (
    tester,
  ) async {
    Currency? selectedCurrency;
    final catalog = _FakeCurrencyCatalog();

    await tester.pumpWidget(
      MaterialApp(
        home: CurrencyPickerField(
          catalog: catalog,
          onSelected: (currency) => selectedCurrency = currency,
        ),
      ),
    );

    expect(find.text('Loading currencies'), findsNothing);
    expect(find.byType(CircularProgressIndicator), findsNothing);

    await tester.tap(find.text('Select currency'));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('AED')));
    await tester.pumpAndSettle();

    expect(selectedCurrency?.code, 'AED');
    expect(catalog.currencyReads, 1);
  });

  testWidgets('shows selected currency details in a rounded field', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: CurrencyPickerField(
          catalog: _FakeCurrencyCatalog(),
          selectedCurrency: currencies[1],
          onSelected: (_) {},
        ),
      ),
    );
    await tester.pump();

    expect(find.text('Currency'), findsOneWidget);
    expect(find.text(r'$'), findsOneWidget);
    expect(find.text('USD'), findsOneWidget);
    expect(find.text('US Dollar'), findsOneWidget);
    expect(find.byIcon(Icons.chevron_right_rounded), findsOneWidget);

    final surface = tester.widget<Material>(
      find.byKey(const ValueKey('currency-picker-surface')),
    );
    final shape = surface.shape! as RoundedRectangleBorder;
    expect(shape.borderRadius, BorderRadius.circular(24));
  });
}

class _FakeCurrencyCatalog implements CurrencyCatalog {
  static const _availableCurrencies = [
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

  int currencyReads = 0;

  @override
  Future<void> initialize() async {}

  @override
  Currency? findByCode(String code) => null;

  @override
  List<Currency> get currencies {
    currencyReads++;
    return _availableCurrencies;
  }
}
