import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';

import '../features/auth/data/auth_client.dart';
import '../features/auth/data/firebase_auth_repository.dart';
import '../features/auth/data/flutter_firebase_auth_client.dart';
import '../features/auth/domain/auth_repository.dart';
import '../features/auth/presentation/bloc/authentication_bloc.dart';
import '../features/currencies/data/asset_currency_catalog.dart';
import '../features/currencies/data/currency_asset_reader.dart';
import '../features/currencies/data/flutter_currency_asset_reader.dart';
import '../features/currencies/domain/currency_catalog.dart';
import '../features/wallets/data/firebase_wallet_repository.dart';
import '../features/wallets/data/wallet_store.dart';
import '../features/wallets/domain/wallet_repository.dart';
import '../infrastructure/firebase/firebase_client.dart';
import '../infrastructure/firebase/flutter_fire_client.dart';

final serviceLocator = GetIt.instance;

void configureDependencies({
  GetIt? locator,
  FirebaseClient? firebaseClient,
  AuthClient? authClient,
  AuthRepository? authRepository,
  CurrencyAssetReader? currencyAssetReader,
  CurrencyCatalog? currencyCatalog,
  WalletStore? walletStore,
  WalletRepository? walletRepository,
}) {
  final getIt = locator ?? serviceLocator;

  getIt.registerLazySingleton<FirebaseClient>(
    () => firebaseClient ?? FlutterFireClient(),
  );
  getIt.registerLazySingleton<AuthClient>(
    () => authClient ?? FlutterFirebaseAuthClient(),
  );
  getIt.registerLazySingleton<AuthRepository>(
    () => authRepository ?? FirebaseAuthRepository(client: getIt()),
  );
  getIt.registerLazySingleton<CurrencyAssetReader>(
    () => currencyAssetReader ?? FlutterCurrencyAssetReader(),
  );
  getIt.registerLazySingleton<CurrencyCatalog>(
    () => currencyCatalog ?? AssetCurrencyCatalog(assetReader: getIt()),
  );
  getIt.registerLazySingleton<WalletStore>(
    () =>
        walletStore ??
        FirestoreWalletStore(firestore: FirebaseFirestore.instance),
  );
  getIt.registerLazySingleton<WalletRepository>(
    () => walletRepository ?? FirebaseWalletRepository(store: getIt()),
  );
  getIt.registerFactory<AuthenticationBloc>(
    () => AuthenticationBloc(repository: getIt()),
  );
}
