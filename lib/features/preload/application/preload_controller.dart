// lib/features/preload/application/preload_controller.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/domain/models/shared/city_model.dart';
import '../../../core/domain/models/shared/category_model.dart';
import '../../../core/domain/models/shared/experience_item.dart';
import '../../../core/domain/ports/providers/search/activity_distance_manager_providers.dart';
import '../../search/application/state/activity_providers.dart';
import '../../search/application/state/event_providers.dart';
import '../../categories/application/state/categories_provider.dart';
import '../../categories/application/state/subcategories_provider.dart';
import '../../search/application/state/experience_providers.dart';

/// Header minimal pour affichage instantané des catégories
final class CategoryHeader {
  final String title;
  final String coverUrl;

  const CategoryHeader({
    required this.title,
    required this.coverUrl,
  });
}

enum PreloadState { idle, loading, ready }

class PreloadData {
  final PreloadState state;
  final String? error;
  final List<String> criticalImageUrls;
  final List<CarouselLoadInfo> carouselsInfo;
  final Map<String, List<ExperienceItem>> carouselData;
  final Map<String, CategoryHeader> categoryHeaders;

  const PreloadData({
    required this.state,
    this.error,
    this.criticalImageUrls = const [],
    this.carouselsInfo = const [],
    this.carouselData = const {},
    this.categoryHeaders = const {},
  });

  PreloadData copyWith({
    PreloadState? state,
    String? error,
    List<String>? criticalImageUrls,
    List<CarouselLoadInfo>? carouselsInfo,
    Map<String, List<ExperienceItem>>? carouselData,
    Map<String, CategoryHeader>? categoryHeaders,
  }) {
    return PreloadData(
      state: state ?? this.state,
      error: error ?? this.error,
      criticalImageUrls: criticalImageUrls ?? this.criticalImageUrls,
      carouselsInfo: carouselsInfo ?? this.carouselsInfo,
      carouselData: carouselData ?? this.carouselData,
      categoryHeaders: categoryHeaders ?? this.categoryHeaders,
    );
  }
}

class CarouselLoadInfo {
  final String categoryId;
  final String sectionId;
  final String title;
  final int loadedItems;
  final bool isPartial;
  final int totalAvailable;

  const CarouselLoadInfo({
    required this.categoryId,
    required this.sectionId,
    required this.title,
    required this.loadedItems,
    required this.isPartial,
    required this.totalAvailable,
  });
}

class PreloadController extends StateNotifier<PreloadData> {
  final Ref ref;

  PreloadController(this.ref) : super(const PreloadData(state: PreloadState.idle));

  /// ✅ API PRINCIPALE : Préchargement selon type de page
  Future<void> startPreload(City city, String targetPageType) async {
    print('🚀 PRELOAD: Démarrage pour ${city.cityName}, page: $targetPageType');

    state = state.copyWith(state: PreloadState.loading);

    try {
      if (targetPageType == 'city') {
        await _preloadCityPage(city);
      } else if (targetPageType == 'category') {
        // ✅ CORRECTION : Trouver la catégorie active et utiliser l'API spécialisée
        await _preloadCategoryGeneric(city);
      }

      state = state.copyWith(state: PreloadState.ready);
      print('✅ PRELOAD: Terminé avec succès');

    } catch (e) {
      print('❌ PRELOAD: Erreur: $e');
      state = state.copyWith(
        state: PreloadState.ready, // Fail-open
        error: e.toString(),
      );
    }
  }

