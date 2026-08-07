import 'package:expenses_tracker/core/config/flavor.dart';
import 'package:expenses_tracker/core/config/flavor_settings.dart';
import 'package:expenses_tracker/core/config/flavors_service.dart';
import 'package:flutter_test/flutter_test.dart';

const _selectedEnvironment = String.fromEnvironment(
  'env',
  defaultValue: 'development',
);

void main() {
  group('flavorFromEnvironment', () {
    test('maps every supported environment', () {
      expect(flavorFromEnvironment('local'), Flavor.local);
      expect(flavorFromEnvironment('development'), Flavor.development);
    });

    test('defaults missing values to development', () {
      expect(flavorFromEnvironment(null), Flavor.development);
      expect(flavorFromEnvironment(''), Flavor.development);
    });

    test('rejects unknown environments', () {
      expect(
        () => flavorFromEnvironment('production'),
        throwsA(isA<ArgumentError>()),
      );
    });
  });

  group('getSettings', () {
    test('defines settings for every flavor', () {
      for (final flavor in Flavor.values) {
        expect(getSettings(flavor), isA<FlavorSettings>());
      }
    });

    test('uses Firebase emulators only for local', () {
      expect(getSettings(Flavor.local).useFirebaseEmulators, isTrue);
      expect(getSettings(Flavor.development).useFirebaseEmulators, isFalse);
    });
  });

  test('initializes the selected flavor only once', () {
    FlavorsService.init();
    final firstInstance = FlavorsService.instance;

    expect(
      firstInstance.currentFlavor,
      flavorFromEnvironment(_selectedEnvironment),
    );
    expect(firstInstance.settings, getSettings(firstInstance.currentFlavor));

    FlavorsService.init();

    expect(FlavorsService.instance, same(firstInstance));
  });
}
