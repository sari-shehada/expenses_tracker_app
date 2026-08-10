import 'wallet.dart';

abstract interface class WalletRepository {
  Future<Wallet> createWallet({
    required String userId,
    required String name,
    required String currencyCode,
  });

  Stream<List<Wallet>> watchWallets({required String userId});
}
