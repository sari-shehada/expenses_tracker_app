enum Flavor { local, development }

Flavor flavorFromEnvironment(String? environment) => switch (environment) {
  null || '' => Flavor.development,
  'local' => Flavor.local,
  'development' => Flavor.development,
  _ => throw ArgumentError.value(
    environment,
    'environment',
    'Expected "local" or "development".',
  ),
};
