import '../domain/wallet.dart';
import '../domain/wallet_repository.dart';
import 'wallet_store.dart';

class FirebaseWalletRepository implements WalletRepository {
  FirebaseWalletRepository({required this.store});

  final WalletStore store;

  @override
  Future<Wallet> createWallet({
    required String userId,
    required String name,
    required String currencyCode,
  }) async {
    final document = await store.createWallet(
      userId: userId,
      data: {'name': name, 'currencyCode': currencyCode},
    );

    return _walletFromDocument(document);
  }

  @override
  Stream<List<Wallet>> watchWallets({required String userId}) {
    return store
        .watchWallets(userId: userId)
        .map((documents) => documents.map(_walletFromDocument).toList());
  }

  Wallet _walletFromDocument(WalletDocument document) {
    return Wallet(
      id: document.id,
      name: document.data['name']! as String,
      currencyCode: document.data['currencyCode']! as String,
    );
  }
}
