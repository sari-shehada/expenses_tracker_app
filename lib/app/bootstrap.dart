import '../core/config/flavors_service.dart';
import '../infrastructure/firebase/firebase_client.dart';
import 'dependency_injection.dart';

Future<void> bootstrap() async {
  FlavorsService.init();
  configureDependencies();
  await serviceLocator<FirebaseClient>().initialize();
}
