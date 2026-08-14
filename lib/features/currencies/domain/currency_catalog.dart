import 'currency.dart';

abstract interface class CurrencyCatalog {
  Future<void> initialize();

  List<Currency> get currencies;

  Currency? findByCode(String code);
}
