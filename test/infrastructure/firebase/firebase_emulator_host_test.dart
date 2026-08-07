import 'package:expenses_tracker/infrastructure/firebase/firebase_emulator_host.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('uses the Android emulator host alias on Android', () {
    expect(firebaseEmulatorHost(TargetPlatform.android), '10.0.2.2');
  });

  test('uses loopback on Apple platforms', () {
    expect(firebaseEmulatorHost(TargetPlatform.iOS), '127.0.0.1');
    expect(firebaseEmulatorHost(TargetPlatform.macOS), '127.0.0.1');
  });
}
