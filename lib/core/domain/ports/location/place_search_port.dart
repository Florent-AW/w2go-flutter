// lib/core/domain/ports/location/place_search_port.dart


import 'package:async/async.dart';
import '../../../domain/models/location/place_suggestion.dart';
import '../../../domain/models/location/user_location.dart';

abstract class PlaceSearchPort {
  /// Recherche des lieux à partir d'un texte
  Future<Result<List<PlaceSuggestion>>> searchPlaces(
      String query, {
        UserLocation? locationBias,
        int radius = 50000,
      });
}