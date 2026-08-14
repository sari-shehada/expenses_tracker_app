import 'dart:convert';
import 'dart:io';

import 'package:expenses_tracker/features/currencies/presentation/currency_flag.dart';
import 'package:expenses_tracker/features/currencies/presentation/currency_flag_assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('provides a bundled SVG for every catalog currency', () async {
    final json = jsonDecode(
      await File('assets/data/currencies.json').readAsString(),
    );
    expect(json, isA<Map<String, dynamic>>());
    final currencyCodes = (json as Map<String, dynamic>).keys.toSet();

    expect(
      CurrencyFlagAssets.sourceFlagCodeByCurrencyCode.keys.toSet(),
      currencyCodes,
    );

    for (final currencyCode in currencyCodes) {
      final assetPath = CurrencyFlagAssets.forCurrencyCode(currencyCode);
      final asset = File(assetPath);
      expect(asset.existsSync(), isTrue, reason: '$assetPath is missing');
      expect(
        await asset.readAsString(),
        contains('<svg'),
        reason: '$assetPath is not an SVG',
      );
    }
  });

  test('uses regional and neutral artwork for shared currencies', () {
    expect(CurrencyFlagAssets.sourceFlagCodeByCurrencyCode['EUR'], 'eu');
    expect(CurrencyFlagAssets.sourceFlagCodeByCurrencyCode['XAF'], 'xx');
    expect(CurrencyFlagAssets.sourceFlagCodeByCurrencyCode['XOF'], 'xx');
  });

  test('falls back when a currency is outside the bundled catalog', () {
    expect(
      CurrencyFlagAssets.forCurrencyCode('unknown'),
      CurrencyFlagAssets.fallbackAssetPath,
    );
  });

  testWidgets('renders a bundled flag at an explicit size', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Center(
          child: CurrencyFlag(
            currencyCode: 'EUR',
            size: 40,
            semanticsLabel: 'Euro flag',
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    final picture = tester.widget<SvgPicture>(find.byType(SvgPicture));
    expect(picture.width, 40);
    expect(picture.height, 40);
    expect(picture.semanticsLabel, 'Euro flag');
  });
}
