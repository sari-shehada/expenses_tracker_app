import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';

import '../core/config/flavor_settings.dart';
import '../infrastructure/firebase/firebase_client.dart';
import '../infrastructure/firebase/firebase_emulator_host.dart';
import '../infrastructure/firebase/firebase_initializer.dart';
import '../infrastructure/firebase/flutter_fire_client.dart';

final serviceLocator = GetIt.instance;

void configureDependencies({
  required FlavorSettings flavorSettings,
  GetIt? locator,
  FirebaseClient? firebaseClient,
}) {
  final getIt = locator ?? serviceLocator;

  getIt.registerSingleton<FlavorSettings>(flavorSettings);
  getIt.registerLazySingleton<FirebaseClient>(
    () => firebaseClient ?? FlutterFireClient(),
  );
  getIt.registerLazySingleton<FirebaseInitializer>(
    () => FirebaseInitializer(
      client: getIt(),
      settings: getIt(),
      emulatorHost: firebaseEmulatorHost(defaultTargetPlatform),
    ),
  );
}
