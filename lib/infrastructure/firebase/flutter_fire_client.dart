import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../../firebase_options.dart';
import 'firebase_client.dart';

class FlutterFireClient implements FirebaseClient {
  @override
  Future<void> initialize() {
    return Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  @override
  Future<void> connectToAuthEmulator(String host, int port) {
    return FirebaseAuth.instance.useAuthEmulator(host, port);
  }

  @override
  void connectToStorageEmulator(String host, int port) {
    FirebaseStorage.instance.useStorageEmulator(host, port);
  }
}
