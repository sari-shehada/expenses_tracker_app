import 'package:flutter/material.dart';

import '../../../currencies/domain/currency_catalog.dart';
import '../../../sheets/presentation/pages/sheets_page.dart';
import '../../../wallets/domain/wallet_repository.dart';
import '../../../wallets/presentation/pages/wallets_page.dart';
import '../../domain/auth_user.dart';

class AuthenticatedAppShell extends StatefulWidget {
  const AuthenticatedAppShell({
    required this.user,
    required this.onSignOut,
    required this.walletRepository,
    required this.currencyCatalog,
    super.key,
  });

  final AuthUser user;
  final VoidCallback onSignOut;
  final WalletRepository walletRepository;
  final CurrencyCatalog currencyCatalog;

  @override
  State<AuthenticatedAppShell> createState() => _AuthenticatedAppShellState();
}

class _AuthenticatedAppShellState extends State<AuthenticatedAppShell> {
  var _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _selectedIndex == 0
          ? SheetsPage(onAddSheet: () {})
          : WalletsPage(
              userId: widget.user.id,
              repository: widget.walletRepository,
              currencyCatalog: widget.currencyCatalog,
            ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) =>
            setState(() => _selectedIndex = index),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.description_outlined),
            selectedIcon: Icon(Icons.description),
            label: 'Sheets',
          ),
          NavigationDestination(
            icon: Icon(Icons.account_balance_wallet_outlined),
            selectedIcon: Icon(Icons.account_balance_wallet),
            label: 'Wallets',
          ),
        ],
      ),
    );
  }
}
