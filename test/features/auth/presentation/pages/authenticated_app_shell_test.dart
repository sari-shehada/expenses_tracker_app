import 'package:expenses_tracker/app/widgets/app_bottom_navigation_bar.dart';
import 'package:expenses_tracker/app/app_shell_layout.dart';
import 'package:expenses_tracker/features/auth/domain/auth_user.dart';
import 'package:expenses_tracker/features/auth/presentation/pages/authenticated_app_shell.dart';
import 'package:expenses_tracker/features/currencies/domain/currency.dart';
import 'package:expenses_tracker/features/currencies/domain/currency_catalog.dart';
import 'package:expenses_tracker/features/wallets/domain/wallet.dart';
import 'package:expenses_tracker/features/wallets/domain/wallet_appearance.dart';
import 'package:expenses_tracker/features/wallets/domain/wallet_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('does not show a global app bar', (tester) async {
    await _pumpPage(tester);

    expect(find.byType(AppBar), findsNothing);
    expect(find.text('Expenses Tracker'), findsNothing);
    expect(find.text('Sign out'), findsNothing);
  });

  testWidgets('shows Sheets as the default destination', (tester) async {
    await _pumpPage(tester);

    expect(find.text('No sheets yet'), findsOneWidget);
    expect(find.text('Add Sheet'), findsOneWidget);
    expect(find.text('No Wallets yet.'), findsNothing);
  });

  testWidgets('uses the floating Figma bottom navigation', (tester) async {
    await _pumpPage(tester);

    expect(find.byType(AppBottomNavigationBar), findsOneWidget);
    expect(find.byType(NavigationBar), findsNothing);
    expect(
      tester.getSize(find.byType(AppBottomNavigationBar)),
      const Size(354, 72),
    );
    expect(
      tester.widget<Scaffold>(find.byType(Scaffold)).bottomNavigationBar,
      isNull,
    );
    expect(
      find.byKey(const ValueKey('authenticated-app-shell-overlay')),
      findsOneWidget,
    );
  });

  testWidgets('overlays the navigation above the body', (tester) async {
    await _pumpPage(tester);

    final shellBottom = tester.getBottomRight(find.byType(Scaffold)).dy;
    final pageBottom = tester
        .getBottomRight(
          find.byKey(const ValueKey('authenticated-app-shell-overlay')),
        )
        .dy;
    final navigationBottom = tester
        .getBottomRight(find.byType(AppBottomNavigationBar))
        .dy;

    expect(pageBottom, shellBottom);
    expect(navigationBottom, lessThan(pageBottom));
  });

  testWidgets('positions the navigation above the bottom safe area and gap', (
    tester,
  ) async {
    const bottomSafeArea = 34.0;
    const navigationBottomSpacing = 16.0;
    await _pumpPage(tester, bottomSafeArea: bottomSafeArea);

    final navigationBottom = tester
        .getBottomRight(find.byType(AppBottomNavigationBar))
        .dy;
    final shellBottom = tester.getBottomRight(find.byType(Scaffold)).dy;

    expect(
      shellBottom - navigationBottom,
      bottomSafeArea + navigationBottomSpacing,
    );
  });

  testWidgets('keeps Add Sheet as a placeholder action', (tester) async {
    await _pumpPage(tester);

    await tester.tap(find.text('Add Sheet'));
    await tester.pumpAndSettle();

    expect(find.text('No sheets yet'), findsOneWidget);
  });

  testWidgets('opens Wallets from the bottom navigation', (tester) async {
    await _pumpPage(tester);

    await tester.tap(find.text('Wallets'));
    await tester.pumpAndSettle();

    expect(find.text('No Wallets yet.'), findsOneWidget);
    expect(find.text('No sheets yet'), findsNothing);
  });

  testWidgets('opens Settings from the bottom navigation', (tester) async {
    await _pumpPage(tester);

    await tester.tap(find.text('Settings'));
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey('sign-out-button')), findsOneWidget);
    expect(find.text('No sheets yet'), findsNothing);
    expect(find.text('No Wallets yet.'), findsNothing);
  });

  testWidgets('destinations use shell-aware sliver layouts', (tester) async {
    await _pumpPage(tester);

    void expectNavigationClearance() {
      expect(find.byType(CustomScrollView), findsOneWidget);
      final scrollView = tester.widget<CustomScrollView>(
        find.byType(CustomScrollView),
      );
      final adapter = scrollView.slivers.last as SliverToBoxAdapter;
      final clearance = adapter.child as SizedBox;

      expect(
        clearance.key,
        const ValueKey(AppShellLayout.navigationClearanceKey),
      );
      expect(clearance.height, AppShellLayout.destinationBottomClearance);
    }

    expect(find.byType(CustomScrollView), findsOneWidget);
    final sheetsScrollView = tester.widget<CustomScrollView>(
      find.byType(CustomScrollView),
    );
    expect(sheetsScrollView.slivers.last, isNot(isA<SliverToBoxAdapter>()));

    await tester.tap(find.text('Wallets'));
    await tester.pumpAndSettle();
    expectNavigationClearance();

    await tester.tap(find.text('Settings'));
    await tester.pumpAndSettle();
    expectNavigationClearance();
  });

  testWidgets('signs out from Settings', (tester) async {
    var signOutCalls = 0;
    await _pumpPage(tester, onSignOut: () => signOutCalls++);

    await tester.tap(find.text('Settings'));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('sign-out-button')));

    expect(signOutCalls, 1);
  });
}

Future<void> _pumpPage(
  WidgetTester tester, {
  VoidCallback? onSignOut,
  double bottomSafeArea = 0,
}) {
  return tester.pumpWidget(
    MaterialApp(
      home: MediaQuery(
        data: MediaQueryData.fromView(
          tester.view,
        ).copyWith(padding: EdgeInsets.only(bottom: bottomSafeArea)),
        child: AuthenticatedAppShell(
          user: const AuthUser(
            id: 'user-id',
            email: 'user@example.com',
            displayName: 'User',
            photoUrl: null,
          ),
          onSignOut: onSignOut ?? () {},
          walletRepository: _FakeWalletRepository(),
          currencyCatalog: _FakeCurrencyCatalog(),
        ),
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
  Stream<List<Wallet>> watchWallets({required String userId}) =>
      Stream.value(const []);
}

class _FakeCurrencyCatalog implements CurrencyCatalog {
  @override
  Future<void> initialize() async {}

  @override
  Currency? findByCode(String code) => null;

  @override
  List<Currency> get currencies => const [];
}
