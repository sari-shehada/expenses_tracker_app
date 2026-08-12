import 'wallet.dart';
import 'wallet_appearance.dart';

abstract interface class WalletRepository {
  Future<Wallet> createWallet({
    required String userId,
    required String name,
    required String currencyCode,
    String colorKey = WalletAppearance.defaultColorKey,
    String iconKey = WalletAppearance.defaultIconKey,
  });

  Stream<List<Wallet>> watchWallets({required String userId});
}
