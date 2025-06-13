// lib/core/domain/services/location/enhanced_location_service.dart

import 'package:async/async.dart';
import 'package:geolocator/geolocator.dart';
import '../../../domain/models/location/user_location.dart';
import '../../../domain/models/location/place_suggestion.dart';
import '../../../domain/models/location/place_details.dart';
import '../../../domain/models/shared/city_model.dart';
import '../../../domain/ports/location/location_cache_port.dart';
import '../../../domain/ports/location/city_cache_port.dart';
import '../../../adapters/google_maps/maps_adapter.dart';
import '../../../common/utils/debouncer.dart';
import '../../../common/constants/location_constants.dart';

class EnhancedLocationService {
  final GoogleMapsAdapter _mapsAdapter;
  final LocationCachePort _locationCache;
  final Debouncer _searchDebouncer;
  final CityCachePort _cityCache;

  EnhancedLocationService({
    required GoogleMapsAdapter mapsAdapter,
    required LocationCachePort locationCache,
    required CityCachePort cityCache,
  }) : _mapsAdapter = mapsAdapter,
        _locationCache = locationCache,
        _cityCache = cityCache,
        _searchDebouncer = Debouncer(
          milliseconds: LocationConstants.searchDebounceTime,
        );

  /// Recherche de lieux avec debounce
  void searchPlacesWithDebounce(
      String query,
      Function(Result<List<PlaceSuggestion>>) callback,
      ) {
    _searchDebouncer.run(() async {
      // Recherche d'abord dans le cache
      if (query.length >= 2) {
        final cachedSuggestions = await _locationCache.getPlaceSuggestions(query);

        if (cachedSuggestions.isNotEmpty) {
          callback(Result.value(cachedSuggestions));
        }
      }

      // Si la requête est trop courte, on arrête là
      if (query.length < 3) {
        return;
      }

      // Recherche via l'API
      final result = await _mapsAdapter.searchPlaces(query);

      if (result.isValue && result.asValue!.value.isNotEmpty) {
        // Sauvegarder les résultats dans le cache
        await _locationCache.savePlaceSuggestions(result.asValue!.value);
      }

      callback(result);
    });
  }

  /// Récupère les détails d'un lieu avec optimisation via la table cities
  Future<Result<PlaceDetails>> getPlaceDetails(String placeId) async {
    // ÉTAPE 1: Vérifier d'abord dans le cache Hive local
    final cachedDetails = await _locationCache.getPlaceDetails(placeId);
    if (cachedDetails != null) {
      print('✅ Détails trouvés dans le cache local: ${cachedDetails.name}');
      return Result.value(cachedDetails);
    }

    // ÉTAPE 2: Vérifier ensuite dans la table cities de Supabase
    final cachedCity = await _cityCache.getCityByPlaceId(placeId);
    if (cachedCity != null) {
      print('✅ Ville trouvée dans la base de données: ${cachedCity.cityName}');

      // Convertir City en PlaceDetails
      final placeDetails = PlaceDetails(
        placeId: cachedCity.placeId ?? cachedCity.id,
        name: cachedCity.cityName,
        formattedAddress: cachedCity.cityName,
        location: UserLocation(
          latitude: cachedCity.lat,
          longitude: cachedCity.lon,
          isFromGps: false,
          timestamp: DateTime.now(),
        ),
        lastUpdated: DateTime.now(),
      );

      // Sauvegarder dans le cache local aussi
      await _locationCache.savePlaceDetails(placeDetails);

      return Result.value(placeDetails);
    }

    // ÉTAPE 3: Si pas trouvé, faire l'appel API
    print('🔍 Appel à l\'API Google pour obtenir les détails: $placeId');
    final result = await _mapsAdapter.getPlaceDetailsById(placeId);

    if (result.isValue) {
      final placeDetails = result.asValue!.value;

      // Sauvegarder dans le cache local
      await _locationCache.savePlaceDetails(placeDetails);

      // Sauvegarder dans la table cities
      try {
        await _cityCache.savePlaceDetailsAsCity(placeDetails);
        print('✅ Ville sauvegardée dans la base de données: ${placeDetails.name}');
      } catch (e) {
        print('⚠️ Impossible de sauvegarder la ville: $e');
        // On continue même si la sauvegarde échoue
      }
    }

    return result;
  }


  /// Récupère la position actuelle
  Future<Result<UserLocation>> getCurrentLocation() async {
    try {
      // Vérifier si le service de localisation est activé
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return Result.error(Exception('Les services de localisation sont désactivés.'));
      }

      // Vérifier les permissions
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return Result.error(Exception('La permission de localisation a été refusée.'));
        }
      }

      if (permission == LocationPermission.deniedForever) {
        return Result.error(Exception('Les permissions de localisation sont définitivement refusées, veuillez les activer dans les paramètres.'));
      }

      // Obtenir la position actuelle
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 5),
      );

      return Result.value(UserLocation(
        latitude: position.latitude,
        longitude: position.longitude,
        accuracy: position.accuracy,
        isFromGps: true,
        timestamp: DateTime.now(),
      ));
    } catch (e) {
      return Result.error(Exception('Erreur lors de la récupération de la position: ${e.toString()}'));
    }
  }
  /// Annule la recherche en cours
  void cancelSearch() {
    _searchDebouncer.cancel();
  }
}