import 'package:expenses_tracker/app/bootstrap.dart';
import 'package:expenses_tracker/app/dependency_injection.dart';
import 'package:expenses_tracker/features/currencies/domain/currency.dart';
import 'package:expenses_tracker/features/currencies/domain/currency_catalog.dart';
import 'package:expenses_tracker/infrastructure/firebase/firebase_client.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('initializes Firebase and the currency catalog at launch', () async {
    final firebaseClient = _FakeFirebaseClient();
    final currencyCatalog = _FakeCurrencyCatalog();
    addTearDown(serviceLocator.reset);

    await bootstrap(
      firebaseClient: firebaseClient,
      currencyCatalog: currencyCatalog,
    );

    expect(firebaseClient.initializeCalls, 1);
    expect(currencyCatalog.initializeCalls, 1);
  });
}

class _FakeFirebaseClient implements FirebaseClient {
  int initializeCalls = 0;

  @override
  Future<void> initialize() async {
    initializeCalls++;
  }
}

class _FakeCurrencyCatalog implements CurrencyCatalog {
  int initializeCalls = 0;

  @override
  Future<void> initialize() async {
    initializeCalls++;
  }

  @override
  List<Currency> get currencies => const [];

  @override
  Currency? findByCode(String code) => null;
}
