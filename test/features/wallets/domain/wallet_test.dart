import 'package:expenses_tracker/features/wallets/domain/wallet.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('compares Wallets by their values', () {
    const wallet = Wallet(id: 'wallet-id', name: 'Cash', currencyCode: 'USD');

    expect(
      wallet,
      const Wallet(id: 'wallet-id', name: 'Cash', currencyCode: 'USD'),
    );
  });
}
