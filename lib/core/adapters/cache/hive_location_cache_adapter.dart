// lib/core/adapters/cache/hive_location_cache_adapter.dart

import 'package:hive/hive.dart';
import 'hive_adapters.dart';
import '../../domain/ports/location/location_cache_port.dart';
import '../../domain/models/location/place_suggestion.dart';
import '../../domain/models/location/place_details.dart';
import '../../common/constants/location_constants.dart';

class HiveLocationCacheAdapter implements LocationCachePort {
  static const String _suggestionsBoxName = 'place_suggestions';
  static const String _detailsBoxName = 'place_details';

  // Initialiser les boîtes avec des valeurs par défaut
  Box<Map>? _suggestionsBox;
  Box<Map>? _detailsBox;
  bool _isInitialized = false;

  // Modifier cette méthode pour qu'elle soit synchrone
  void initialize() {
    try {
      // Enregistrer les adaptateurs
      if (!Hive.isAdapterRegistered(userLocationTypeId)) {
        Hive.registerAdapter(UserLocationAdapter());
      }
      if (!Hive.isAdapterRegistered(placeDetailsTypeId)) {
        Hive.registerAdapter(PlaceDetailsAdapter());
      }
      if (!Hive.isAdapterRegistered(placeSuggestionTypeId)) {
        Hive.registerAdapter(PlaceSuggestionAdapter());
      }

      // Ouvrir les boxes de manière synchrone si possible, sinon les laisser null
      try {
        if (Hive.isBoxOpen(_suggestionsBoxName)) {
          _suggestionsBox = Hive.box<Map>(_suggestionsBoxName);
        }
        if (Hive.isBoxOpen(_detailsBoxName)) {
          _detailsBox = Hive.box<Map>(_detailsBoxName);
        }
        _isInitialized = true;
        print('✅ Cache Hive initialisé avec succès');
      } catch (e) {
        print('⚠️ Impossible d\'ouvrir les boîtes Hive de manière synchrone: $e');
        // Ne pas marquer comme initialisé
      }
    } catch (e) {
      print('❌ Erreur lors de l\'initialisation du cache: $e');
    }
  }

  // Méthode pour initialiser de manière asynchrone (à appeler au démarrage de l'app)
  Future<void> initializeAsync() async {
    try {
      // Enregistrer les adaptateurs
      if (!Hive.isAdapterRegistered(userLocationTypeId)) {
        Hive.registerAdapter(UserLocationAdapter());
      }
      if (!Hive.isAdapterRegistered(placeDetailsTypeId)) {
        Hive.registerAdapter(PlaceDetailsAdapter());
      }
      if (!Hive.isAdapterRegistered(placeSuggestionTypeId)) {
        Hive.registerAdapter(PlaceSuggestionAdapter());
      }

      // Ouvrir les boxes
      if (!Hive.isBoxOpen(_suggestionsBoxName)) {
        _suggestionsBox = await Hive.openBox<Map>(_suggestionsBoxName);
      } else {
        _suggestionsBox = Hive.box<Map>(_suggestionsBoxName);
      }

      if (!Hive.isBoxOpen(_detailsBoxName)) {
        _detailsBox = await Hive.openBox<Map>(_detailsBoxName);
      } else {
        _detailsBox = Hive.box<Map>(_detailsBoxName);
      }

      _isInitialized = true;
      print('✅ Cache Hive initialisé avec succès (async)');
    } catch (e) {
      print('❌ Erreur lors de l\'initialisation asynchrone du cache: $e');
    }
  }

  // Vérifier si les boîtes sont initialisées avant de les utiliser
  bool get isInitialized => _isInitialized && _suggestionsBox != null && _detailsBox != null;

  // Mettre à jour les méthodes pour vérifier l'initialisation
  @override
  Future<void> savePlaceSuggestion(PlaceSuggestion suggestion) async {
    if (!isInitialized) {
      await initializeAsync();
    }
    if (_suggestionsBox == null) return;

    await _suggestionsBox!.put(
      suggestion.placeId,
      suggestion.toJson(),
    );
  }

  // Modifier les autres méthodes de la même façon
  @override
  Future<void> savePlaceSuggestions(List<PlaceSuggestion> suggestions) async {
    if (!isInitialized) {
      await initializeAsync();
    }
    if (_suggestionsBox == null) return;

    final Map<dynamic, Map<String, dynamic>> entries = {
      for (var suggestion in suggestions)
        suggestion.placeId: suggestion.toJson()
    };

    await _suggestionsBox!.putAll(entries);
  }

  @override
  Future<List<PlaceSuggestion>> getPlaceSuggestions(String prefix, {int limit = 5}) async {
    if (!isInitialized) {
      await initializeAsync();
    }
    if (_suggestionsBox == null) return [];

    final suggestions = <PlaceSuggestion>[];

    // Parcourir tous les éléments pour trouver ceux correspondant au préfixe
    for (var key in _suggestionsBox!.keys) {
      final data = _suggestionsBox!.get(key);
      if (data == null) continue;

      try {
        final suggestion = PlaceSuggestion.fromJson(Map<String, dynamic>.from(data));

        // Vérifier si la suggestion correspond au préfixe (insensible à la casse)
        if (suggestion.primaryText.toLowerCase().contains(prefix.toLowerCase())) {
          suggestions.add(suggestion.copyWith(isFromCache: true));

          // Limiter le nombre de résultats
          if (suggestions.length >= limit) break;
        }
      } catch (e) {
        print('⚠️ Erreur lors de la conversion d\'une suggestion: $e');
      }
    }

    return suggestions;
  }

  @override
  Future<void> savePlaceDetails(PlaceDetails details) async {
    if (!isInitialized) {
      await initializeAsync();
    }
    if (_detailsBox == null) return;

    await _detailsBox!.put(
      details.placeId,
      details.toJson(),
    );

    // Limiter la taille du cache si nécessaire
    if (_detailsBox!.length > LocationConstants.maxCacheEntries) {
      final keysToDelete = _detailsBox!.keys.take(_detailsBox!.length - LocationConstants.maxCacheEntries);
      await _detailsBox!.deleteAll(keysToDelete);
    }
  }

  @override
  Future<PlaceDetails?> getPlaceDetails(String placeId) async {
    if (!isInitialized) {
      await initializeAsync();
    }
    if (_detailsBox == null) return null;

    final data = _detailsBox!.get(placeId);
    if (data == null) return null;

    try {
      return PlaceDetails.fromJson(Map<String, dynamic>.from(data));
    } catch (e) {
      print('⚠️ Erreur lors de la récupération des détails: $e');
      return null;
    }
  }

  @override
  Future<void> clearCache() async {
    if (!isInitialized) {
      await initializeAsync();
    }
    if (_suggestionsBox != null) await _suggestionsBox!.clear();
    if (_detailsBox != null) await _detailsBox!.clear();
  }
}