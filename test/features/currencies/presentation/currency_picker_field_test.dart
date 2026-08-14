import 'dart:async';

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

  testWidgets('shows loading while the catalog is loading', (tester) async {
    final catalog = _ControllableCurrencyCatalog();

    await tester.pumpWidget(
      MaterialApp(
        home: CurrencyPickerField(catalog: catalog, onSelected: (_) {}),
      ),
    );

    expect(find.text('Loading currencies'), findsOneWidget);

    catalog.complete(currencies);
    await tester.pump();
  });

  testWidgets('retries a failed catalog load', (tester) async {
    final catalog = _FlakyCurrencyCatalog(shouldFail: true);

    await tester.pumpWidget(
      MaterialApp(
        home: CurrencyPickerField(catalog: catalog, onSelected: (_) {}),
      ),
    );
    await tester.pump();

    expect(find.text('Could not load currencies.'), findsOneWidget);

    catalog.shouldFail = false;
    await tester.tap(find.text('Try again'));
    await tester.pumpAndSettle();

    expect(find.text('Select currency'), findsOneWidget);
    expect(catalog.loadCalls, 2);
  });

  testWidgets('opens the selector and reports a chosen currency', (
    tester,
  ) async {
    Currency? selectedCurrency;

    await tester.pumpWidget(
      MaterialApp(
        home: CurrencyPickerField(
          catalog: _FlakyCurrencyCatalog(),
          onSelected: (currency) => selectedCurrency = currency,
        ),
      ),
    );
    await tester.pump();

    await tester.tap(find.text('Select currency'));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('AED')));
    await tester.pumpAndSettle();

    expect(selectedCurrency?.code, 'AED');
  });

  testWidgets('shows selected currency details in a rounded field', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: CurrencyPickerField(
          catalog: _FlakyCurrencyCatalog(),
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

class _ControllableCurrencyCatalog implements CurrencyCatalog {
  final _currencies = Completer<List<Currency>>();

  void complete(List<Currency> currencies) => _currencies.complete(currencies);

  @override
  Future<void> initialize() async {}

  @override
  Future<Currency?> findByCode(String code) async => null;

  @override
  Future<List<Currency>> getAll() => _currencies.future;
}

class _FlakyCurrencyCatalog implements CurrencyCatalog {
  _FlakyCurrencyCatalog({this.shouldFail = false});

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

  bool shouldFail;
  int loadCalls = 0;

  @override
  Future<void> initialize() async {}

  @override
  Future<Currency?> findByCode(String code) async => null;

  @override
  Future<List<Currency>> getAll() async {
    loadCalls++;
    if (shouldFail) {
      throw StateError('Catalog unavailable');
    }
    return _availableCurrencies;
  }
}
