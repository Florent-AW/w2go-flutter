// lib/core/common/constants/city_constants.dart

/// Type de ville suggérée
enum SuggestedCityType {
  /// Villes majeures du Périgord
  aquitaine,
}

/// Configuration des villes suggérées
class SuggestedCitiesConfig {
  // Pas d'IDs codés en dur, mais des noms de villes
  static const List<String> aquitaineCities = [
    'Sarlat-la-Canéda',
    'Domme',
    'Nontron',
    'Brantôme',
    'Ribérac',
    'Montignac-Lascaux',
    'Limeuil',
    'Saint-Léon-sur-Vézère',
    'La Roque-Gageac'
  ];


  // Nombre par défaut de suggestions à afficher
  static const int defaultSuggestionCount = 10;
}