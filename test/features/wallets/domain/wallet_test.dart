import 'package:expenses_tracker/features/wallets/domain/wallet.dart';
import 'package:expenses_tracker/features/wallets/domain/wallet_appearance.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('uses the default appearance', () {
    const wallet = Wallet(id: 'wallet-id', name: 'Cash', currencyCode: 'USD');

    expect(wallet.colorKey, WalletAppearance.defaultColorKey);
    expect(wallet.iconKey, WalletAppearance.defaultIconKey);
  });

  test('compares Wallets by their values', () {
    const wallet = Wallet(
      id: 'wallet-id',
      name: 'Cash',
      currencyCode: 'USD',
      colorKey: 'sky',
      iconKey: 'cash',
    );

    expect(
      wallet,
      const Wallet(
        id: 'wallet-id',
        name: 'Cash',
        currencyCode: 'USD',
        colorKey: 'sky',
        iconKey: 'cash',
      ),
    );
  });
}
