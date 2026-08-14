import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'currency_flag_assets.dart';

class CurrencyFlag extends StatelessWidget {
  const CurrencyFlag({
    required this.currencyCode,
    this.size = 40,
    this.semanticsLabel,
    super.key,
  });

  final String currencyCode;
  final double size;
  final String? semanticsLabel;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      CurrencyFlagAssets.forCurrencyCode(currencyCode),
      width: size,
      height: size,
      fit: BoxFit.contain,
      semanticsLabel: semanticsLabel,
    );
  }
}
