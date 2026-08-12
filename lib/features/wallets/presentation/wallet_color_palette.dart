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

  static const sage = WalletColorPalette(
    key: WalletAppearance.defaultColorKey,
    name: 'Sage',
    cardColor: Color(0xFFEFF5EA),
    borderColor: Color(0xFFCBDDBD),
    accentColor: Color(0xFF2F6B3C),
  );

  static const values = <WalletColorPalette>[
    sage,
    WalletColorPalette(
      key: 'sky',
      name: 'Sky',
      cardColor: Color(0xFFEBF3FC),
      borderColor: Color(0xFFC6DAF1),
      accentColor: Color(0xFF285F9E),
    ),
    WalletColorPalette(
      key: 'sand',
      name: 'Sand',
      cardColor: Color(0xFFFFF5DE),
      borderColor: Color(0xFFF3D99B),
      accentColor: Color(0xFF8A5A00),
    ),
    WalletColorPalette(
      key: 'lavender',
      name: 'Lavender',
      cardColor: Color(0xFFF4EFFB),
      borderColor: Color(0xFFDCCEEF),
      accentColor: Color(0xFF634A8E),
    ),
    WalletColorPalette(
      key: 'rose',
      name: 'Rose',
      cardColor: Color(0xFFFBEFF1),
      borderColor: Color(0xFFEDCBD2),
      accentColor: Color(0xFF934656),
    ),
    WalletColorPalette(
      key: 'teal',
      name: 'Teal',
      cardColor: Color(0xFFEAF6F3),
      borderColor: Color(0xFFBFDCD5),
      accentColor: Color(0xFF246B60),
    ),
    WalletColorPalette(
      key: 'peach',
      name: 'Peach',
      cardColor: Color(0xFFFFF0E9),
      borderColor: Color(0xFFF0CCBD),
      accentColor: Color(0xFF934E31),
    ),
    WalletColorPalette(
      key: 'slate',
      name: 'Slate',
      cardColor: Color(0xFFF0F2F5),
      borderColor: Color(0xFFD4D8DE),
      accentColor: Color(0xFF4B596C),
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

    return sage;
  }
}
