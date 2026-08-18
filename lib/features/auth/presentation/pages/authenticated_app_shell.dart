import 'package:flutter/material.dart';

import '../../../../app/app_shell_layout.dart';
import '../../../../app/widgets/app_bottom_navigation_bar.dart';
import '../../../currencies/domain/currency_catalog.dart';
import '../../../settings/presentation/pages/settings_page.dart';
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
    final pages = [
      SheetsPage(onAddSheet: () {}),
      WalletsPage(
        userId: widget.user.id,
        repository: widget.walletRepository,
        currencyCatalog: widget.currencyCatalog,
      ),
      SettingsPage(onSignOut: widget.onSignOut),
    ];

    return Scaffold(
      body: Stack(
        key: const ValueKey('authenticated-app-shell-overlay'),
        fit: StackFit.expand,
        children: [
          pages[_selectedIndex],
          SafeArea(
            top: false,
            minimum: const EdgeInsets.symmetric(
              horizontal: AppShellLayout.navigationHorizontalInset,
            ),
            child: Padding(
              padding: const EdgeInsets.only(
                bottom: AppShellLayout.navigationBottomSpacing,
              ),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: AppBottomNavigationBar(
                  selectedIndex: _selectedIndex,
                  onDestinationSelected: (index) =>
                      setState(() => _selectedIndex = index),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
