import '../core/config/flavors_service.dart';
import '../infrastructure/firebase/firebase_initializer.dart';
import 'dependency_injection.dart';

Future<void> bootstrap() async {
  FlavorsService.init();
  configureDependencies(flavorSettings: FlavorsService.instance.settings);
  await serviceLocator<FirebaseInitializer>().initialize();
}
