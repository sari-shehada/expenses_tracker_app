import 'package:get_it/get_it.dart';

import '../infrastructure/firebase/firebase_client.dart';
import '../infrastructure/firebase/flutter_fire_client.dart';

final serviceLocator = GetIt.instance;

void configureDependencies({GetIt? locator, FirebaseClient? firebaseClient}) {
  final getIt = locator ?? serviceLocator;

  getIt.registerLazySingleton<FirebaseClient>(
    () => firebaseClient ?? FlutterFireClient(),
  );
}
