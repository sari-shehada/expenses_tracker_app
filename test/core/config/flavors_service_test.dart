import 'package:expenses_tracker/core/config/flavor.dart';
import 'package:expenses_tracker/core/config/flavors_service.dart';
import 'package:flutter_test/flutter_test.dart';

const _selectedEnvironment = String.fromEnvironment(
  'env',
  defaultValue: 'development',
);

void main() {
  group('flavorFromEnvironment', () {
    test('maps the development environment', () {
      expect(flavorFromEnvironment('development'), Flavor.development);
    });

    test('defaults missing values to development', () {
      expect(flavorFromEnvironment(null), Flavor.development);
      expect(flavorFromEnvironment(''), Flavor.development);
    });

    test('rejects unsupported environments', () {
      for (final environment in ['local', 'production']) {
        expect(
          () => flavorFromEnvironment(environment),
          throwsA(isA<ArgumentError>()),
        );
      }
    });
  });

  test('initializes the selected flavor only once', () {
    FlavorsService.init();
    final firstInstance = FlavorsService.instance;

    expect(
      firstInstance.currentFlavor,
      flavorFromEnvironment(_selectedEnvironment),
    );

    FlavorsService.init();

    expect(FlavorsService.instance, same(firstInstance));
  });
}