  /// Helper : Précharge CategoryPage en trouvant la catégorie active
  Future<void> _preloadCategoryGeneric(City city) async {
    try {
      // ✅ NOUVEAU : Trouver la catégorie à précharger
      String? targetCategoryId;

      // Essayer de récupérer la catégorie sélectionnée (si disponible)
      try {
        final categories = await ref.read(categoriesProvider.future);
        if (categories.isNotEmpty) {
          // Pour MVP : utiliser la première catégorie
          targetCategoryId = categories.first.id;
          print('🎯 PRELOAD CATEGORY GENERIC: Utilisation ${categories.first.name} (${targetCategoryId})');
        }
      } catch (e) {
        print('⚠️ PRELOAD CATEGORY: Impossible de récupérer catégories: $e');
      }

      // ✅ UTILISER l'API spécialisée
      if (targetCategoryId != null) {
        await _preloadSpecificCategoryWithRealSections(targetCategoryId, city);
      } else {
        throw Exception('Aucune catégorie disponible pour preload');
      }

    } catch (e) {
      print('❌ PRELOAD CATEGORY GENERIC: Erreur: $e');
      rethrow;
    }
  }

  /// Précharge données CityPage (toutes catégories)
  Future<void> _preloadCityPage(City city) async {
    try {
      // 1. Récupérer les catégories pour connaître la structure
      final allCategories = await ref.read(categoriesProvider.future);
      if (allCategories.isEmpty) {
        throw Exception('Aucune catégorie disponible');
      }

      const String eventsCategoryId = 'c3b42899-fdc3-48f7-bd85-09be3381aba9';

      // Séparer événements et activités
      final activityCategories = allCategories
          .where((cat) => cat.id != eventsCategoryId)
          .take(6)
          .toList();

      final eventCategory = allCategories.where((cat) => cat.id == eventsCategoryId).isNotEmpty
          ? allCategories.firstWhere((cat) => cat.id == eventsCategoryId)
          : Category(id: eventsCategoryId, name: 'Événements');

      // 2. Charger vraies données avec limites différentielles
      final carouselsInfo = <CarouselLoadInfo>[];
      final carouselData = <String, List<ExperienceItem>>{...state.carouselData};
      final imageUrls = <String>[...state.criticalImageUrls];

      // ✅ Événements (carrousel 1) - 10 items
      final eventsKey = '${eventCategory.id}_7f94df23-ab30-4bf3-afb2-59320e5466a7';
      final eventsData = await _loadCarouselData(
        city, eventCategory, '7f94df23-ab30-4bf3-afb2-59320e5466a7', 10, imageUrls,
      );
      carouselData[eventsKey] = eventsData;

      carouselsInfo.add(CarouselLoadInfo(
        categoryId: eventCategory.id,
        sectionId: '7f94df23-ab30-4bf3-afb2-59320e5466a7',
        title: eventCategory.name,
        loadedItems: eventsData.length,
        isPartial: true, // Déclenche T1
        totalAvailable: 25,
      ));

      // ✅ Activités (carrousels 2-7)
      for (int i = 0; i < activityCategories.length; i++) {
        final category = activityCategories[i];
        final limit = i == 0 ? 10 : 5; // Carrousel 2: 10 items, autres: 5 items

        final activitiesKey = '${category.id}_5aa09feb-397a-4ad1-8142-7dcf0b2edd0f';
        final activitiesData = await _loadCarouselData(
          city, category, '5aa09feb-397a-4ad1-8142-7dcf0b2edd0f', limit, imageUrls,
        );
        carouselData[activitiesKey] = activitiesData;

        carouselsInfo.add(CarouselLoadInfo(
          categoryId: category.id,
          sectionId: '5aa09feb-397a-4ad1-8142-7dcf0b2edd0f',
          title: category.name,
          loadedItems: activitiesData.length,
          isPartial: limit == 5, // Partiels seulement les 5 items
          totalAvailable: 25,
        ));
      }

      // 3. Mettre à jour le state avec vraies données
      state = state.copyWith(
        criticalImageUrls: imageUrls,
        carouselsInfo: carouselsInfo,
        carouselData: carouselData,
      );

      print('✅ PRELOAD CITY: ${carouselsInfo.length} carrousels, ${carouselData.length} datasets, ${imageUrls.length} images');

    } catch (e) {
      print('❌ PRELOAD CITY: Erreur: $e');
      rethrow;
    }
  }

