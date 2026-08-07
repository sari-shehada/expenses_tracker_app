import 'package:expenses_tracker/app/dependency_injection.dart';
import 'package:expenses_tracker/core/config/flavor_settings.dart';
import 'package:expenses_tracker/infrastructure/firebase/firebase_client.dart';
import 'package:expenses_tracker/infrastructure/firebase/firebase_initializer.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';

void main() {
  test('registers flavor configuration and Firebase infrastructure', () {
    final locator = GetIt.asNewInstance();
    final client = _FakeFirebaseClient();

    configureDependencies(
      flavorSettings: localFlavorSettings,
      locator: locator,
      firebaseClient: client,
    );

    expect(locator<FlavorSettings>(), same(localFlavorSettings));
    expect(locator<FirebaseClient>(), same(client));
    expect(locator<FirebaseInitializer>(), isA<FirebaseInitializer>());
  });
}

class _FakeFirebaseClient implements FirebaseClient {
  @override
  Future<void> initialize() async {}

  @override
  Future<void> connectToAuthEmulator(String host, int port) async {}

  @override
  void connectToStorageEmulator(String host, int port) {}
}
