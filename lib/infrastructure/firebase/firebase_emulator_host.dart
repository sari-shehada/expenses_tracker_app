import 'package:flutter/foundation.dart';

String firebaseEmulatorHost(TargetPlatform platform) {
  return platform == TargetPlatform.android ? '10.0.2.2' : '127.0.0.1';
}
