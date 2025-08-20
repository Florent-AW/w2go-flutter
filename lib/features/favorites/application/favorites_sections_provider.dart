// lib/features/favorites/application/favorites_sections_provider.dart

import 'package:riverpod/riverpod.dart';
import 'package:travel_in_perigord_app/core/domain/models/shared/experience_item.dart';
import 'package:travel_in_perigord_app/core/domain/ports/providers/repositories/repository_providers.dart';

class FavoritesSection {
  final String title;
  final List<ExperienceItem> items;
  const FavoritesSection({required this.title, required this.items});
}

/// Construit des sections de favoris à partir du stream global
/// - Groupage: département (futur) -> ville -> "Divers"
/// - Tri des sections: alphabétique A→Z
/// - Tri intra-section: conserve l'ordre d'arrivée (déjà updatedAt desc au niveau repo)
final favoritesSectionsProvider =
    StreamProvider.autoDispose<List<FavoritesSection>>((ref) {
  final repo = ref.watch(favoritesRepositoryProvider);
  return repo.watchFavorites().map((List<ExperienceItem> items) {
    final Map<String, List<ExperienceItem>> grouped = <String, List<ExperienceItem>>{};

    for (final item in items) {
      final String groupTitle = _groupTitle(item);
      final bucket = grouped[groupTitle] ?? <ExperienceItem>[];
      bucket.add(item);
      grouped[groupTitle] = bucket;
    }

    final sections = grouped.entries
        .map((e) => FavoritesSection(title: e.key, items: e.value))
        .toList(growable: false);

    sections.sort((a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()));
    return sections;
  });
});

String _groupTitle(ExperienceItem item) {
  // TODO (future): utiliser departmentName quand présent dans le snapshot Drift
  final String? city = item.city;
  if (city != null && city.trim().isNotEmpty) return city;
  return 'Divers';
}
