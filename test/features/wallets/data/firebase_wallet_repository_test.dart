import 'dart:async';

import 'package:expenses_tracker/features/wallets/data/firebase_wallet_repository.dart';
import 'package:expenses_tracker/features/wallets/data/wallet_store.dart';
import 'package:expenses_tracker/features/wallets/domain/wallet.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('creates a Wallet in the signed-in user collection', () async {
    final store = _FakeWalletStore(
      createdWallet: const WalletDocument(
        id: 'wallet-id',
        data: {'name': 'Cash', 'currencyCode': 'USD'},
      ),
    );
    final repository = FirebaseWalletRepository(store: store);

    final wallet = await repository.createWallet(
      userId: 'user-id',
      name: 'Cash',
      currencyCode: 'USD',
    );

    expect(
      wallet,
      const Wallet(id: 'wallet-id', name: 'Cash', currencyCode: 'USD'),
    );
    expect(store.createdUserId, 'user-id');
    expect(store.createdData, {'name': 'Cash', 'currencyCode': 'USD'});
  });

  test('maps Wallet documents from the signed-in user collection', () {
    final controller = StreamController<List<WalletDocument>>();
    addTearDown(controller.close);
    final store = _FakeWalletStore(wallets: controller.stream);
    final repository = FirebaseWalletRepository(store: store);

    expect(
      repository.watchWallets(userId: 'user-id'),
      emits([
        const Wallet(id: 'cash-id', name: 'Cash', currencyCode: 'USD'),
        const Wallet(id: 'card-id', name: 'Card', currencyCode: 'EUR'),
      ]),
    );

    controller.add([
      const WalletDocument(
        id: 'cash-id',
        data: {'name': 'Cash', 'currencyCode': 'USD'},
      ),
      const WalletDocument(
        id: 'card-id',
        data: {'name': 'Card', 'currencyCode': 'EUR'},
      ),
    ]);

    expect(store.watchedUserId, 'user-id');
  });
}

class _FakeWalletStore implements WalletStore {
  _FakeWalletStore({this.createdWallet, Stream<List<WalletDocument>>? wallets})
    : _wallets = wallets ?? const Stream.empty();

  final WalletDocument? createdWallet;
  final Stream<List<WalletDocument>> _wallets;
  String? createdUserId;
  Map<String, Object?>? createdData;
  String? watchedUserId;

  @override
  Future<WalletDocument> createWallet({
    required String userId,
    required Map<String, Object?> data,
  }) async {
    createdUserId = userId;
    createdData = data;
    return createdWallet!;
  }

  @override
  Stream<List<WalletDocument>> watchWallets({required String userId}) {
    watchedUserId = userId;
    return _wallets;
  }
}
