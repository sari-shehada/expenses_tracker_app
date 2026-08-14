import 'package:flutter/material.dart';

import '../domain/wallet_appearance.dart';

class WalletColorPalette {
  const WalletColorPalette({
    required this.key,
    required this.name,
    required this.cardColor,
    required this.borderColor,
    required this.accentColor,
  });

  static const blue = WalletColorPalette(
    key: WalletAppearance.defaultColorKey,
    name: 'Blue',
    cardColor: Color(0xFFEFF6FF),
    borderColor: Color(0xFFBFDBFE),
    accentColor: Color(0xFF2563EB),
  );

  static const values = <WalletColorPalette>[
    blue,
    WalletColorPalette(
      key: 'green',
      name: 'Green',
      cardColor: Color(0xFFECFDF5),
      borderColor: Color(0xFFA7F3D0),
      accentColor: Color(0xFF10B981),
    ),
    WalletColorPalette(
      key: 'red',
      name: 'Red',
      cardColor: Color(0xFFFEF2F2),
      borderColor: Color(0xFFFECACA),
      accentColor: Color(0xFFEF4444),
    ),
    WalletColorPalette(
      key: 'orange',
      name: 'Orange',
      cardColor: Color(0xFFFFF7ED),
      borderColor: Color(0xFFFED7AA),
      accentColor: Color(0xFFF97316),
    ),
    WalletColorPalette(
      key: 'purple',
      name: 'Purple',
      cardColor: Color(0xFFF5F3FF),
      borderColor: Color(0xFFDDD6FE),
      accentColor: Color(0xFF8B5CF6),
    ),
    WalletColorPalette(
      key: 'pink',
      name: 'Pink',
      cardColor: Color(0xFFFDF2F8),
      borderColor: Color(0xFFFBCFE8),
      accentColor: Color(0xFFEC4899),
    ),
    WalletColorPalette(
      key: 'teal',
      name: 'Teal',
      cardColor: Color(0xFFF0FDFA),
      borderColor: Color(0xFF99F6E4),
      accentColor: Color(0xFF14B8A6),
    ),
    WalletColorPalette(
      key: 'navy',
      name: 'Navy',
      cardColor: Color(0xFFF1F5F9),
      borderColor: Color(0xFFCBD5E1),
      accentColor: Color(0xFF1E293B),
    ),
  ];

  final String key;
  final String name;
  final Color cardColor;
  final Color borderColor;
  final Color accentColor;

  static WalletColorPalette resolve(String key) {
    for (final palette in values) {
      if (palette.key == key) {
        return palette;
      }
    }

    return blue;
  }
}
