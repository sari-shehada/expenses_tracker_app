import 'dart:async';

import 'package:expenses_tracker/features/currencies/domain/currency.dart';
import 'package:expenses_tracker/features/currencies/domain/currency_catalog.dart';
import 'package:expenses_tracker/features/wallets/domain/wallet.dart';
import 'package:expenses_tracker/features/wallets/domain/wallet_repository.dart';
import 'package:expenses_tracker/features/wallets/presentation/pages/wallets_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('shows loading while Wallets are loading', (tester) async {
    final repository = _FakeWalletRepository();

    await _pumpPage(tester, repository: repository);

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('shows an empty state when there are no Wallets', (tester) async {
    final repository = _FakeWalletRepository();

    await _pumpPage(tester, repository: repository);
    repository.addWallets(const []);
    await tester.pump();

    expect(find.text('No Wallets yet.'), findsOneWidget);
  });

  testWidgets('shows the saved Wallets', (tester) async {
    final repository = _FakeWalletRepository();

    await _pumpPage(tester, repository: repository);
    repository.addWallets(const [
      Wallet(id: 'cash-id', name: 'Cash', currencyCode: 'USD'),
      Wallet(id: 'card-id', name: 'Card', currencyCode: 'EUR'),
    ]);
    await tester.pump();

    expect(find.text('Cash'), findsOneWidget);
    expect(find.text('USD'), findsOneWidget);
    expect(find.text('Card'), findsOneWidget);
    expect(find.text('EUR'), findsOneWidget);
  });

  testWidgets('reports a failed Wallet load and retries', (tester) async {
    final repository = _FakeWalletRepository();

    await _pumpPage(tester, repository: repository);
    repository.addError(StateError('Could not load Wallets'));
    await tester.pump();

    expect(find.text('Could not load Wallets.'), findsOneWidget);

    await tester.tap(find.text('Try again'));
    await tester.pump();

    expect(repository.watchCalls, 2);
  });

  testWidgets('opens Wallet creation', (tester) async {
    final repository = _FakeWalletRepository();

    await _pumpPage(tester, repository: repository);
    await tester.tap(find.text('Add Wallet'));
    await tester.pumpAndSettle();

    expect(find.text('Add wallet'), findsOneWidget);
  });
}

Future<void> _pumpPage(
  WidgetTester tester, {
  required WalletRepository repository,
}) {
  return tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: WalletsPage(
          userId: 'user-id',
          repository: repository,
          currencyCatalog: _FakeCurrencyCatalog(),
        ),
      ),
    ),
  );
}

class _FakeWalletRepository implements WalletRepository {
  final _wallets = StreamController<List<Wallet>>.broadcast();
  int watchCalls = 0;

  void addWallets(List<Wallet> wallets) => _wallets.add(wallets);

  void addError(Object error) => _wallets.addError(error);

  @override
  Future<Wallet> createWallet({
    required String userId,
    required String name,
    required String currencyCode,
  }) async => Wallet(id: 'wallet-id', name: name, currencyCode: currencyCode);

  @override
  Stream<List<Wallet>> watchWallets({required String userId}) {
    watchCalls++;
    return _wallets.stream;
  }
}

class _FakeCurrencyCatalog implements CurrencyCatalog {
  @override
  Future<Currency?> findByCode(String code) async => null;

  @override
  Future<List<Currency>> getAll() async => const [];
}
