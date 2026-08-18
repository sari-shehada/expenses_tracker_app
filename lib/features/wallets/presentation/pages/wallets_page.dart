import 'package:flutter/material.dart';

import '../../../../app/app_shell_layout.dart';
import '../../../../app/widgets/app_spacing.dart';
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
      child: StreamBuilder<List<Wallet>>(
        stream: _wallets,
        builder: (context, snapshot) => CustomScrollView(
          slivers: [
            SliverPersistentHeader(
              pinned: true,
              delegate: _WalletsHeaderDelegate(
                onAddWallet: _openWalletCreation,
              ),
            ),
            ..._buildWalletSlivers(snapshot),
            const SliverToBoxAdapter(
              child: AddVerticalSpacing(
                AppShellLayout.destinationBottomClearance,
                key: ValueKey(AppShellLayout.navigationClearanceKey),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildWalletSlivers(AsyncSnapshot<List<Wallet>> snapshot) {
    if (snapshot.hasError) {
      return [
        SliverFillRemaining(
          hasScrollBody: false,
          child: _WalletsLoadFailure(onRetry: _reloadWallets),
        ),
      ];
    }

    if (!snapshot.hasData) {
      return const [
        SliverFillRemaining(
          hasScrollBody: false,
          child: Center(child: CircularProgressIndicator()),
        ),
      ];
    }

    final wallets = snapshot.data!;
    if (wallets.isEmpty) {
      return const [
        SliverFillRemaining(
          hasScrollBody: false,
          child: Center(child: Text('No Wallets yet.')),
        ),
      ];
    }

    return [
      SliverPadding(
        padding: const EdgeInsets.fromLTRB(24, 8, 24, 0),
        sliver: SliverList.separated(
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
          separatorBuilder: (_, _) => const AddVerticalSpacing(12),
        ),
      ),
    ];
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

class _WalletsHeaderDelegate extends SliverPersistentHeaderDelegate {
  const _WalletsHeaderDelegate({required this.onAddWallet});

  final VoidCallback onAddWallet;

  static const _extent = 76.0;

  @override
  double get minExtent => _extent;

  @override
  double get maxExtent => _extent;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return ColoredBox(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: _WalletsHeader(onAddWallet: onAddWallet),
    );
  }

  @override
  bool shouldRebuild(_WalletsHeaderDelegate oldDelegate) =>
      onAddWallet != oldDelegate.onAddWallet;
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
