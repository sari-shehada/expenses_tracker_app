import 'flavor.dart';

const _environment = String.fromEnvironment('env', defaultValue: 'development');

class FlavorsService {
  const FlavorsService({required this.currentFlavor});

  final Flavor currentFlavor;

  static late final FlavorsService instance;
  static bool _isInitialized = false;

  static void init() {
    if (_isInitialized) {
      return;
    }

    final flavor = flavorFromEnvironment(_environment);
    instance = FlavorsService(currentFlavor: flavor);
    _isInitialized = true;
  }
}
