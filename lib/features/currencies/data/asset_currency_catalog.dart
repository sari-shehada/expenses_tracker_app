import 'dart:convert';

import '../domain/currency.dart';
import '../domain/currency_catalog.dart';
import 'currency_asset_reader.dart';

class AssetCurrencyCatalog implements CurrencyCatalog {
  AssetCurrencyCatalog({required this.assetReader});

  static const assetPath = 'assets/data/currencies.json';

  final CurrencyAssetReader assetReader;
  List<Currency>? _currencies;
  Future<List<Currency>>? _loading;

  @override
  Future<void> initialize() async {
    if (_currencies != null) {
      return;
    }

    final loading = _loading ??= _loadCurrencies();

    try {
      _currencies = await loading;
    } finally {
      if (identical(_loading, loading)) {
        _loading = null;
      }
    }
  }

  @override
  Future<List<Currency>> getAll() async {
    await initialize();
    return _currencies!;
  }

  @override
  Future<Currency?> findByCode(String code) async {
    final normalizedCode = code.trim().toUpperCase();
    final currencies = await getAll();

    for (final currency in currencies) {
      if (currency.code == normalizedCode) {
        return currency;
      }
    }

    return null;
  }

  Future<List<Currency>> _loadCurrencies() async {
    final contents = await assetReader.loadString(assetPath);
    final json = jsonDecode(contents);

    if (json is! Map<String, dynamic>) {
      throw const CurrencyCatalogFormatException();
    }

    final currencies =
        json.entries
            .map((entry) => _currencyFromJson(entry.key, entry.value))
            .toList()
          ..sort((first, second) => first.name.compareTo(second.name));

    return List.unmodifiable(currencies);
  }

  Currency _currencyFromJson(String key, Object? value) {
    if (value is! Map<String, dynamic>) {
      throw const CurrencyCatalogFormatException();
    }

    final code = value['code'];
    final name = value['name'];
    final symbol = value['symbol'];
    final nativeSymbol = value['symbol_native'];
    final decimalDigits = value['decimal_digits'];

    if (code is! String ||
        code != key ||
        name is! String ||
        symbol is! String ||
        nativeSymbol is! String ||
        decimalDigits is! num) {
      throw const CurrencyCatalogFormatException();
    }

    return Currency(
      code: code,
      name: name,
      symbol: symbol,
      nativeSymbol: nativeSymbol,
      decimalDigits: decimalDigits.toInt(),
    );
  }
}

class CurrencyCatalogFormatException implements Exception {
  const CurrencyCatalogFormatException();
}
