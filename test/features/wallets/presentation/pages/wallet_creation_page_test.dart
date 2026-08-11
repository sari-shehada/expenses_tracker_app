import 'package:expenses_tracker/app/app_theme.dart';
import 'package:expenses_tracker/features/currencies/domain/currency.dart';
import 'package:expenses_tracker/features/currencies/domain/currency_catalog.dart';
import 'package:expenses_tracker/features/wallets/domain/wallet.dart';
import 'package:expenses_tracker/features/wallets/domain/wallet_repository.dart';
import 'package:expenses_tracker/features/wallets/presentation/pages/wallet_creation_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('shows the redesigned page foundation and hero', (tester) async {
    await _pumpPage(tester, repository: _FakeWalletRepository());

    expect(find.text('Add wallet'), findsOneWidget);
    expect(
      find.text('Keep track of where your\nmoney comes from.'),
      findsOneWidget,
    );
    expect(find.byKey(const ValueKey('wallet-creation-hero')), findsOneWidget);

    final heading = tester.widget<Text>(
      find.text('Keep track of where your\nmoney comes from.'),
    );
    expect(heading.style?.color, AppTheme.light.colorScheme.onSurface);
  });

  testWidgets('requires a non-blank name and a currency', (tester) async {
    final repository = _FakeWalletRepository();

    await _pumpPage(tester, repository: repository);
    await tester.ensureVisible(find.text('Create Wallet'));
    await tester.tap(find.text('Create Wallet'));
    await tester.pump();

    expect(find.text('Enter a Wallet name.'), findsOneWidget);
    expect(find.text('Select a currency.'), findsOneWidget);
    expect(repository.createCalls, 0);
  });

  testWidgets('uses the rounded Wallet name field treatment', (tester) async {
    await _pumpPage(tester, repository: _FakeWalletRepository());

    final nameField = tester.widget<TextField>(
      find.descendant(
        of: find.byType(TextFormField),
        matching: find.byType(TextField),
      ),
    );
    final border = nameField.decoration!.enabledBorder! as OutlineInputBorder;

    expect(nameField.decoration!.labelText, 'Wallet name');
    expect(border.borderRadius, BorderRadius.circular(24));
  });

  testWidgets('creates a Wallet with the selected currency', (tester) async {
    final repository = _FakeWalletRepository();

    await _pumpPage(tester, repository: repository);
    await tester.enterText(find.byType(TextFormField), 'Cash');
    await tester.tap(find.text('Select currency'));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('USD')));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Create Wallet'));
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
    await tester.ensureVisible(find.text('Create Wallet'));
    await tester.tap(find.text('Create Wallet'));
    await tester.pump();

    expect(find.text('Could not save Wallet.'), findsOneWidget);

    repository.shouldFail = false;
    await tester.drag(find.byType(ListView), const Offset(0, -200));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Try again'));
    await tester.pump();

    expect(repository.createCalls, 2);
  });
}

Future<void> _pumpPage(
  WidgetTester tester, {
  required WalletRepository repository,
}) {
  tester.view.physicalSize = const Size(390, 844);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);

  return tester.pumpWidget(
    MaterialApp(
      theme: AppTheme.light,
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
