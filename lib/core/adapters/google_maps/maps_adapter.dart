// core/adapters/google_maps/maps_adapter.dart

import 'dart:convert';
import 'dart:math' show cos, sqrt, pi;
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:async/async.dart';
import '../../domain/ports/maps_port.dart';
import '../../domain/ports/location/place_search_port.dart';
import '../../domain/ports/location/place_details_port.dart';
import '../../common/exceptions/exceptions.dart';
import '../../common/exceptions/location_exceptions.dart';
import '../../common/utils/geohash.dart';
import '../../domain/services/location_service.dart';
import '../../domain/models/location/place_suggestion.dart';
import '../../domain/models/location/place_details.dart';
import '../../domain/models/location/user_location.dart';

/// Service pour les interactions avec l'API Google Maps
/// Gère la géolocalisation et l'enrichissement des données de villes
class GoogleMapsAdapter implements MapsPort, PlaceSearchPort, PlaceDetailsPort {
  final LocationService _locationService;
  final String _apiKey;
  final http.Client _httpClient;

  static const _DORDOGNE_BOUNDS = {
    'minLat': 44.5,
    'maxLat': 45.7,
    'minLon': 0.0,
    'maxLon': 1.5,
  };

  // Définition des départements cibles pour la recherche de lieux
  static const Map<String, Map<String, dynamic>> _TARGET_DEPARTMENTS = {
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

  GoogleMapsAdapter(this._locationService, {http.Client? httpClient}) :
        _apiKey = dotenv.env['GOOGLE_MAPS_API_KEY'] ?? '',
        _httpClient = httpClient ?? http.Client() {
    if (_apiKey.isEmpty) {
      throw DataException('Google Maps API key not found in .env file');
    }
  }

  bool _isInDordogne(double lat, double lon) {
    return lat >= _DORDOGNE_BOUNDS['minLat']! &&
        lat <= _DORDOGNE_BOUNDS['maxLat']! &&
        lon >= _DORDOGNE_BOUNDS['minLon']! &&
        lon <= _DORDOGNE_BOUNDS['maxLon']!;
  }

  // Implémentation de MapsPort.getPlaceDetails
  @override
  Future<Map<String, dynamic>?> getPlaceDetails(String cityName) async {
    final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/geocode/json?address=${Uri.encodeComponent(cityName.trim())}&key=$_apiKey'
    );

    try {
      final response = await _httpClient.get(url);
      final data = json.decode(response.body);

      if (response.statusCode != 200) {
        throw DataException('HTTP error: ${response.statusCode}');
      }

      if (data['status'] != 'OK' || data['results'].isEmpty) {
        return null;
      }

      final location = data['results'][0]['geometry']['location'];

      if (!_isInDordogne(location['lat'], location['lng'])) {
        return null;
      }

      return {
        'lat': location['lat'],
        'lon': location['lng'],
        'formatted_address': data['results'][0]['formatted_address'],
      };
    } catch (e) {
      throw DataException('Failed to get place details: $e');
    }
  }

  @override
  Future<bool> enrichCityData(String cityName) async {
    try {
      final placeDetails = await getPlaceDetails(cityName);
      if (placeDetails == null) return false;

      await _locationService.saveCity(
        cityName: cityName,
        lat: placeDetails['lat'] as double,
        lon: placeDetails['lon'] as double,
        geohash5: Geohash.encode(
            placeDetails['lat'] as double,
            placeDetails['lon'] as double
        ),
      );

      return true;
    } catch (e) {
      throw DataException('Failed to enrich city data: $e');
    }
  }

  @override
  Future<List<String>> enrichMultipleCities(List<String> cityNames) async {
    final successfulCities = <String>[];
    for (final cityName in cityNames) {
      if (await enrichCityData(cityName)) {
        successfulCities.add(cityName);
      }
    }
    return successfulCities;
  }