  /// ✅ API SPÉCIALISÉE : Précharge UNE catégorie avec ses vraies sections
  Future<void> startPreloadCategory(City city, String categoryId) async {
    print('🚀 PRELOAD CATEGORY SPECIFIC: $categoryId pour ${city.cityName}');

    state = state.copyWith(state: PreloadState.loading);

    try {
      // ✅ CORRECTION : Charger le header de la catégorie courante
      final currentCategoryHeader = await _fetchCategoryHeader(city, categoryId);
      if (currentCategoryHeader != null) {
        final updatedHeaders = <String, CategoryHeader>{...state.categoryHeaders};
        updatedHeaders[categoryId] = currentCategoryHeader;

        state = state.copyWith(categoryHeaders: updatedHeaders);
        print('🎯 CURRENT CATEGORY HEADER: ${currentCategoryHeader.title} loaded');
      }

      // Charger les carrousels
      await _preloadSpecificCategoryWithRealSections(categoryId, city);

      state = state.copyWith(state: PreloadState.ready);
      print('✅ PRELOAD CATEGORY SPECIFIC: Terminé');
    } catch (e) {
      print('❌ PRELOAD CATEGORY SPECIFIC: Erreur $e');
      state = state.copyWith(state: PreloadState.ready); // Fail-open
    }
  }

  /// ✅ API SILENCIEUSE : Précharge catégorie sans toucher l'état global
  Future<void> warmCategorySilently(City city, String categoryId) async {
    try {
      print('🔥 WARM SILENTLY: $categoryId pour ${city.cityName}');

      // ✅ PAS de state = loading ici (garde l'état actuel)
      await _preloadSpecificCategoryWithRealSections(categoryId, city);
      // ✅ PAS de state = ready non plus

    } catch (e) {
      print('❌ WARM SILENTLY: Erreur $categoryId: $e');
      // Fail silencieusement, pas de changement d'état
    }
  }

  /// ✅ API SILENCIEUSE : Précharge headers de catégories (title + cover)
  Future<void> warmCategoryHeadersSilently(City city, List<String> categoryIds, {int concurrency = 4}) async {
    try {
      print('🔥 WARM HEADERS SILENTLY: ${categoryIds.length} catégories pour ${city.cityName}');

      final headers = <String, CategoryHeader>{...state.categoryHeaders};

      // Helper pour traiter une catégorie
      Future<void> runFor(String catId) async {
        try {
          final header = await _fetchCategoryHeader(city, catId);
          if (header != null) {
            headers[catId] = header;
            print('✅ HEADER LOADED: ${header.title}');
          }
        } catch (e) {
          print('⚠️ HEADER FAILED: $catId - $e');
        }
      }

      // Traitement par batch
      final pending = [...categoryIds];
      while (pending.isNotEmpty) {
        final batch = pending.take(concurrency).toList();
        pending.removeRange(0, batch.length);
        await Future.wait(batch.map(runFor));

        // Mise à jour incrémentale
        state = state.copyWith(categoryHeaders: headers);
      }

      print('✅ WARM HEADERS SILENTLY: ${headers.length} headers chargés');

      // ✅ CORRECTIF D : Ajouter covers dans criticalImageUrls pour précache T0
      final coverUrls = headers.values
          .map((header) => header.coverUrl)
          .where((url) => url.isNotEmpty)
          .toList();

      if (coverUrls.isNotEmpty) {
        final updatedCriticalUrls = [...state.criticalImageUrls, ...coverUrls];
        state = state.copyWith(
          categoryHeaders: headers,
          criticalImageUrls: updatedCriticalUrls,
        );
        print('🖼️ CRITICAL URLS: Ajouté ${coverUrls.length} covers → ${updatedCriticalUrls.length} total');
      } else {
        state = state.copyWith(categoryHeaders: headers);
      }

    } catch (e) {
      print('❌ WARM HEADERS SILENTLY: Erreur $e');
    }
  }

