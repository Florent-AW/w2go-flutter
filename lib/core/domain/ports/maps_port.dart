// core/domain/ports/maps_port.dart

abstract class MapsPort {
  /// Récupère les détails de géolocalisation d'une ville
  Future<Map<String, dynamic>?> getPlaceDetails(String cityName);

  /// Enrichit les données d'une ville avec ses coordonnées
  Future<bool> enrichCityData(String cityName);

  /// Enrichit les données de plusieurs villes
  Future<List<String>> enrichMultipleCities(List<String> cityNames);
}