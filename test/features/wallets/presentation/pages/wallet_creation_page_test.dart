import 'dart:async';
import 'dart:ui' as ui;

import 'package:expenses_tracker/app/app_theme.dart';
import 'package:expenses_tracker/features/currencies/domain/currency.dart';
import 'package:expenses_tracker/features/currencies/domain/currency_catalog.dart';
import 'package:expenses_tracker/features/wallets/domain/wallet.dart';
import 'package:expenses_tracker/features/wallets/domain/wallet_appearance.dart';
import 'package:expenses_tracker/features/wallets/domain/wallet_repository.dart';
import 'package:expenses_tracker/features/wallets/presentation/pages/wallet_creation_page.dart';
import 'package:expenses_tracker/features/wallets/presentation/widgets/wallet_creation_step_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('shows the Figma Wallet name step', (tester) async {
    await _pumpPage(tester, repository: _FakeWalletRepository());

    expect(find.text('Create Wallet'), findsOneWidget);
    expect(find.text('Step 1 of 3'), findsOneWidget);
    expect(find.text('33% Complete'), findsOneWidget);
    expect(find.text('Name your wallet'), findsOneWidget);
    expect(
      find.text(
        'Give your wallet a name that describes its funding source — like “Cash”, “Chase Visa”, or “Mom”.',
      ),
      findsOneWidget,
    );
    expect(find.text('Wallet Name'), findsOneWidget);
    expect(
      find.widgetWithText(TextField, 'e.g. Primary Checking'),
      findsOneWidget,
    );

    final field = tester.widget<TextField>(
      find.byKey(const ValueKey('wallet-name-field')),
    );
    final border = field.decoration!.enabledBorder! as OutlineInputBorder;
    expect(field.textInputAction, TextInputAction.next);
    expect(border.borderRadius, BorderRadius.circular(14));
    expect(
      tester
          .getSize(find.byKey(const ValueKey('wallet-name-continue-button')))
          .height,
      48,
    );
  });

  testWidgets('focuses the Wallet name field when the flow opens', (
    tester,
  ) async {
    await _pumpPage(tester, repository: _FakeWalletRepository());

    final fieldFinder = find.byKey(const ValueKey('wallet-name-field'));
    final field = tester.widget<TextField>(fieldFinder);
    final editableText = tester.widget<EditableText>(
      find.descendant(of: fieldFinder, matching: find.byType(EditableText)),
    );

    expect(field.autofocus, isTrue);
    expect(editableText.focusNode.hasFocus, isTrue);
  });

  testWidgets('requires a non-blank name before advancing', (tester) async {
    await _pumpPage(tester, repository: _FakeWalletRepository());

    await tester.tap(find.byKey(const ValueKey('wallet-name-continue-button')));
    await tester.pump();

    expect(find.text('Enter a Wallet name.'), findsOneWidget);
    expect(find.text('Step 1 of 3'), findsOneWidget);

    await tester.enterText(
      find.byKey(const ValueKey('wallet-name-field')),
      '   ',
    );
    await tester.tap(find.byKey(const ValueKey('wallet-name-continue-button')));
    await tester.pump();

    expect(find.text('Enter a Wallet name.'), findsOneWidget);
    expect(find.text('Step 1 of 3'), findsOneWidget);
  });

  testWidgets('moves focus from Wallet name to currency search on Continue', (
    tester,
  ) async {
    await _pumpPage(tester, repository: _FakeWalletRepository());
    await tester.enterText(
      find.byKey(const ValueKey('wallet-name-field')),
      'Travel card',
    );

    await tester.tap(find.byKey(const ValueKey('wallet-name-continue-button')));
    await tester.pump();

    final searchFinder = find.byKey(const ValueKey('currency-search-field'));
    final editableText = tester.widget<EditableText>(
      find.descendant(of: searchFinder, matching: find.byType(EditableText)),
    );

    expect(find.text('Step 2 of 3'), findsOneWidget);
    expect(editableText.focusNode.hasFocus, isTrue);
  });

  testWidgets('keyboard Next moves focus to currency search', (tester) async {
    await _pumpPage(tester, repository: _FakeWalletRepository());
    await tester.enterText(
      find.byKey(const ValueKey('wallet-name-field')),
      'Travel card',
    );

    await tester.testTextInput.receiveAction(TextInputAction.next);
    await tester.pump();

    final searchFinder = find.byKey(const ValueKey('currency-search-field'));
    final editableText = tester.widget<EditableText>(
      find.descendant(of: searchFinder, matching: find.byType(EditableText)),
    );

    expect(find.text('Step 2 of 3'), findsOneWidget);
    expect(editableText.focusNode.hasFocus, isTrue);
  });

  testWidgets('leaves currency search unfocused when Step 1 was unfocused', (
    tester,
  ) async {
    await _pumpPage(tester, repository: _FakeWalletRepository());
    await tester.enterText(
      find.byKey(const ValueKey('wallet-name-field')),
      'Travel card',
    );
    FocusManager.instance.primaryFocus?.unfocus();
    await tester.pump();

    await tester.tap(find.byKey(const ValueKey('wallet-name-continue-button')));
    await tester.pump();

    final searchFinder = find.byKey(const ValueKey('currency-search-field'));
    final editableText = tester.widget<EditableText>(
      find.descendant(of: searchFinder, matching: find.byType(EditableText)),
    );

    expect(editableText.focusNode.hasFocus, isFalse);
  });

  testWidgets('animates only the body while shared flow chrome stays fixed', (
    tester,
  ) async {
    await _pumpPage(tester, repository: _FakeWalletRepository());

    final backFinder = find.byKey(
      const ValueKey('wallet-creation-back-button'),
    );
    final indicatorFinder = find.byType(WalletCreationStepIndicator);
    final initialBackRect = tester.getRect(backFinder);
    final initialIndicatorRect = tester.getRect(indicatorFinder);
    final initialCtaRect = tester.getRect(
      find.byKey(const ValueKey('wallet-name-continue-button')),
    );
    final initialBodyX = tester.getTopLeft(find.text('Name your wallet')).dx;

    await tester.enterText(
      find.byKey(const ValueKey('wallet-name-field')),
      'Travel card',
    );
    await tester.tap(find.byKey(const ValueKey('wallet-name-continue-button')));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 250));

    expect(tester.getRect(backFinder), initialBackRect);
    expect(tester.getRect(indicatorFinder), initialIndicatorRect);
    expect(
      tester.getRect(
        find.byKey(const ValueKey('wallet-currency-continue-button')),
      ),
      initialCtaRect,
    );
    expect(
      tester.getTopLeft(find.text('Name your wallet')).dx,
      lessThan(initialBodyX),
    );
    expect(
      tester.getTopLeft(find.text('Select currency')).dx,
      greaterThan(initialBodyX),
    );

    await tester.pumpAndSettle();
  });

  testWidgets('retains the draft while navigating between all steps', (
    tester,
  ) async {
    await _pumpPage(tester, repository: _FakeWalletRepository());
    await _advanceToAppearance(tester, name: 'Travel card');

    await tester.tap(find.byKey(const ValueKey('wallet-creation-color-teal')));
    await tester.tap(find.byKey(const ValueKey('wallet-creation-icon-travel')));
    await tester.pump();

    await tester.tap(find.byKey(const ValueKey('wallet-creation-back-button')));
    await tester.pumpAndSettle();

    expect(find.text('Step 2 of 3'), findsOneWidget);
    _expectSelected(tester, const ValueKey('USD'), true);

    await tester.tap(find.byKey(const ValueKey('wallet-creation-back-button')));
    await tester.pumpAndSettle();

    expect(find.text('Step 1 of 3'), findsOneWidget);
    final nameField = tester.widget<TextField>(
      find.byKey(const ValueKey('wallet-name-field')),
    );
    expect(nameField.controller!.text, 'Travel card');

    await tester.tap(find.byKey(const ValueKey('wallet-name-continue-button')));
    await tester.pumpAndSettle();
    await tester.tap(
      find.byKey(const ValueKey('wallet-currency-continue-button')),
    );
    await tester.pumpAndSettle();

    _expectSelected(tester, const ValueKey('wallet-creation-color-teal'), true);
    _expectSelected(
      tester,
      const ValueKey('wallet-creation-icon-travel'),
      true,
    );
  });

  testWidgets('keeps Step 2 open until its selected currency is confirmed', (
    tester,
  ) async {
    await _pumpPage(tester, repository: _FakeWalletRepository());
    await _advanceToCurrency(tester, name: 'Cash');

    final continueFinder = find.byKey(
      const ValueKey('wallet-currency-continue-button'),
    );
    final disabledButton = tester.widget<FilledButton>(continueFinder);
    expect(disabledButton.onPressed, isNull);
    expect(
      disabledButton.style?.backgroundColor?.resolve({WidgetState.disabled}),
      AppTheme.light.colorScheme.outlineVariant,
    );
    expect(
      disabledButton.style?.foregroundColor?.resolve({WidgetState.disabled}),
      AppTheme.light.colorScheme.onSurfaceVariant,
    );

    await tester.tap(find.byKey(const ValueKey('USD')));
    await tester.pump();

    expect(find.text('Step 2 of 3'), findsOneWidget);
    _expectSelected(tester, const ValueKey('USD'), true);
    expect(tester.widget<FilledButton>(continueFinder).onPressed, isNotNull);
  });

  testWidgets('retains currency search after continuing and returning', (
    tester,
  ) async {
    await _pumpPage(tester, repository: _FakeWalletRepository());
    await _advanceToCurrency(tester, name: 'Cash');

    await tester.tap(find.byKey(const ValueKey('USD')));
    await tester.pump();
    await tester.enterText(
      find.byKey(const ValueKey('currency-search-field')),
      'missing',
    );
    await tester.pump();
    expect(find.text('No currencies found'), findsOneWidget);

    await tester.tap(
      find.byKey(const ValueKey('wallet-currency-continue-button')),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('wallet-creation-back-button')));
    await tester.pumpAndSettle();

    final searchField = tester.widget<TextField>(
      find.byKey(const ValueKey('currency-search-field')),
    );
    expect(searchField.controller?.text, 'missing');
    expect(find.text('No currencies found'), findsOneWidget);
  });

  testWidgets('creates a Wallet from the retained three-step draft', (
    tester,
  ) async {
    final repository = _FakeWalletRepository();
    await _pumpPage(tester, repository: repository);
    await _advanceToAppearance(tester, name: 'Cash');

    await tester.tap(find.byKey(const ValueKey('wallet-creation-color-teal')));
    await tester.tap(find.byKey(const ValueKey('wallet-creation-icon-travel')));
    await tester.tap(find.byKey(const ValueKey('create-wallet-button')));
    await tester.pump();

    expect(repository.createdUserId, 'user-id');
    expect(repository.createdName, 'Cash');
    expect(repository.createdCurrencyCode, 'USD');
    expect(repository.createdColorKey, 'teal');
    expect(repository.createdIconKey, 'travel');
  });

  testWidgets('reports a save failure on Step 3 and allows a retry', (
    tester,
  ) async {
    final repository = _FakeWalletRepository(shouldFail: true);
    await _pumpPage(tester, repository: repository);
    await _advanceToAppearance(tester, name: 'Cash');

    await tester.tap(find.byKey(const ValueKey('create-wallet-button')));
    await tester.pumpAndSettle();

    expect(find.text('Could not save Wallet.'), findsOneWidget);
    expect(find.text('Step 3 of 3'), findsOneWidget);

    repository.shouldFail = false;
    await tester.tap(find.text('Try again'));
    await tester.pump();

    expect(repository.createCalls, 2);
  });

  testWidgets('disables Create Wallet and reports progress while saving', (
    tester,
  ) async {
    final saveCompleter = Completer<void>();
    final repository = _FakeWalletRepository(saveCompleter: saveCompleter);
    await _pumpPage(tester, repository: repository);
    await _advanceToAppearance(tester, name: 'Cash');

    await tester.tap(find.byKey(const ValueKey('create-wallet-button')));
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

  testWidgets('keeps the current CTA visible on compact and keyboard views', (
    tester,
  ) async {
    await _pumpPage(
      tester,
      repository: _FakeWalletRepository(),
      size: const Size(320, 568),
    );

    expect(
      find.byKey(const ValueKey('wallet-name-continue-button')).hitTestable(),
      findsOneWidget,
    );

    tester.view.viewInsets = const FakeViewPadding(bottom: 220);
    addTearDown(tester.view.resetViewInsets);
    await tester.tap(find.byKey(const ValueKey('wallet-name-field')));
    await tester.showKeyboard(find.byKey(const ValueKey('wallet-name-field')));
    await tester.pump();

    expect(
      find.byKey(const ValueKey('wallet-name-continue-button')).hitTestable(),
      findsOneWidget,
    );
  });

  testWidgets('meets Step 1 tap-target and labeling accessibility guidelines', (
    tester,
  ) async {
    final semantics = tester.ensureSemantics();
    try {
      await _pumpPage(tester, repository: _FakeWalletRepository());

      await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
      await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
    } finally {
      semantics.dispose();
    }
  });
}

void _expectSelected(WidgetTester tester, ValueKey<String> key, bool expected) {
  expect(
    tester.getSemantics(find.byKey(key)).flagsCollection.isSelected,
    expected ? ui.Tristate.isTrue : ui.Tristate.isFalse,
  );
}

Future<void> _advanceToCurrency(
  WidgetTester tester, {
  required String name,
}) async {
  await tester.enterText(find.byKey(const ValueKey('wallet-name-field')), name);
  await tester.tap(find.byKey(const ValueKey('wallet-name-continue-button')));
  await tester.pumpAndSettle();
}

Future<void> _advanceToAppearance(
  WidgetTester tester, {
  required String name,
}) async {
  await _advanceToCurrency(tester, name: name);
  await tester.tap(find.byKey(const ValueKey('USD')));
  await tester.pump();
  await tester.tap(
    find.byKey(const ValueKey('wallet-currency-continue-button')),
  );
  await tester.pumpAndSettle();
}

Future<void> _pumpPage(
  WidgetTester tester, {
  required WalletRepository repository,
  Size size = const Size(402, 874),
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
  List<Currency> get currencies => const [
    Currency(
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
