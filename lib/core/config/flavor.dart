enum Flavor { development }

Flavor flavorFromEnvironment(String? environment) => switch (environment) {
  null || '' => Flavor.development,
  'development' => Flavor.development,
  _ => throw ArgumentError.value(
    environment,
    'environment',
    'Expected "development".',
  ),
};
