import 'package:firebase_core/firebase_core.dart';

import '../../firebase_options.dart';
import 'firebase_client.dart';

class FlutterFireClient implements FirebaseClient {
  @override
  Future<void> initialize() {
    return Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }
}
