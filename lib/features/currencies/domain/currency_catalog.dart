import 'currency.dart';

abstract interface class CurrencyCatalog {
  Future<List<Currency>> getAll();

  Future<Currency?> findByCode(String code);
}