  /// ✅ API SILENCIEUSE T2 : Précharge premiers featured carousels des autres catégories
  Future<void> warmFeaturedCarouselsSilently(City city, {String? excludeCategoryId, int itemsPerCarousel = 3, int concurrency = 4}) async {
    try {
      print('🔥 WARM FEATURED T2 SILENTLY: ${city.cityName} (exclude: $excludeCategoryId)');

      // 1. Récupérer toutes les catégories
      final allCategories = await ref.read(categoriesProvider.future);
      final targetCategories = excludeCategoryId != null
          ? allCategories.where((cat) => cat.id != excludeCategoryId).toList()
          : allCategories;

      if (targetCategories.isEmpty) {
        print('⚠️ WARM FEATURED T2: Aucune catégorie à précharger');
        return;
      }

      print('📋 WARM FEATURED T2: ${targetCategories.length} catégories à traiter');

      final carouselData = <String, List<ExperienceItem>>{...state.carouselData};
      final imageUrls = <String>[...state.criticalImageUrls];

      // ✅ NOUVEAU : Séparer première catégorie (priorité) des autres
      final firstCategory = targetCategories.isNotEmpty ? targetCategories.first : null;
      final otherCategories = targetCategories.skip(1).toList();

      // Helper pour traiter une catégorie
      Future<void> warmCategory(Category category) async {
        try {
          print('🔄 WARM FEATURED T2: Traitement ${category.name}');

          // Récupérer les sections featured pour cette catégorie
          final sections = await ref.read(featuredSectionsByCategoryProvider(category.id).future);
          if (sections.isEmpty) {
            print('⚠️ WARM FEATURED T2: Pas de sections pour ${category.name}');
            return;
          }

          // ✅ NOUVEAU : Traiter TOUTES les sections featured (max 3)
          for (final section in sections.take(3)) {
            final carouselKey = 'cat:${category.id}:featured:${section.id}';

            // Éviter les doublons
            if (carouselData.containsKey(carouselKey)) {
              print('⚠️ WARM FEATURED T2: ${category.name}/${section.title} déjà chargé');
              continue;
            }

            // Charger les données
            const String eventsCategoryId = 'c3b42899-fdc3-48f7-bd85-09be3381aba9';
            final isEvents = category.id == eventsCategoryId;

            List<ExperienceItem> items;
            if (isEvents) {
              final events = await ref.read(getEventsUseCaseProvider).execute(
                latitude: city.lat,
                longitude: city.lon,
                sectionId: section.id, // ✅ Utiliser section.id
                categoryId: category.id,
                limit: itemsPerCarousel,
              );

              if (events.isNotEmpty) {
                ref.read(activityDistancesProvider.notifier).cacheActivitiesDistances(
                  events.map((event) => (
                  id: event.base.id,
                  lat: event.base.latitude,
                  lon: event.base.longitude,
                  )).toList(),
                );
              }

              items = events.map((event) => ExperienceItem.event(event)).toList();
            } else {
              final activities = await ref.read(getActivitiesUseCaseProvider).execute(
                latitude: city.lat,
                longitude: city.lon,
                sectionId: section.id, // ✅ Utiliser section.id
                categoryId: category.id,
                limit: itemsPerCarousel,
              );

              if (activities.isNotEmpty) {
                ref.read(activityDistancesProvider.notifier).cacheActivitiesDistances(
                  activities.map((activity) => (
                  id: activity.base.id,
                  lat: activity.base.latitude,
                  lon: activity.base.longitude,
                  )).toList(),
                );
              }

              items = activities.map((activity) => ExperienceItem.activity(activity)).toList();
            }

            if (items.isNotEmpty) {
              carouselData[carouselKey] = items;

              // Collecter URLs d'images (sans les précacher maintenant)
              for (final item in items) {
                if (item.mainImageUrl?.isNotEmpty == true) {
                  imageUrls.add(item.mainImageUrl!);
                }
              }

              print('✅ WARM FEATURED T2: ${category.name}/${section.title} → ${items.length} items (clé: $carouselKey)');
            }
          }

        } catch (e) {
          print('❌ WARM FEATURED T2: Erreur ${category.name}: $e');
        }
      }

      // ✅ ÉTAPE 1 : Traiter la PREMIÈRE catégorie en priorité (synchrone)
      if (firstCategory != null) {
        print('🎯 WARM FEATURED T2 PRIORITY: ${firstCategory.name} (première catégorie)');
        await warmCategory(firstCategory);

        // Mise à jour immédiate après première catégorie
        state = state.copyWith(
          carouselData: carouselData,
          criticalImageUrls: imageUrls,
        );
        print('✅ WARM FEATURED T2 PRIORITY: Première catégorie terminée');
      }

      // ✅ ÉTAPE 2 : Traiter les autres catégories en parallèle (asynchrone)
      if (otherCategories.isNotEmpty) {
        print('📋 WARM FEATURED T2 BATCH: ${otherCategories.length} autres catégories');

        final pending = [...otherCategories];
        while (pending.isNotEmpty) {
          final batch = pending.take(concurrency).toList();
          pending.removeRange(0, batch.length);
          await Future.wait(batch.map(warmCategory));

          // Mise à jour incrémentale
          state = state.copyWith(
            carouselData: carouselData,
            criticalImageUrls: imageUrls,
          );
        }
      }

      print('✅ WARM FEATURED T2 SILENTLY: ${targetCategories.length} catégories terminées');

    } catch (e) {
      print('❌ WARM FEATURED T2 SILENTLY: Erreur $e');
    }
  }

