import 'dart:async';

import 'package:expenses_tracker/app/app_theme.dart';
import 'package:expenses_tracker/features/currencies/domain/currency.dart';
import 'package:expenses_tracker/features/currencies/domain/currency_catalog.dart';
import 'package:expenses_tracker/features/wallets/domain/wallet.dart';
import 'package:expenses_tracker/features/wallets/domain/wallet_appearance.dart';
import 'package:expenses_tracker/features/wallets/domain/wallet_repository.dart';
import 'package:expenses_tracker/features/wallets/presentation/pages/wallet_creation_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('shows the redesigned page foundation and hero', (tester) async {
    await _pumpPage(tester, repository: _FakeWalletRepository());

    expect(find.text('Create Wallet'), findsOneWidget);
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
    await tester.tap(find.text('Create wallet'));
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

  testWidgets('preselects the default Wallet appearance', (tester) async {
    await _pumpPage(tester, repository: _FakeWalletRepository());

    expect(
      find.descendant(
        of: find.byKey(const ValueKey('wallet-color-field')),
        matching: find.text('Sage'),
      ),
      findsOneWidget,
    );
    expect(
      find.descendant(
        of: find.byKey(const ValueKey('wallet-icon-field')),
        matching: find.text('Wallet'),
      ),
      findsOneWidget,
    );
  });

  testWidgets('creates a Wallet with the selected currency and appearance', (
    tester,
  ) async {
    final repository = _FakeWalletRepository();

    await _pumpPage(tester, repository: repository);
    await tester.enterText(find.byType(TextFormField), 'Cash');

    await tester.drag(find.byType(ListView).first, const Offset(0, -300));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('wallet-color-field')));
    await tester.pumpAndSettle();
    expect(find.text('Cash'), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('wallet-color-teal')));
    await tester.tap(find.byKey(const ValueKey('use-wallet-color-button')));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const ValueKey('wallet-icon-field')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('wallet-icon-travel')));
    await tester.tap(find.byKey(const ValueKey('use-wallet-icon-button')));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Select currency'));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('USD')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Create wallet'));
    await tester.pump();

    expect(repository.createdUserId, 'user-id');
    expect(repository.createdName, 'Cash');
    expect(repository.createdCurrencyCode, 'USD');
    expect(repository.createdColorKey, 'teal');
    expect(repository.createdIconKey, 'travel');
  });

  testWidgets('reports a save failure and lets the user retry', (tester) async {
    final repository = _FakeWalletRepository(shouldFail: true);

    await _pumpPage(tester, repository: repository);
    await tester.enterText(find.byType(TextFormField), 'Cash');
    await tester.tap(find.text('Select currency'));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('USD')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Create wallet'));
    await tester.pump();

    expect(find.text('Could not save Wallet.'), findsOneWidget);

    repository.shouldFail = false;
    await tester.tap(find.text('Try again'));
    await tester.pump();

    expect(repository.createCalls, 2);
  });

  testWidgets('keeps a rounded create action visible on a compact screen', (
    tester,
  ) async {
    await _pumpPage(
      tester,
      repository: _FakeWalletRepository(),
      size: const Size(320, 568),
    );

    expect(
      find.byKey(const ValueKey('create-wallet-button')).hitTestable(),
      findsOneWidget,
    );

    final button = tester.widget<FilledButton>(
      find.byKey(const ValueKey('create-wallet-button')),
    );
    final shape = button.style!.shape!.resolve({})! as RoundedRectangleBorder;

    expect(shape.borderRadius, BorderRadius.circular(16));
    expect(
      tester.getSize(find.byKey(const ValueKey('create-wallet-button'))).height,
      48,
    );
  });

  testWidgets('disables the action and reports progress while saving', (
    tester,
  ) async {
    final saveCompleter = Completer<void>();
    final repository = _FakeWalletRepository(saveCompleter: saveCompleter);

    await _pumpPage(tester, repository: repository);
    await tester.enterText(find.byType(TextFormField), 'Cash');
    await tester.tap(find.text('Select currency'));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('USD')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Create wallet'));
    await tester.pump();

    final button = tester.widget<FilledButton>(
      find.byKey(const ValueKey('create-wallet-button')),
    );
    expect(button.onPressed, isNull);
    expect(find.text('Creating wallet'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    saveCompleter.complete();
    await tester.pumpAndSettle();
  });

  testWidgets(
    'keeps the action visible when the keyboard reduces the viewport',
    (tester) async {
      await _pumpPage(
        tester,
        repository: _FakeWalletRepository(),
        size: const Size(390, 700),
      );
      tester.view.viewInsets = const FakeViewPadding(bottom: 280);
      addTearDown(tester.view.resetViewInsets);

      await tester.tap(find.byType(TextFormField));
      await tester.showKeyboard(find.byType(TextFormField));
      await tester.pump();

      expect(
        find.byKey(const ValueKey('create-wallet-button')).hitTestable(),
        findsOneWidget,
      );
      await tester.drag(find.byType(ListView), const Offset(0, -160));
      await tester.pump();
      expect(find.byType(TextFormField), findsOneWidget);
    },
  );

  testWidgets('meets tap-target and labeling accessibility guidelines', (
    tester,
  ) async {
    final semantics = tester.ensureSemantics();
    try {
      await _pumpPage(tester, repository: _FakeWalletRepository());
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
  Future<void> initialize() async {}

  @override
  Currency? findByCode(String code) => null;

  @override
  List<Currency> get currencies => [
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
  _FakeWalletRepository({this.shouldFail = false, this.saveCompleter});

  bool shouldFail;
  final Completer<void>? saveCompleter;
  int createCalls = 0;
  String? createdUserId;
  String? createdName;
  String? createdCurrencyCode;
  String? createdColorKey;
  String? createdIconKey;

  @override
  Future<Wallet> createWallet({
    required String userId,
    required String name,
    required String currencyCode,
    String colorKey = WalletAppearance.defaultColorKey,
    String iconKey = WalletAppearance.defaultIconKey,
  }) async {
    createCalls++;
    createdUserId = userId;
    createdName = name;
    createdCurrencyCode = currencyCode;
    createdColorKey = colorKey;
    createdIconKey = iconKey;

    await saveCompleter?.future;

    if (shouldFail) {
      throw StateError('Could not save Wallet');
    }

    return Wallet(
      id: 'wallet-id',
      name: name,
      currencyCode: currencyCode,
      colorKey: colorKey,
      iconKey: iconKey,
    );
  }

  @override
  Stream<List<Wallet>> watchWallets({required String userId}) =>
      const Stream.empty();
}
