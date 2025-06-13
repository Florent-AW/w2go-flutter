// lib/features/search/application/services/city_selection_service.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:async/async.dart';
import '../../../../core/domain/models/shared/city_model.dart';
import '../../../../core/domain/models/location/place_details.dart';
import '../../../../core/domain/services/location/enhanced_location_service.dart';
import '../../../../core/domain/ports/providers/location/location_providers.dart';
import '../state/city_selection_state.dart';

/// Service qui gère la logique de sélection de ville et la récupération de ses coordonnées
class CitySelectionService {
  final EnhancedLocationService _locationService;
  final Ref _ref;

  CitySelectionService(this._locationService, this._ref);

  /// Sélectionne une ville à partir de son place_id Google
  /// et met à jour les providers associés
  Future<bool> selectCityByPlaceId(String placeId) async {
    try {
      // Récupérer les détails complets du lieu (incluant lat/lng)
      final placeDetailsResult = await _locationService.getPlaceDetails(placeId);

      if (placeDetailsResult.isError) {
        print('❌ Erreur lors de la récupération des détails: ${placeDetailsResult.asError!.error}');
        return false;
      }

      // Extraire l'objet PlaceDetails du Result
      final placeDetails = placeDetailsResult.asValue!.value;

      // Créer un objet City avec les coordonnées
      final city = City(
        id: placeId,
        cityName: placeDetails.name,
        lat: placeDetails.location.latitude,
        lon: placeDetails.location.longitude,
        geohash5: '', // À générer si nécessaire
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      // Mettre à jour le provider de ville sélectionnée
      _ref.read(selectedCityProvider.notifier).state = city;

      print('✅ Ville sélectionnée: ${city.cityName} (${city.lat}, ${city.lon})');
      return true;
    } catch (e) {
      print('❌ Erreur lors de la sélection de la ville: $e');
      return false;
    }
  }

  /// Récupère les coordonnées de la ville actuellement sélectionnée
  /// ou null si aucune ville n'est sélectionnée
  LatLng? getSelectedCityCoordinates() {
    final city = _ref.read(selectedCityProvider);
    if (city == null) return null;

    return LatLng(city.lat, city.lon);
  }
}

// Provider pour accéder au service
final citySelectionServiceProvider = Provider<CitySelectionService>((ref) {
  final locationService = ref.watch(enhancedLocationServiceProvider);
  return CitySelectionService(locationService, ref);
});