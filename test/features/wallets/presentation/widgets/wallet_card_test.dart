import 'package:expenses_tracker/app/app_theme.dart';
import 'package:expenses_tracker/features/wallets/domain/wallet.dart';
import 'package:expenses_tracker/features/wallets/presentation/wallet_color_palette.dart';
import 'package:expenses_tracker/features/wallets/presentation/widgets/wallet_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('shows established Wallet information and stored appearance', (
    tester,
  ) async {
    await _pumpCard(
      tester,
      wallet: const Wallet(
        id: 'travel-id',
        name: 'Travel card',
        currencyCode: 'USD',
        colorKey: 'orange',
        iconKey: 'travel',
      ),
    );

    expect(find.text('Travel card'), findsOneWidget);
    expect(find.text('USD'), findsOneWidget);
    expect(find.byIcon(Icons.flight_outlined), findsOneWidget);
    expect(find.text('Recent activity'), findsNothing);

    final surface = tester.widget<Container>(
      find.byKey(const ValueKey('wallet-card-surface-travel-id')),
    );
    final decoration = surface.decoration! as BoxDecoration;
    expect(decoration.color, WalletColorPalette.resolve('orange').cardColor);
    expect(
      (decoration.border! as Border).top.color,
      WalletColorPalette.resolve('orange').borderColor,
    );
  });

  testWidgets('falls back safely for unknown appearance keys', (tester) async {
    await _pumpCard(
      tester,
      wallet: const Wallet(
        id: 'legacy-id',
        name: 'Legacy Wallet',
        currencyCode: 'AED',
        colorKey: 'sage',
        iconKey: 'unknown-icon',
      ),
    );

    final surface = tester.widget<Container>(
      find.byKey(const ValueKey('wallet-card-surface-legacy-id')),
    );
    final decoration = surface.decoration! as BoxDecoration;
    expect(decoration.color, WalletColorPalette.blue.cardColor);
    expect(find.byIcon(Icons.account_balance_wallet_outlined), findsOneWidget);
  });

  testWidgets('provides one concise accessibility label', (tester) async {
    await _pumpCard(
      tester,
      wallet: const Wallet(id: 'cash-id', name: 'Cash', currencyCode: 'AED'),
    );

    final semantics = tester.getSemantics(find.byType(WalletCard));
    expect(semantics.label, 'Cash, AED');
  });

  testWidgets('handles a long Wallet name on a compact screen', (tester) async {
    await _pumpCard(
      tester,
      wallet: const Wallet(
        id: 'long-id',
        name: 'A very long Wallet name that cannot fit on one line',
        currencyCode: 'AED',
      ),
      size: const Size(280, 220),
    );

    expect(tester.takeException(), isNull);
    expect(find.text('AED'), findsOneWidget);
  });
}

Future<void> _pumpCard(
  WidgetTester tester, {
  required Wallet wallet,
  Size size = const Size(390, 240),
}) {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);

  return tester.pumpWidget(
    MaterialApp(
      theme: AppTheme.light,
      home: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: WalletCard(wallet: wallet),
          ),
        ),
      ),
    ),
  );
}
