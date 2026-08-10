import 'package:flutter/material.dart';

import '../../../currencies/domain/currency_catalog.dart';
import '../../domain/wallet.dart';
import '../../domain/wallet_repository.dart';
import 'wallet_creation_page.dart';

class WalletsPage extends StatefulWidget {
  const WalletsPage({
    required this.userId,
    required this.repository,
    required this.currencyCatalog,
    super.key,
  });

  final String userId;
  final WalletRepository repository;
  final CurrencyCatalog currencyCatalog;

  @override
  State<WalletsPage> createState() => _WalletsPageState();
}

class _WalletsPageState extends State<WalletsPage> {
  late Stream<List<Wallet>> _wallets;

  @override
  void initState() {
    super.initState();
    _wallets = _watchWallets();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        StreamBuilder<List<Wallet>>(
          stream: _wallets,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Could not load Wallets.'),
                    TextButton(
                      onPressed: _reloadWallets,
                      child: const Text('Try again'),
                    ),
                  ],
                ),
              );
            }

            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }

            final wallets = snapshot.data!;
            if (wallets.isEmpty) {
              return const Center(child: Text('No Wallets yet.'));
            }

            return ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 88),
              itemCount: wallets.length,
              itemBuilder: (context, index) =>
                  _WalletListItem(wallet: wallets[index]),
              separatorBuilder: (_, _) => const Divider(height: 1),
            );
          },
        ),
        Positioned(
          right: 16,
          bottom: 16,
          child: FloatingActionButton.extended(
            onPressed: _openWalletCreation,
            icon: const Icon(Icons.add),
            label: const Text('Add Wallet'),
          ),
        ),
      ],
    );
  }

  Stream<List<Wallet>> _watchWallets() {
    return widget.repository.watchWallets(userId: widget.userId);
  }

  void _reloadWallets() {
    setState(() => _wallets = _watchWallets());
  }

  Future<void> _openWalletCreation() async {
    await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => WalletCreationPage(
          userId: widget.userId,
          repository: widget.repository,
          currencyCatalog: widget.currencyCatalog,
        ),
      ),
    );
  }
}

class _WalletListItem extends StatelessWidget {
  const _WalletListItem({required this.wallet});

  final Wallet wallet;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(wallet.name),
      subtitle: Text(wallet.currencyCode),
    );
  }
}