  /// Helper : Récupère header d'une catégorie (nom + cover)
  Future<CategoryHeader?> _fetchCategoryHeader(City city, String categoryId) async {
    try {
      // 1) Titre depuis le modèle
      final allCats = await ref.read(categoriesProvider.future);
      final cat = allCats.cast<Category?>().firstWhere(
            (c) => c?.id == categoryId,
        orElse: () => null,
      );
      if (cat == null) return null;

      // Utiliser directement la cover de catégorie (plus fiable)
      String coverUrl = cat.coverUrl ?? '';

      // ✅ OPTIONNEL : Essayer de récupérer depuis première activité si cover catégorie vide
      if (coverUrl.isEmpty) {
        try {
          const String eventsCategoryId = 'c3b42899-fdc3-48f7-bd85-09be3381aba9';
          const String featuredSectionId = '5aa09feb-397a-4ad1-8142-7dcf0b2edd0f';

          final isEvents = categoryId == eventsCategoryId;
          final sectionId = isEvents ? '7f94df23-ab30-4bf3-afb2-59320e5466a7' : featuredSectionId;

          List<dynamic> items;
          if (isEvents) {
            items = await ref.read(getEventsUseCaseProvider).execute(
              latitude: city.lat,
              longitude: city.lon,
              sectionId: sectionId,
              categoryId: categoryId,
              limit: 1,
            );
          } else {
            items = await ref.read(getActivitiesUseCaseProvider).execute(
              latitude: city.lat,
              longitude: city.lon,
              sectionId: sectionId,
              categoryId: categoryId,
              limit: 1,
            );
          }

          // ✅ EXTRACTION SIMPLE avec try/catch global
          if (items.isNotEmpty) {
            final item = items.first;
            try {
              // Essayer diverses propriétés possibles
              coverUrl = (item as dynamic).mainImageUrl ??
                  (item as dynamic).imageUrl ??
                  (item as dynamic).picture ??
                  (item as dynamic).thumbnail ?? '';
            } catch (_) {
              // Ignore, coverUrl reste vide → utilise cat.coverUrl
            }
          }
        } catch (e) {
          print('⚠️ COVER FETCH: Fallback failed pour $categoryId: $e');
        }
      }

      return CategoryHeader(title: cat.name, coverUrl: coverUrl);

    } catch (e) {
      print('❌ FETCH HEADER: Erreur $categoryId: $e');
      return null;
    }
  }

