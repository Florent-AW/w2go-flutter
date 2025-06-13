// lib/core/common/constants/location_constants.dart

class LocationConstants {
  // Distance maximale par défaut pour la recherche d'activités (en km)
  static const double defaultSearchRadius = 150.0;

  // Limites min/max que l'utilisateur peut choisir
  static const double minSearchRadius = 10.0;
  static const double maxSearchRadius = 300.0;

  // Rayon de recherche pour l'API Places (en mètres)
  static const int defaultPlacesSearchRadiusMeters = 50000;

  // Délai de debounce pour limiter les appels API (en millisecondes)
  static const int searchDebounceTime = 300;

  // Précision minimale requise pour la géolocalisation (en mètres)
  static const double minLocationAccuracy = 100.0;

  // Taille maximale du cache (nombre d'entrées)
  static const int maxCacheEntries = 100;

  // Coordonnées des départements ciblés (centre, rayon en mètres)
  static const Map<String, Map<String, dynamic>> targetDepartments = {
    'Dordogne': {
      'center': {'lat': 45.1909, 'lng': 0.7214},
      'radius': 80000,
    },
    'Lot': {
      'center': {'lat': 44.6239, 'lng': 1.6094},
      'radius': 50000,
    },
    'Corrèze': {
      'center': {'lat': 45.3394, 'lng': 1.8655},
      'radius': 50000,
    },
  };
}

/// Représente un biais de localisation pour centrer les recherches
class LocationBias {
  final String label;
  final double latitude;
  final double longitude;
  final int radius;

  const LocationBias({
    required this.label,
    required this.latitude,
    required this.longitude,
    required this.radius,
  });

  @override
  String toString() => '$label ($latitude, $longitude)';

  /// Convertit en format utilisable par l'API Google Places (circle:radius@lat,lng)
  String toGoogleCircleBias() => 'circle:$radius@$latitude,$longitude';
}
