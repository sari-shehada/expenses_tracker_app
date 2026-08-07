import 'flavor.dart';
import 'flavor_settings.dart';

const _environment = String.fromEnvironment('env', defaultValue: 'development');

class FlavorsService {
  const FlavorsService({required this.currentFlavor, required this.settings});

  final Flavor currentFlavor;
  final FlavorSettings settings;

  static late final FlavorsService instance;
  static bool _isInitialized = false;

  static void init() {
    if (_isInitialized) {
      return;
    }

    final flavor = flavorFromEnvironment(_environment);
    instance = FlavorsService(
      currentFlavor: flavor,
      settings: getSettings(flavor),
    );
    _isInitialized = true;
  }
}
