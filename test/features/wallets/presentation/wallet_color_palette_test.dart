import 'package:expenses_tracker/features/wallets/presentation/wallet_color_palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('provides the agreed Wallet color palettes', () {
    expect(WalletColorPalette.values.map((palette) => palette.key), [
      'sage',
      'sky',
      'sand',
      'lavender',
      'rose',
      'teal',
      'peach',
      'slate',
    ]);
    expect(WalletColorPalette.sage.cardColor, const Color(0xFFEFF5EA));
    expect(WalletColorPalette.sage.borderColor, const Color(0xFFCBDDBD));
    expect(WalletColorPalette.sage.accentColor, const Color(0xFF2F6B3C));
  });

  test('resolves a palette by its stable key', () {
    expect(WalletColorPalette.resolve('sky').name, 'Sky');
  });

  test('falls back to Sage for an unknown key', () {
    expect(WalletColorPalette.resolve('unknown'), WalletColorPalette.sage);
  });
}
