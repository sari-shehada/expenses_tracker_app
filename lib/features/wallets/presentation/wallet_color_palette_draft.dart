import 'package:flutter/material.dart';

/// Temporary design reference for the proposed Wallet color palettes.
///
/// This file is intentionally not connected to the Wallet model or UI yet.
abstract final class WalletColorPaletteDraft {
  static const palettes = <WalletColorPaletteDraftValue>[
    WalletColorPaletteDraftValue(
      key: 'sage',
      name: 'Sage',
      cardColor: Color(0xFFEFF5EA),
      borderColor: Color(0xFFCBDDBD),
      accentColor: Color(0xFF2F6B3C),
    ),
    WalletColorPaletteDraftValue(
      key: 'sky',
      name: 'Sky',
      cardColor: Color(0xFFEBF3FC),
      borderColor: Color(0xFFC6DAF1),
      accentColor: Color(0xFF285F9E),
    ),
    WalletColorPaletteDraftValue(
      key: 'sand',
      name: 'Sand',
      cardColor: Color(0xFFFFF5DE),
      borderColor: Color(0xFFF3D99B),
      accentColor: Color(0xFF8A5A00),
    ),
    WalletColorPaletteDraftValue(
      key: 'lavender',
      name: 'Lavender',
      cardColor: Color(0xFFF4EFFB),
      borderColor: Color(0xFFDCCEEF),
      accentColor: Color(0xFF634A8E),
    ),
    WalletColorPaletteDraftValue(
      key: 'rose',
      name: 'Rose',
      cardColor: Color(0xFFFBEFF1),
      borderColor: Color(0xFFEDCBD2),
      accentColor: Color(0xFF934656),
    ),
    WalletColorPaletteDraftValue(
      key: 'teal',
      name: 'Teal',
      cardColor: Color(0xFFEAF6F3),
      borderColor: Color(0xFFBFDCD5),
      accentColor: Color(0xFF246B60),
    ),
    WalletColorPaletteDraftValue(
      key: 'peach',
      name: 'Peach',
      cardColor: Color(0xFFFFF0E9),
      borderColor: Color(0xFFF0CCBD),
      accentColor: Color(0xFF934E31),
    ),
    WalletColorPaletteDraftValue(
      key: 'slate',
      name: 'Slate',
      cardColor: Color(0xFFF0F2F5),
      borderColor: Color(0xFFD4D8DE),
      accentColor: Color(0xFF4B596C),
    ),
  ];
}

class WalletColorPaletteDraftValue {
  const WalletColorPaletteDraftValue({
    required this.key,
    required this.name,
    required this.cardColor,
    required this.borderColor,
    required this.accentColor,
  });

  final String key;
  final String name;
  final Color cardColor;
  final Color borderColor;
  final Color accentColor;
}
