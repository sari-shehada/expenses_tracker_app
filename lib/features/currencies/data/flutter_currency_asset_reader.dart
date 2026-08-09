import 'package:flutter/services.dart';

import 'currency_asset_reader.dart';

/// Loads bundled currency data through Flutter's asset bundle.
///
/// An [AssetBundle] may be supplied when a caller needs a bundle other than
/// Flutter's default [rootBundle].
class FlutterCurrencyAssetReader implements CurrencyAssetReader {
  FlutterCurrencyAssetReader({AssetBundle? assetBundle})
    : _assetBundle = assetBundle ?? rootBundle;

  final AssetBundle _assetBundle;

  @override
  Future<String> loadString(String assetPath) =>
      _assetBundle.loadString(assetPath);
}
