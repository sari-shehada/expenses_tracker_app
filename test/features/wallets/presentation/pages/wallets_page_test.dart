import 'dart:async';

import 'package:expenses_tracker/app/app_theme.dart';
import 'package:expenses_tracker/features/currencies/domain/currency.dart';
import 'package:expenses_tracker/features/currencies/domain/currency_catalog.dart';
import 'package:expenses_tracker/features/wallets/domain/wallet.dart';
import 'package:expenses_tracker/features/wallets/domain/wallet_appearance.dart';
import 'package:expenses_tracker/features/wallets/domain/wallet_repository.dart';
import 'package:expenses_tracker/features/wallets/presentation/pages/wallets_page.dart';
import 'package:expenses_tracker/features/wallets/presentation/widgets/wallet_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('shows loading while Wallets are loading', (tester) async {
    final repository = _FakeWalletRepository();

    await _pumpPage(tester, repository: repository);

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.text('Wallets'), findsOneWidget);
    expect(find.byKey(const ValueKey('add-wallet-button')), findsOneWidget);
  });

  testWidgets('shows an empty state when there are no Wallets', (tester) async {
    final repository = _FakeWalletRepository();

    await _pumpPage(tester, repository: repository);
    repository.addWallets(const []);
    await tester.pump();

    expect(find.text('No Wallets yet.'), findsOneWidget);
    expect(find.byType(FloatingActionButton), findsNothing);
    expect(find.byKey(const ValueKey('add-wallet-button')), findsOneWidget);
  });

  testWidgets('shows the saved Wallets', (tester) async {
    final repository = _FakeWalletRepository();

    await _pumpPage(tester, repository: repository);
    repository.addWallets(const [
      Wallet(
        id: 'cash-id',
        name: 'Cash',
        currencyCode: 'USD',
        colorKey: 'sage',
        iconKey: 'cash',
      ),
      Wallet(
        id: 'card-id',
        name: 'Card',
        currencyCode: 'EUR',
        colorKey: 'sky',
        iconKey: 'card',
      ),
    ]);
    await tester.pump();

    expect(find.text('Cash'), findsOneWidget);
    expect(find.text('USD'), findsOneWidget);
    expect(find.text('Card'), findsOneWidget);
    expect(find.text('EUR'), findsOneWidget);
    expect(find.byType(WalletCard), findsNWidgets(2));
    expect(find.byIcon(Icons.payments_outlined), findsOneWidget);
    expect(find.byIcon(Icons.credit_card_outlined), findsOneWidget);
  });

  testWidgets('scrolls through a long Wallet list', (tester) async {
    final repository = _FakeWalletRepository();

    await _pumpPage(tester, repository: repository);
    repository.addWallets(
      List.generate(
        12,
        (index) => Wallet(
          id: 'wallet-$index',
          name: 'Wallet ${index + 1}',
          currencyCode: 'AED',
        ),
      ),
    );
    await tester.pump();

    await tester.scrollUntilVisible(
      find.byKey(const ValueKey('wallet-card-wallet-11')),
      300,
      scrollable: find.byType(Scrollable),
    );

    expect(find.text('Wallet 12').hitTestable(), findsOneWidget);
    expect(find.byKey(const ValueKey('add-wallet-button')), findsOneWidget);
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
    await tester.tap(find.byKey(const ValueKey('add-wallet-button')));
    await tester.pumpAndSettle();

    expect(find.text('Add wallet'), findsOneWidget);
  });

  testWidgets('meets tap-target and labeling accessibility guidelines', (
    tester,
  ) async {
    final semantics = tester.ensureSemantics();
    try {
      final repository = _FakeWalletRepository();
      await _pumpPage(tester, repository: repository);
      repository.addWallets(const []);
      await tester.pump();

      await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
      await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
    } finally {
      semantics.dispose();
    }
  });
}

Future<void> _pumpPage(
  WidgetTester tester, {
  required WalletRepository repository,
  Size size = const Size(390, 844),
}) {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);

  return tester.pumpWidget(
    MaterialApp(
      theme: AppTheme.light,
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
    String colorKey = WalletAppearance.defaultColorKey,
    String iconKey = WalletAppearance.defaultIconKey,
  }) async => Wallet(
    id: 'wallet-id',
    name: name,
    currencyCode: currencyCode,
    colorKey: colorKey,
    iconKey: iconKey,
  );

  @override
  Stream<List<Wallet>> watchWallets({required String userId}) {
    watchCalls++;
    return _wallets.stream;
  }
}

class _FakeCurrencyCatalog implements CurrencyCatalog {
  @override
  Future<void> initialize() async {}

  @override
  Currency? findByCode(String code) => null;

  @override
  List<Currency> get currencies => const [];
}
