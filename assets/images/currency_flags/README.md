# Currency flag assets

These SVGs are vendored from [HatScripts/circle-flags](https://github.com/HatScripts/circle-flags) at revision `379588b5da95482d6bbf10bd45644a35b0609ea6`.

Each currency asset is named after its ISO 4217 currency code. The source country or regional flag is recorded in `CurrencyFlagAssets.sourceFlagCodeByCurrencyCode`. EUR uses the European Union flag. XAF and XOF use the upstream neutral placeholder because neither currency belongs to one country.

Run `dart run tool/sync_currency_flags.dart` from the application root to verify the mapping against `assets/data/currencies.json` and refresh the vendored files from the pinned revision.

The upstream MIT license is preserved in `LICENSE.md`.
