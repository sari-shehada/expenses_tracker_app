import '../../core/config/flavor_settings.dart';
import 'firebase_client.dart';

class FirebaseInitializer {
  const FirebaseInitializer({
    required this.client,
    required this.settings,
    required this.emulatorHost,
  });

  static const authEmulatorPort = 9099;
  static const storageEmulatorPort = 9199;

  final FirebaseClient client;
  final FlavorSettings settings;
  final String emulatorHost;

  Future<void> initialize() async {
    await client.initialize();

    if (!settings.useFirebaseEmulators) {
      return;
    }

    await client.connectToAuthEmulator(emulatorHost, authEmulatorPort);
    client.connectToStorageEmulator(emulatorHost, storageEmulatorPort);
  }
}
