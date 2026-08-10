class Wallet {
  const Wallet({
    required this.id,
    required this.name,
    required this.currencyCode,
  });

  final String id;
  final String name;
  final String currencyCode;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is Wallet &&
            id == other.id &&
            name == other.name &&
            currencyCode == other.currencyCode;
  }

  @override
  int get hashCode => Object.hash(id, name, currencyCode);
}
