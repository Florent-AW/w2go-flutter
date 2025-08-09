// lib/features/preload/preloader/subcategory_preloader_wiring.dart

// lib/features/preload/preloader/subcategory_preloader_wiring.dart
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'subcategory_preloader.dart';
import '../../search/application/state/experience_providers.dart';
import '../../search/application/state/featured_sections_by_subcategory_provider.dart';
import '../../search/application/state/section_discovery_providers.dart';
import '../../../core/domain/models/shared/city_model.dart';
import '../../../../features/search/application/state/activity_providers.dart';
import '../../../../features/search/application/state/event_providers.dart';
import '../../categories/application/state/subcategories_provider.dart';
import '../application/preload_providers.dart';
import '../application/preload_controller.dart';
import '../../../core/domain/models/shared/experience_item.dart';

const String _eventsCategoryId = 'c3b42899-fdc3-48f7-bd85-09be3381aba9';

/// CÂBLAGE T3 PAR CATÉGORIE (pas besoin d'une sous-catégorie active)
/// - fetchSubcategories : toutes les sous-catégories "avec contenu" pour la catégorie
/// - fetchCarousels    : sections featured (grille) dérivées pour chaque sous-catégorie
/// - fetchItemsHead    : 2 premiers items (activités/événements) par sectionId + sous-catégorie
void wireSubcategoryPreloaderForCategory({
  required WidgetRef ref,
  required City city,
  required String categoryId,
}) {
  final preloader = SubcategoryPreloader.instance;

  // Cache local: sectionId -> items (rempli pendant fetchCarousels)
  final Map<String, List<ItemSummary>> headCache = {};

  // 1) Sous-catégories (avec contenu) pour la catégorie
  preloader.fetchSubcategories = (catId) async {
    final subs = await ref.read(
      subcategoriesWithContentProvider((categoryId: catId, city: city)).future,
    );
    return subs.map((s) => SubcategorySummary(s.id)).toList();
  };

  // 2) Sections featured (grille) pour une sous-catégorie donnée
  preloader.fetchCarousels = (subcategoryId) async {
    // Récupérer la grille de sections pour cette sous-catégorie
    final sections = await ref.read(effectiveSubcategorySectionsProvider(categoryId).future);

    // Charger la tête de liste (2 items) une seule fois pour toutes les sections de cette sous-cat
    final experiencesBySection = await ref.read(
      subcategorySectionExperiencesProvider((
        categoryId: categoryId,
        subcategoryId: subcategoryId,
        city: city,
      )).future,
    );

    // ✅ Déposer immédiatement les items préchargés dans le store global (pour T0 UI)
    try {
      final patch = <String, List<ExperienceItem>>{};
      for (final section in sections) {
        final items = experiencesBySection['section-${section.id}'];
        if (items != null) {
          final key = 'cat:$categoryId:sub:$subcategoryId:${section.id}';
          patch[key] = items;
        }
      }
      if (patch.isNotEmpty) {
        ref.read(preloadControllerProvider.notifier).upsertCarousels(patch);
      }
    } catch (_) {}

    // Alimenter le cache et retourner les carousels
    return sections.map((s) {
      final experiences = (experiencesBySection['section-${s.id}'] ?? const []);
      final firstTwo = experiences.take(2).toList();
      final items = firstTwo
          .map((e) => ItemSummary(imageUrl: e.mainImageUrl))
          .toList();
      headCache[s.id] = items;
      return CarouselSummary(
        s.id,
        firstImageUrls: items.map((e) => e.imageUrl).whereType<String>().take(2).toList(),
      );
    }).toList();
  };

  // 3) Tête de liste (2 items) pour (sectionId, sousCat) via cache
  preloader.fetchItemsHead = (carouselId, {int limit = 2}) async {
    final items = headCache[carouselId] ?? const <ItemSummary>[];
    if (items.length <= limit) return items;
    return items.take(limit).toList();
  };
}



/// CÂBLAGE ciblé pour une sous-catégorie active
/// - N'utilise qu'une seule sous-catégorie (celle passée en paramètre)
/// - Récupère la grille de sections pour cette sous-catégorie
/// - Récupère la tête de liste (2 items) pour chaque section via les providers existants
void wireSubcategoryPreloaderWith({
  required WidgetRef ref,
  required City city,
  required String categoryId,
  required String subcategoryId,
}) {
  final preloader = SubcategoryPreloader.instance;

  // 1) Fournir uniquement la sous-catégorie active
  preloader.fetchSubcategories = (catId) async {
    return [SubcategorySummary(subcategoryId)];
  };

  // 2) Sections featured (grille) pour la sous-catégorie courante
  preloader.fetchCarousels = (subcatId) async {
    final sections = await ref.read(effectiveSubcategorySectionsProvider(categoryId).future);
    // Charger toutes les expériences par section pour MAJ du store global + images clés
    final experiencesBySection = await ref.read(
      subcategorySectionExperiencesProvider((
        categoryId: categoryId,
        subcategoryId: subcategoryId,
        city: city,
      )).future,
    );

    // ✅ Déposer immédiatement dans PreloadController pour injection T0
    try {
      final patch = <String, List<ExperienceItem>>{};
      for (final section in sections) {
        final items = experiencesBySection['section-${section.id}'];
        if (items != null && items.isNotEmpty) {
          final key = 'cat:$categoryId:sub:$subcategoryId:${section.id}';
          patch[key] = items;
        }
      }
      if (patch.isNotEmpty) {
        ref.read(preloadControllerProvider.notifier).upsertCarousels(patch);
      }
    } catch (_) {}

    // Retourner aussi des URLs d'images premières si disponibles (facilite T3)
    return sections.map((s) {
      final items = experiencesBySection['section-${s.id}'] ?? const <ExperienceItem>[];
      final firstTwo = items.take(2).toList();
      return CarouselSummary(
        s.id,
        firstImageUrls: firstTwo.map((e) => e.mainImageUrl).whereType<String>().take(2).toList(),
      );
    }).toList();
  };

  // 3) Tête (2 items) pour (sectionId, sousCat)
  preloader.fetchItemsHead = (carouselId, {int limit = 2}) async {
    final experiencesBySection = await ref.read(
      subcategorySectionExperiencesProvider((
        categoryId: categoryId,
        subcategoryId: subcategoryId,
        city: city,
      )).future,
    );

    final experiences = experiencesBySection['section-$carouselId'] ?? const [];
    return experiences
        .take(limit)
        .map((e) => ItemSummary(imageUrl: e.mainImageUrl))
        .toList();
  };
}

