// lib/core/domain/models/search/filter_types.dart

import '../../../common/constants/section_constants.dart';

/// Types de filtres disponibles dans l'application
enum FilterType {
  /// Filtre pour les activités mises en avant par catégorie
  featured,

  /// Filtre pour les activités "Incontournables" (WOW, bien notées)
  wow,

  /// Filtre pour les activités adaptées aux enfants
  family,

  /// Filtre pour les activités proches de l'utilisateur
  nearby,

  /// Filtre pour les activités d'une sous-catégorie spécifique
  subcategory,

  /// Filtre personnalisé créé par l'utilisateur
  custom
}

/// Extensions pour faciliter l'utilisation des types de filtres
extension FilterTypeExt on FilterType {
  /// Retourne l'ID de section associé au type de filtre
  String? get sectionId {
    switch (this) {
      case FilterType.featured:
        return SectionConstants.featuredSectionId;
      default:
        return null;
    }
  }
}