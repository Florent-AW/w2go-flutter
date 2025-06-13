// lib/core/common/constants/geometry_constants.dart

class GeometryConstants {
  // Distances
  static const double defaultToleranceMeters = 100.0;
  static const double maxDetourDistanceKm = 5.0;

  // Facteurs de conversion pour le calcul du malus
  static const double relaxedTravelFactor = 2.0;  // Plus de temps alloué
  static const double balancedTravelFactor = 1.75;
  static const double activeTravelFactor = 1.5;  // Moins de temps alloué

  // Vitesse moyenne estimée (en m/s)
  static const double averageSpeedMetersPerSecond = 13.89; // ~50km/h

  // Seuils pour les calculs
  static const int minimumMalusMinutes = 5;
  static const int maximumMalusMinutes = 120;
}