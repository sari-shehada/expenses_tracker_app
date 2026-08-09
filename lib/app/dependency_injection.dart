import 'package:get_it/get_it.dart';

import '../features/auth/data/auth_client.dart';
import '../features/auth/data/firebase_auth_repository.dart';
import '../features/auth/data/flutter_firebase_auth_client.dart';
import '../features/auth/domain/auth_repository.dart';
import '../features/auth/presentation/bloc/authentication_bloc.dart';
import '../infrastructure/firebase/firebase_client.dart';
import '../infrastructure/firebase/flutter_fire_client.dart';

final serviceLocator = GetIt.instance;

void configureDependencies({
  GetIt? locator,
  FirebaseClient? firebaseClient,
  AuthClient? authClient,
  AuthRepository? authRepository,
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
  getIt.registerFactory<AuthenticationBloc>(
    () => AuthenticationBloc(repository: getIt()),
  );
}
