// core/adapters/google_maps/geocoding_adapter.dart

import '../../domain/ports/geocoding_port.dart';
import '../../domain/models/shared/city_model.dart';
import '../../common/exceptions/exceptions.dart';
import '../../domain/ports/maps_port.dart';
import '../../domain/services/location_service.dart';



class GeocodingAdapter implements GeocodingPort {
  final LocationService _locationService;
  final MapsPort _mapsService;

  GeocodingAdapter(this._locationService, this._mapsService);

  @override
  Future<City> getCity(String cityName) async {
    try {
      // Chercher d'abord dans notre base
      final existingCity = await _locationService.findCity(cityName);
      if (existingCity != null) return existingCity;

      // Si la ville n'existe pas, l'enrichir via Google Maps
      final enriched = await _mapsService.enrichCityData(cityName);
      if (!enriched) {
        throw DataException('Impossible de trouver ou créer la ville: $cityName');
      }

      // Récupérer la ville nouvellement créée
      final newCity = await _locationService.findCity(cityName);
      if (newCity == null) {
        throw DataException('Ville créée mais non trouvée: $cityName');
      }

      return newCity;
    } catch (e) {
      throw DataException('Erreur lors de la recherche/création de la ville: $e');
    }
  }

  @override
  Future<List<City>> getMultipleCities(List<String> cityNames) async {
    try {
      final cities = <City>[];
      for (final cityName in cityNames) {
        final city = await getCity(cityName);
        cities.add(city);
      }
      return cities;
    } catch (e) {
      throw DataException('Erreur lors de la recherche/création des villes: $e');
    }
  }
}