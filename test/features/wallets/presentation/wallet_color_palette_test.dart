import 'package:expenses_tracker/features/wallets/presentation/wallet_color_palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('provides the agreed Wallet color palettes', () {
    expect(WalletColorPalette.values.map((palette) => palette.key), [
      'blue',
      'green',
      'red',
      'orange',
      'purple',
      'pink',
      'teal',
      'navy',
    ]);
    expect(WalletColorPalette.values.map((palette) => palette.name), [
      'Blue',
      'Green',
      'Red',
      'Orange',
      'Purple',
      'Pink',
      'Teal',
      'Navy',
    ]);
    expect(
      WalletColorPalette.values.map((palette) => palette.accentColor),
      const [
        Color(0xFF2563EB),
        Color(0xFF10B981),
        Color(0xFFEF4444),
        Color(0xFFF97316),
        Color(0xFF8B5CF6),
        Color(0xFFEC4899),
        Color(0xFF14B8A6),
        Color(0xFF1E293B),
      ],
    );
    expect(WalletColorPalette.blue.cardColor, const Color(0xFFEFF6FF));
    expect(WalletColorPalette.blue.borderColor, const Color(0xFFBFDBFE));
    expect(WalletColorPalette.blue.accentColor, const Color(0xFF2563EB));
  });

  test('resolves supported keys and falls back legacy keys to Blue', () {
    expect(WalletColorPalette.resolve('purple').name, 'Purple');
    expect(WalletColorPalette.resolve('sage'), WalletColorPalette.blue);
    expect(WalletColorPalette.resolve('unknown'), WalletColorPalette.blue);
  });
}
