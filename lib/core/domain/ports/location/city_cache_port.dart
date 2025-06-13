// lib/core/domain/ports/location/city_cache_port.dart

import '../../models/shared/city_model.dart';
import '../../models/location/place_details.dart';

/// Port pour interagir avec le cache de villes dans Supabase
abstract class CityCachePort {
  // Méthodes existantes
  Future<City?> getCityByPlaceId(String placeId);
  Future<City?> getCityByName(String cityName);
  Future<City> saveCity({
    required String placeId,
    required String cityName,
    required double lat,
    required double lon,
    String? postalCode,
    String? department,
  });
  Future<City> savePlaceDetailsAsCity(PlaceDetails placeDetails);
  Future<List<City>> searchCities(String? query);

  // Nouvelle méthode
  Future<City?> getCityById(String id);
}