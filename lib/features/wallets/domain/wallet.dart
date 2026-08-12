import 'wallet_appearance.dart';

class Wallet {
  const Wallet({
    required this.id,
    required this.name,
    required this.currencyCode,
    this.colorKey = WalletAppearance.defaultColorKey,
    this.iconKey = WalletAppearance.defaultIconKey,
  });

  final String id;
  final String name;
  final String currencyCode;
  final String colorKey;
  final String iconKey;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is Wallet &&
            id == other.id &&
            name == other.name &&
            currencyCode == other.currencyCode &&
            colorKey == other.colorKey &&
            iconKey == other.iconKey;
  }

  @override
  int get hashCode => Object.hash(id, name, currencyCode, colorKey, iconKey);
}
