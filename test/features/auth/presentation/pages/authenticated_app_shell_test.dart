import 'package:expenses_tracker/features/auth/domain/auth_user.dart';
import 'package:expenses_tracker/features/auth/presentation/pages/authenticated_app_shell.dart';
import 'package:expenses_tracker/features/currencies/domain/currency.dart';
import 'package:expenses_tracker/features/currencies/domain/currency_catalog.dart';
import 'package:expenses_tracker/features/wallets/domain/wallet.dart';
import 'package:expenses_tracker/features/wallets/domain/wallet_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('shows Sheets as the default destination', (tester) async {
    await _pumpPage(tester);

    expect(find.text('No Sheets yet'), findsOneWidget);
    expect(find.text('Add Sheet'), findsOneWidget);
    expect(find.text('No Wallets yet.'), findsNothing);
  });

  testWidgets('keeps Add Sheet as a placeholder action', (tester) async {
    await _pumpPage(tester);

    await tester.tap(find.text('Add Sheet'));
    await tester.pumpAndSettle();

    expect(find.text('No Sheets yet'), findsOneWidget);
  });

  testWidgets('opens Wallets from the bottom navigation', (tester) async {
    await _pumpPage(tester);

    await tester.tap(find.text('Wallets'));
    await tester.pumpAndSettle();

    expect(find.text('No Wallets yet.'), findsOneWidget);
    expect(find.text('No Sheets yet'), findsNothing);
  });
}

Future<void> _pumpPage(WidgetTester tester) {
  return tester.pumpWidget(
    MaterialApp(
      home: AuthenticatedAppShell(
        user: const AuthUser(
          id: 'user-id',
          email: 'user@example.com',
          displayName: 'User',
          photoUrl: null,
        ),
        onSignOut: () {},
        walletRepository: _FakeWalletRepository(),
        currencyCatalog: _FakeCurrencyCatalog(),
      ),
    ),
  );
}

class _FakeWalletRepository implements WalletRepository {
  @override
  Future<Wallet> createWallet({
    required String userId,
    required String name,
    required String currencyCode,
  }) async => Wallet(id: 'wallet-id', name: name, currencyCode: currencyCode);

  @override
  Stream<List<Wallet>> watchWallets({required String userId}) =>
      Stream.value(const []);
}

class _FakeCurrencyCatalog implements CurrencyCatalog {
  @override
  Future<Currency?> findByCode(String code) async => null;

  @override
  Future<List<Currency>> getAll() async => const [];
}