  /// Recherche des suggestions de lieux à partir d'un texte de recherche
  @override
  Future<Result<List<PlaceSuggestion>>> searchPlaces(
      String query, {
        UserLocation? locationBias,
        int radius = 50000,
      }) async {
    if (query.isEmpty) {
      return Result.value([]);
    }

    try {
      // Construction des paramètres de base
      final params = {
        'input': query,
        'types': '(cities)',
        'components': 'country:fr',
        'key': _apiKey,
        'language': 'fr',
      };

      // Ajout du biais de localisation si fourni
      if (locationBias != null) {
        final circleBias = 'circle:$radius@${locationBias.latitude},${locationBias.longitude}';
        params['locationbias'] = circleBias;
      } else {
        // Utiliser le premier département cible comme biais par défaut
        final defaultDept = _TARGET_DEPARTMENTS.entries.first;
        final center = defaultDept.value['center'];
        final deptRadius = defaultDept.value['radius'];

        final circleBias = 'circle:$deptRadius@${center['lat']},${center['lng']}';
        params['locationbias'] = circleBias;
      }

      final uri = Uri.parse('https://maps.googleapis.com/maps/api/place/autocomplete/json')
          .replace(queryParameters: params);

      final response = await _httpClient.get(uri);

      if (response.statusCode != 200) {
        return Result.error(PlacesApiException(
            'Erreur HTTP ${response.statusCode}: ${response.reasonPhrase}'
        ));
      }

      final data = json.decode(response.body);

      if (data['status'] != 'OK' && data['status'] != 'ZERO_RESULTS') {
        return Result.error(PlacesApiException(
          'Erreur API Places: ${data['status']}',
          errorCode: data['status'],
        ));
      }

      final List<dynamic> predictions = data['predictions'] ?? [];

      final suggestions = predictions.map<PlaceSuggestion>((prediction) {
        final mainText = prediction['structured_formatting']['main_text'] ?? '';
        final secondaryText = prediction['structured_formatting']['secondary_text'] ?? '';

        return PlaceSuggestion(
          placeId: prediction['place_id'],
          primaryText: mainText,
          secondaryText: secondaryText,
        );
      }).toList();

      return Result.value(suggestions);
    } catch (e) {
      return Result.error(PlacesApiException(
          'Erreur lors de la recherche de lieux: ${e.toString()}'
      ));
    }
  }

  /// Implémentation de PlaceDetailsPort.getPlaceDetails
  /// Renommée pour éviter le conflit avec MapsPort.getPlaceDetails
  @override
  Future<Result<PlaceDetails>> getPlaceDetailsById(String placeId) async {
    try {
      // Construction des paramètres
      final params = {
        'place_id': placeId,
        'fields': 'name,formatted_address,geometry/location',
        'key': _apiKey,
        'language': 'fr',
      };

      final uri = Uri.parse('https://maps.googleapis.com/maps/api/place/details/json')
          .replace(queryParameters: params);

      final response = await _httpClient.get(uri);

      if (response.statusCode != 200) {
        return Result.error(PlacesApiException(
            'Erreur HTTP ${response.statusCode}: ${response.reasonPhrase}'
        ));
      }

      final data = json.decode(response.body);

      if (data['status'] != 'OK') {
        return Result.error(PlacesApiException(
          'Erreur API Place Details: ${data['status']}',
          errorCode: data['status'],
        ));
      }

      final result = data['result'];
      final geometry = result['geometry'];
      final location = geometry['location'];

      final placeDetails = PlaceDetails(
        placeId: placeId,
        name: result['name'],
        formattedAddress: result['formatted_address'],
        location: UserLocation(
          latitude: location['lat'],
          longitude: location['lng'],
        ),
        country: null,
        administrativeArea: null,
        locality: null,
        postalCode: null,
        lastUpdated: DateTime.now(),
      );

      return Result.value(placeDetails);
    } catch (e) {
      print('⚠️ Erreur dans getPlaceDetailsById: $e');
      return Result.error(PlacesApiException(
          'Erreur lors de la récupération des détails du lieu: ${e.toString()}'
      ));
    }
  }

  /// Vérifie si un lieu se trouve dans l'un des départements ciblés
  bool isInTargetDepartments(double lat, double lng) {
    // Vérifie d'abord avec la méthode existante pour la Dordogne
    if (_isInDordogne(lat, lng)) {
      return true;
    }

    // Vérifie avec les autres départements ciblés
    for (final dept in _TARGET_DEPARTMENTS.entries) {
      final center = dept.value['center'];
      final radius = dept.value['radius'];

      // Calcule la distance approximative (en mètres)
      final dLat = (lat - center['lat']) * 111000;
      final dLng = (lng - center['lng']) * 111000 * cos(center['lat'] * pi / 180);
      final distance = sqrt(dLat * dLat + dLng * dLng);

      if (distance <= radius) {
        return true;
      }
    }

    return false;
  }
}