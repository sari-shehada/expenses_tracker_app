import 'package:expenses_tracker/features/currencies/domain/currency.dart';
import 'package:expenses_tracker/features/currencies/domain/currency_catalog.dart';
import 'package:expenses_tracker/features/wallets/domain/wallet.dart';
import 'package:expenses_tracker/features/wallets/domain/wallet_repository.dart';
import 'package:expenses_tracker/features/wallets/presentation/pages/wallet_creation_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('requires a non-blank name and a currency', (tester) async {
    final repository = _FakeWalletRepository();

    await _pumpPage(tester, repository: repository);
    await tester.tap(find.text('Create Wallet'));
    await tester.pump();

    expect(find.text('Enter a Wallet name.'), findsOneWidget);
    expect(find.text('Select a currency.'), findsOneWidget);
    expect(repository.createCalls, 0);
  });

  testWidgets('creates a Wallet with the selected currency', (tester) async {
    final repository = _FakeWalletRepository();

    await _pumpPage(tester, repository: repository);
    await tester.enterText(find.byType(TextFormField), 'Cash');
    await tester.tap(find.text('Select currency'));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('USD')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Create Wallet'));
    await tester.pump();

    expect(repository.createdUserId, 'user-id');
    expect(repository.createdName, 'Cash');
    expect(repository.createdCurrencyCode, 'USD');
  });

  testWidgets('reports a save failure and lets the user retry', (tester) async {
    final repository = _FakeWalletRepository(shouldFail: true);

    await _pumpPage(tester, repository: repository);
    await tester.enterText(find.byType(TextFormField), 'Cash');
    await tester.tap(find.text('Select currency'));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('USD')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Create Wallet'));
    await tester.pump();

    expect(find.text('Could not save Wallet.'), findsOneWidget);

    repository.shouldFail = false;
    await tester.tap(find.text('Try again'));
    await tester.pump();

    expect(repository.createCalls, 2);
  });
}

Future<void> _pumpPage(
  WidgetTester tester, {
  required WalletRepository repository,
}) {
  return tester.pumpWidget(
    MaterialApp(
      home: WalletCreationPage(
        userId: 'user-id',
        repository: repository,
        currencyCatalog: _FakeCurrencyCatalog(),
      ),
    ),
  );
}

class _FakeCurrencyCatalog implements CurrencyCatalog {
  @override
  Future<Currency?> findByCode(String code) async => null;

  @override
  Future<List<Currency>> getAll() async => [
    const Currency(
      code: 'USD',
      name: 'US Dollar',
      symbol: r'$',
      nativeSymbol: r'$',
      decimalDigits: 2,
    ),
  ];
}

class _FakeWalletRepository implements WalletRepository {
  _FakeWalletRepository({this.shouldFail = false});

  bool shouldFail;
  int createCalls = 0;
  String? createdUserId;
  String? createdName;
  String? createdCurrencyCode;

  @override
  Future<Wallet> createWallet({
    required String userId,
    required String name,
    required String currencyCode,
  }) async {
    createCalls++;
    createdUserId = userId;
    createdName = name;
    createdCurrencyCode = currencyCode;

    if (shouldFail) {
      throw StateError('Could not save Wallet');
    }

    return Wallet(id: 'wallet-id', name: name, currencyCode: currencyCode);
  }

  @override
  Stream<List<Wallet>> watchWallets({required String userId}) =>
      const Stream.empty();
}
