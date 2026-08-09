import 'package:expenses_tracker/app/dependency_injection.dart';
import 'package:expenses_tracker/infrastructure/firebase/firebase_client.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';

void main() {
  test('registers Firebase infrastructure', () {
    final locator = GetIt.asNewInstance();
    final client = _FakeFirebaseClient();

    configureDependencies(locator: locator, firebaseClient: client);

    expect(locator<FirebaseClient>(), same(client));
  });
}

class _FakeFirebaseClient implements FirebaseClient {
  @override
  Future<void> initialize() async {}
}
