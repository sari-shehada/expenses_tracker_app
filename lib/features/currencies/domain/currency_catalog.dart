import 'currency.dart';

abstract interface class CurrencyCatalog {
  Future<void> initialize();

  //TODO: Remove this and add a public getters that returns a private list instead
  Future<List<Currency>> getAll();

  Future<Currency?> findByCode(String code);
}
