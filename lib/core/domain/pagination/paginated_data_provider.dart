import '../models/shared/experience_item.dart';
import 'paginated_result.dart';

/// Interface abstraite pour tous les providers de données paginées
abstract class PaginatedDataProvider<T> {
  /// Charge une page de données
  Future<PaginatedResult<T>> loadPage({
    required int offset,
    required int limit,
    Map<String, dynamic>? filters,
  });

  /// Identifiant unique du provider (pour cache et debug)
  String get providerId;

  /// Taille de page par défaut
  int get defaultPageSize;

  /// Taille de page pour le preload (T0)
  int get preloadPageSize;
}

/// Provider spécialisé pour les expériences (activités + événements)
abstract class ExperienceDataProvider extends PaginatedDataProvider<ExperienceItem> {
  /// Paramètres de géolocalisation (requis pour les expériences)
  double get latitude;
  double get longitude;

  /// ID de section (requis)
  String get sectionId;

  /// ID de catégorie (optionnel selon le type)
  String? get categoryId;

  /// ID de sous-catégorie (optionnel)
  String? get subcategoryId;
}