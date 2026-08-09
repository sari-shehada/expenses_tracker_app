/// Loads text from a currency data source.
///
/// This boundary keeps the catalog independent of Flutter asset loading and
/// makes it straightforward to provide controlled data in tests.
abstract interface class CurrencyAssetReader {
  Future<String> loadString(String assetPath);
}
