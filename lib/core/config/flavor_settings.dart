import 'flavor.dart';

// Flavors Class
class FlavorSettings {
  const FlavorSettings({required this.useFirebaseEmulators});

  final bool useFirebaseEmulators;
}

// Current Flavors
const localFlavorSettings = FlavorSettings(useFirebaseEmulators: true);
const developmentFlavorSettings = FlavorSettings(useFirebaseEmulators: false);

// Global method to get settings for flavor
FlavorSettings getSettings(Flavor flavor) => switch (flavor) {
  Flavor.local => localFlavorSettings,
  Flavor.development => developmentFlavorSettings,
};
