class Currency {
  const Currency({
    required this.code,
    required this.name,
    required this.symbol,
    required this.nativeSymbol,
    required this.decimalDigits,
  });

  final String code;
  final String name;
  final String symbol;
  final String nativeSymbol;
  final int decimalDigits;
}
