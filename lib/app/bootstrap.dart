import '../core/config/flavors_service.dart';
import '../features/currencies/domain/currency_catalog.dart';
import '../infrastructure/firebase/firebase_client.dart';
import 'dependency_injection.dart';

Future<void> bootstrap({
  FirebaseClient? firebaseClient,
  CurrencyCatalog? currencyCatalog,
}) async {
  FlavorsService.init();
  configureDependencies(
    firebaseClient: firebaseClient,
    currencyCatalog: currencyCatalog,
  );
  await Future.wait([
    serviceLocator<FirebaseClient>().initialize(),
    serviceLocator<CurrencyCatalog>().initialize(),
  ]);
}
