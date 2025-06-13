// lib/core/adapters/supabase/search/suggested_cities_adapter.dart
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../domain/models/shared/city_model.dart';
import '../../../domain/ports/search/suggested_cities_port.dart';
import '../../../common/constants/city_constants.dart';

class SupabaseSuggestedCitiesAdapter implements SuggestedCitiesPort {
  final SupabaseClient _supabase;

  SupabaseSuggestedCitiesAdapter(this._supabase);

  @override
  Future<List<City>> getSuggestedCities({
    SuggestedCityType type = SuggestedCityType.aquitaine,
    int limit = SuggestedCitiesConfig.defaultSuggestionCount
  }) async {
    List<String> cityNames;

    switch (type) {
      case SuggestedCityType.aquitaine:
        cityNames = SuggestedCitiesConfig.aquitaineCities;
        break;
      default:
        cityNames = SuggestedCitiesConfig.aquitaineCities;
        break;
    }

    // Limiter au nombre demandé
    cityNames = cityNames.take(limit).toList();

    try {
      print('DEBUG [Adapter]: Recherche de ${cityNames.length} villes par nom: ${cityNames.take(3).join(", ")}');

      // Utiliser filter('colonne', 'in', valeurs) à la place de in_
      final response = await _supabase
          .from('cities')
          .select()
          .filter('city_name', 'in', cityNames) // Recherche par nom de ville avec filter
          .order('city_name');

      print('DEBUG [Adapter]: Réponse Supabase: ${response != null ? 'non-null' : 'null'}');

      if (response == null) return [];

      final cities = (response as List).map<City>((json) => City.fromJson(json)).toList();
      print('DEBUG [Adapter]: Nombre de villes trouvées par nom: ${cities.length}');

      // Fallback - si aucune ville n'est trouvée, prendre les premières de la base
      if (cities.isEmpty) {
        print('DEBUG [Adapter]: Aucune ville trouvée par nom, récupération des premières villes');
        final fallbackResponse = await _supabase
            .from('cities')
            .select()
            .order('city_name')
            .limit(limit);

        if (fallbackResponse != null) {
          final fallbackCities = (fallbackResponse as List).map<City>((json) => City.fromJson(json)).toList();
          print('DEBUG [Adapter]: Nombre de villes fallback trouvées: ${fallbackCities.length}');
          return fallbackCities;
        }
      }

      return cities;
    } catch (e) {
      print('❌ Erreur lors de la récupération des villes suggérées: $e');
      return [];
    }
  }

  // Méthode conservée pour compatibilité
  @override
  Future<List<City>> getSuggestedCitiesByIds(List<String> ids) async {
    print('DEBUG [Adapter]: Méthode dépréciée - utiliser getSuggestedCities() à la place');
    // Rediriger vers la nouvelle méthode plus robuste
    return getSuggestedCities();
  }


  // Méthode factory pour l'initialisation
  static SupabaseSuggestedCitiesAdapter fromService(SupabaseClient supabase) {
    return SupabaseSuggestedCitiesAdapter(supabase);
  }

  Future<List<City>> getPopularCities({int limit = 10}) async {
    // Utiliser simplement la méthode getSuggestedCities avec le type Aquitaine
    return getSuggestedCities(
        type: SuggestedCityType.aquitaine,
        limit: limit
    );
  }

}