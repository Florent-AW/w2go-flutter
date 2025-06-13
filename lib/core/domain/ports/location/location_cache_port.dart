//lib/core/domain/ports/location/location_cache_port.dart

import '../../../domain/models/location/place_suggestion.dart';
import '../../../domain/models/location/place_details.dart';

abstract class LocationCachePort {
  /// Sauvegarde une suggestion de lieu dans le cache
  Future<void> savePlaceSuggestion(PlaceSuggestion suggestion);

  /// Sauvegarde plusieurs suggestions de lieu dans le cache
  Future<void> savePlaceSuggestions(List<PlaceSuggestion> suggestions);

  /// Récupère les suggestions de lieu du cache correspondant à un préfixe
  Future<List<PlaceSuggestion>> getPlaceSuggestions(String prefix, {int limit = 5});

  /// Sauvegarde les détails d'un lieu dans le cache
  Future<void> savePlaceDetails(PlaceDetails details);

  /// Récupère les détails d'un lieu du cache
  Future<PlaceDetails?> getPlaceDetails(String placeId);

  /// Efface le cache des lieux
  Future<void> clearCache();
}