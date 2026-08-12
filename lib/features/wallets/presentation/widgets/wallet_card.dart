import 'package:flutter/material.dart';

import '../../domain/wallet.dart';
import '../wallet_color_palette.dart';
import '../wallet_icon_catalog.dart';

class WalletCard extends StatelessWidget {
  const WalletCard({required this.wallet, super.key});

  final Wallet wallet;

  @override
  Widget build(BuildContext context) {
    final palette = WalletColorPalette.resolve(wallet.colorKey);
    final iconOption = WalletIconOption.resolve(wallet.iconKey);
    final colorScheme = Theme.of(context).colorScheme;

    return Semantics(
      container: true,
      label: '${wallet.name}, ${wallet.currencyCode}',
      excludeSemantics: true,
      child: Container(
        key: ValueKey('wallet-card-surface-${wallet.id}'),
        constraints: const BoxConstraints(minHeight: 112),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: palette.cardColor,
          border: Border.all(color: palette.borderColor),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: palette.accentColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(iconOption.icon, color: palette.accentColor),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                wallet.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Container(
              key: ValueKey('wallet-card-currency-${wallet.id}'),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: palette.accentColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                wallet.currencyCode,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: palette.accentColor,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
