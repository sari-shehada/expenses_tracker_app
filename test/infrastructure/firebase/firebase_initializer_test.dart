import 'package:expenses_tracker/core/config/flavor_settings.dart';
import 'package:expenses_tracker/infrastructure/firebase/firebase_client.dart';
import 'package:expenses_tracker/infrastructure/firebase/firebase_initializer.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const emulatorHost = 'emulator-host';

  test(
    'development initializes Firebase without connecting emulators',
    () async {
      final client = _FakeFirebaseClient();
      final initializer = FirebaseInitializer(
        client: client,
        settings: developmentFlavorSettings,
        emulatorHost: emulatorHost,
      );

      await initializer.initialize();

      expect(client.calls, ['initialize']);
    },
  );

  test('local initializes Firebase before connecting both emulators', () async {
    final client = _FakeFirebaseClient();
    final initializer = FirebaseInitializer(
      client: client,
      settings: localFlavorSettings,
      emulatorHost: emulatorHost,
    );

    await initializer.initialize();

    expect(client.calls, [
      'initialize',
      'auth:$emulatorHost:${FirebaseInitializer.authEmulatorPort}',
      'storage:$emulatorHost:${FirebaseInitializer.storageEmulatorPort}',
    ]);
  });
}

class _FakeFirebaseClient implements FirebaseClient {
  final calls = <String>[];

  @override
  Future<void> initialize() async {
    calls.add('initialize');
  }

  @override
  Future<void> connectToAuthEmulator(String host, int port) async {
    calls.add('auth:$host:$port');
  }

  @override
  void connectToStorageEmulator(String host, int port) {
    calls.add('storage:$host:$port');
  }
}
