import 'package:expenses_tracker/features/wallets/presentation/wallet_icon_catalog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('provides the agreed Wallet icon choices', () {
    expect(WalletIconOption.values.map((option) => option.key), [
      'wallet',
      'cash',
      'card',
      'bank',
      'person',
      'travel',
      'savings',
      'business',
    ]);
    expect(WalletIconOption.resolve('person').icon, Icons.person_outline);
  });

  test('falls back to the generic Wallet icon for an unknown key', () {
    expect(WalletIconOption.resolve('unknown'), WalletIconOption.wallet);
  });
}