  /// Charge UNE catégorie avec ses VRAIES sections
  Future<void> _preloadSpecificCategoryWithRealSections(String categoryId, City city) async {
    try {
      const String eventsCategoryId = 'c3b42899-fdc3-48f7-bd85-09be3381aba9';
      const limit = 3;

      final imageUrls = <String>[...state.criticalImageUrls];

      print('🔄 PRELOAD SPECIFIC CATEGORY: $categoryId pour ${city.cityName}');

      // ✅ ÉVÉNEMENTS : Section spéciale
      if (categoryId == eventsCategoryId) {
        try {
          final eventsSectionId = '7f94df23-ab30-4bf3-afb2-59320e5466a7';

        } catch (e) {
          print('⚠️ PRELOAD EVENTS: Échec $e');
        }
      }
      // ✅ ACTIVITÉS : Section générale + subcategories
      else {
        try {
          final activitiesSectionId = '5aa09feb-397a-4ad1-8142-7dcf0b2edd0f';

          // ✅ CORRECTION : Vraies subcategories (pas d'IDs génériques)
          try {
            final subcategories = await ref.read(subCategoriesForCategoryProvider(categoryId).future);
            print('📋 SUBCATEGORIES FOUND: ${subcategories.length} pour $categoryId');

          } catch (e) {
            print('⚠️ PRELOAD SUBCATEGORIES: Pas de subcategories ou erreur: $e');
            // Pas grave, on a au moins featured
          }

        } catch (e) {
          print('⚠️ PRELOAD ACTIVITIES: Échec $e');
        }
      }

      // ✅ DUPLICATION CITY pour compatibilité immédiate


    } catch (e) {
      print('❌ PRELOAD SPECIFIC CATEGORY: Erreur $e');
      rethrow;
    }
  }

  /// Helper: Charge les données d'un carrousel CityPage
  Future<List<ExperienceItem>> _loadCarouselData(
      City city,
      Category category,
      String sectionId,
      int limit,
      List<String> imageUrls,
      ) async {
    try {
      const String eventsCategoryId = 'c3b42899-fdc3-48f7-bd85-09be3381aba9';
      final isEvents = category.id == eventsCategoryId;

      List<ExperienceItem> items;

      if (isEvents) {
        final events = await ref.read(getEventsUseCaseProvider).execute(
          latitude: city.lat,
          longitude: city.lon,
          sectionId: sectionId,
          categoryId: category.id,
          limit: limit,
        );

        if (events.isNotEmpty) {
          ref.read(activityDistancesProvider.notifier).cacheActivitiesDistances(
            events.map((event) => (
            id: event.base.id,
            lat: event.base.latitude,
            lon: event.base.longitude,
            )).toList(),
          );
        }

        items = events.map((event) => ExperienceItem.event(event)).toList();
      } else {
        final activities = await ref.read(getActivitiesUseCaseProvider).execute(
          latitude: city.lat,
          longitude: city.lon,
          sectionId: sectionId,
          categoryId: category.id,
          limit: limit,
        );

        if (activities.isNotEmpty) {
          ref.read(activityDistancesProvider.notifier).cacheActivitiesDistances(
            activities.map((activity) => (
            id: activity.base.id,
            lat: activity.base.latitude,
            lon: activity.base.longitude,
            )).toList(),
          );
        }

        items = activities.map((activity) => ExperienceItem.activity(activity)).toList();
      }

      // Collecter URLs d'images pour précache (version sécurisée)
      for (final item in items) {
        if (item.mainImageUrl?.isNotEmpty == true) {
          imageUrls.add(item.mainImageUrl!);
        }
      }

      print('✅ PRELOAD DATA: ${category.name} → ${items.length} items (limit: $limit)');
      return items;

    } catch (e) {
      print('❌ PRELOAD CAROUSEL DATA: Erreur ${category.name}: $e');
      return [];
    }
  }

  /// Reset l'état
  void reset() {
    state = const PreloadData(state: PreloadState.idle);
  }
}
/// Extension pour extraction facile des URLs de cover
extension PreloadDataX on PreloadData {
  List<String> coverUrlsFor(Iterable<String> catIds) =>
      catIds
          .map((id) => categoryHeaders[id]?.coverUrl)
          .where((url) => url != null && url.isNotEmpty)
          .cast<String>()
          .toList();
}