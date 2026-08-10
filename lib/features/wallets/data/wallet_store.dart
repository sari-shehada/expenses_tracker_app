import 'package:cloud_firestore/cloud_firestore.dart';

class WalletDocument {
  const WalletDocument({required this.id, required this.data});

  final String id;
  final Map<String, Object?> data;
}

abstract interface class WalletStore {
  Future<WalletDocument> createWallet({
    required String userId,
    required Map<String, Object?> data,
  });

  Stream<List<WalletDocument>> watchWallets({required String userId});
}

class FirestoreWalletStore implements WalletStore {
  FirestoreWalletStore({required this.firestore});

  final FirebaseFirestore firestore;

  @override
  Future<WalletDocument> createWallet({
    required String userId,
    required Map<String, Object?> data,
  }) async {
    final document = firestore
        .collection('users')
        .doc(userId)
        .collection('wallets')
        .doc();

    await document.set(data);

    return WalletDocument(id: document.id, data: data);
  }

  @override
  Stream<List<WalletDocument>> watchWallets({required String userId}) {
    return firestore
        .collection('users')
        .doc(userId)
        .collection('wallets')
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map(
                (document) =>
                    WalletDocument(id: document.id, data: document.data()),
              )
              .toList(),
        );
  }
}
