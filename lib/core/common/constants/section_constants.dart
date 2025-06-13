// lib/core/common/constants/section_constants.dart

/// Constantes pour les IDs de sections dans Supabase
/// Centralise toutes les références aux IDs de section pour maintenir la cohérence
class SectionConstants {
  // ------ IDs des sections principales ------

  // Section par catégorie
  static const String featuredSectionId = 'a62c6046-8814-456f-91ba-b65aa7e73137'; // Activités par catégorie

  // Pour les sections de sous-catégorie, utiliser les IDs existants:
  static const String topRatedSectionId = 'b9d88b6b-61b4-412b-ae73-062f48758dfa'; // Les plus populaires (à utiliser pour "Les mieux notées")
  static const String nearestSectionId = '709670fb-6ffe-4202-8a9e-93a3c842170b'; // Autour de Moi (à utiliser pour "Près de vous")
  static const String popularSectionId = 'cdbb5b7c-1f8f-4a04-aa1b-15a9845ad5b3'; // Les trésors cachés (à utiliser pour "Les méconnus")

  // ------ Titres des sections ------

  /// Mapping des identifiants d'UI vers les titres
  static const Map<String, String> sectionTitles = {
    // Clés d'UI pour les sections de sous-catégories
    'top-rated': 'Les mieux notées',
    'most-popular': 'Les plus populaires',
    'nearby': 'Près de vous',

    // Clés pour les sections principales
    'featured': 'Activités recommandées',
    'wow': 'Les incontournables',
    'family': 'En famille',
    'near-me': 'Autour de moi',
  };
}