import 'package:expenses_tracker/features/currencies/data/asset_currency_catalog.dart';
import 'package:expenses_tracker/features/currencies/data/currency_asset_reader.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('maps required values and sorts currencies by name', () async {
    final catalog = AssetCurrencyCatalog(
      assetReader: _FakeCurrencyAssetReader(r'''
        {
          "USD": {
            "code": "USD",
            "name": "US Dollar",
            "symbol": "$",
            "symbol_native": "$",
            "decimal_digits": 2,
            "rounding": 0
          },
          "AED": {
            "code": "AED",
            "name": "United Arab Emirates Dirham",
            "symbol": "AED",
            "symbol_native": "د.إ.‏",
            "decimal_digits": 2,
            "rounding": 0
          }
        }
      '''),
    );

    final currencies = await catalog.getAll();

    expect(currencies.map((currency) => currency.code), ['USD', 'AED']);
    expect(currencies.last.nativeSymbol, 'د.إ.‏');
    expect(currencies.first.decimalDigits, 2);
  });

  test('finds a currency using a normalized code', () async {
    final catalog = AssetCurrencyCatalog(
      assetReader: _FakeCurrencyAssetReader(_singleCurrencyJson),
    );

    final currency = await catalog.findByCode(' usd ');

    expect(currency?.name, 'US Dollar');
  });

  test('returns null when a currency is absent', () async {
    final catalog = AssetCurrencyCatalog(
      assetReader: _FakeCurrencyAssetReader(_singleCurrencyJson),
    );

    expect(await catalog.findByCode('CAD'), isNull);
  });

  test('rejects malformed catalog data', () {
    final catalog = AssetCurrencyCatalog(
      assetReader: _FakeCurrencyAssetReader('{"USD": {"code": "CAD"}}'),
    );

    expect(catalog.getAll(), throwsA(isA<CurrencyCatalogFormatException>()));
  });

  test('retries loading after an asset read failure', () async {
    final assetReader = _FailingThenWorkingAssetReader();
    final catalog = AssetCurrencyCatalog(assetReader: assetReader);

    await expectLater(catalog.getAll(), throwsA(isA<StateError>()));
    final currencies = await catalog.getAll();

    expect(assetReader.loadCalls, 2);
    expect(currencies.single.code, 'USD');
  });
}

const _singleCurrencyJson = r'''
  {
    "USD": {
      "code": "USD",
      "name": "US Dollar",
      "symbol": "$",
      "symbol_native": "$",
      "decimal_digits": 2
    }
  }
''';

class _FakeCurrencyAssetReader implements CurrencyAssetReader {
  const _FakeCurrencyAssetReader(this.contents);

  final String contents;

  @override
  Future<String> loadString(String assetPath) async => contents;
}

class _FailingThenWorkingAssetReader implements CurrencyAssetReader {
  int loadCalls = 0;

  @override
  Future<String> loadString(String assetPath) async {
    loadCalls++;
    if (loadCalls == 1) {
      throw StateError('Asset unavailable');
    }
    return _singleCurrencyJson;
  }
}
