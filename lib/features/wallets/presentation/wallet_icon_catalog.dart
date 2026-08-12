import 'package:flutter/material.dart';

import '../domain/wallet_appearance.dart';

class WalletIconOption {
  const WalletIconOption({
    required this.key,
    required this.name,
    required this.icon,
  });

  static const wallet = WalletIconOption(
    key: WalletAppearance.defaultIconKey,
    name: 'Wallet',
    icon: Icons.account_balance_wallet_outlined,
  );

  static const values = <WalletIconOption>[
    wallet,
    WalletIconOption(key: 'cash', name: 'Cash', icon: Icons.payments_outlined),
    WalletIconOption(
      key: 'card',
      name: 'Card',
      icon: Icons.credit_card_outlined,
    ),
    WalletIconOption(
      key: 'bank',
      name: 'Bank',
      icon: Icons.account_balance_outlined,
    ),
    WalletIconOption(key: 'person', name: 'Person', icon: Icons.person_outline),
    WalletIconOption(
      key: 'travel',
      name: 'Travel',
      icon: Icons.flight_outlined,
    ),
    WalletIconOption(
      key: 'savings',
      name: 'Savings',
      icon: Icons.savings_outlined,
    ),
    WalletIconOption(
      key: 'business',
      name: 'Business',
      icon: Icons.business_center_outlined,
    ),
  ];

  final String key;
  final String name;
  final IconData icon;

  static WalletIconOption resolve(String key) {
    for (final option in values) {
      if (option.key == key) {
        return option;
      }
    }

    return wallet;
  }
}
