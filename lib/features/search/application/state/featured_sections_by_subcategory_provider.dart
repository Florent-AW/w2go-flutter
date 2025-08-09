// lib/features/search/application/state/featured_sections_by_subcategory_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/domain/models/search/config/section_metadata.dart';
import 'experience_providers.dart';

typedef FeaturedSectionsBySubcategoryKey = ({String categoryId, String subcategoryId});

/// Dérive les sections featured d'une catégorie pour une sous-catégorie donnée.
/// Hypothèse KISS: même grille de sections pour toutes les sous-catégories
/// d'une catégorie (le filtrage se fait au niveau du contenu, pas des sections).
final featuredSectionsBySubcategoryProvider =
FutureProvider.family<List<SectionMetadata>, FeaturedSectionsBySubcategoryKey>((ref, key) async {
  final sections = await ref.read(featuredSectionsByCategoryProvider(key.categoryId).future);
  // Si plus tard tu stockes un lien direct section<->sousCat (query_filter JSON),
  // tu pourras filtrer ici. Pour l'instant, on renvoie la grille telle quelle.
  return sections;
});
