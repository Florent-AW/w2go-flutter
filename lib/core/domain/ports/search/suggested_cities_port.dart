// lib/core/domain/ports/search/suggested_cities_port.dart

import '../../models/shared/city_model.dart';
import '../../../common/constants/city_constants.dart';

/// Interface pour récupérer les villes suggérées depuis la base de données
abstract class SuggestedCitiesPort {
  // Cette méthode reste pour compatibilité
  Future<List<City>> getSuggestedCitiesByIds(List<String> ids);

  // Méthode principale à utiliser maintenant
  Future<List<City>> getSuggestedCities({
    SuggestedCityType type = SuggestedCityType.aquitaine,
    int limit = SuggestedCitiesConfig.defaultSuggestionCount
  });

  Future<List<City>> getPopularCities({int limit = 10});
}