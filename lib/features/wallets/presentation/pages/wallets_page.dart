import 'package:flutter/material.dart';

import '../../../currencies/domain/currency_catalog.dart';
import '../../domain/wallet.dart';
import '../../domain/wallet_repository.dart';
import '../widgets/wallet_card.dart';
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
    return SafeArea(
      child: Column(
        children: [
          _WalletsHeader(onAddWallet: _openWalletCreation),
          Expanded(
            child: StreamBuilder<List<Wallet>>(
              stream: _wallets,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return _WalletsLoadFailure(onRetry: _reloadWallets);
                }

                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final wallets = snapshot.data!;
                if (wallets.isEmpty) {
                  return const Center(child: Text('No Wallets yet.'));
                }

                return ListView.separated(
                  padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
                  itemCount: wallets.length,
                  itemBuilder: (context, index) {
                    final wallet = wallets[index];
                    return Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 720),
                        child: WalletCard(
                          key: ValueKey('wallet-card-${wallet.id}'),
                          wallet: wallet,
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (_, _) => const SizedBox(height: 12),
                );
              },
            ),
          ),
        ],
      ),
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

class _WalletsHeader extends StatelessWidget {
  const _WalletsHeader({required this.onAddWallet});

  final VoidCallback onAddWallet;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 12),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 720),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  'Wallets',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              OutlinedButton.icon(
                key: const ValueKey('add-wallet-button'),
                onPressed: onAddWallet,
                icon: const Icon(Icons.add_circle, size: 22),
                label: const Text('Add wallet'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: colorScheme.primary,
                  minimumSize: const Size(0, 48),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  side: BorderSide(color: colorScheme.outlineVariant),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  textStyle: Theme.of(
                    context,
                  ).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _WalletsLoadFailure extends StatelessWidget {
  const _WalletsLoadFailure({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Could not load Wallets.'),
          TextButton(onPressed: onRetry, child: const Text('Try again')),
        ],
      ),
    );
  }
}
