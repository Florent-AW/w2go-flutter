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
  final Map<String, CategoryHeader> categoryHeaders; // ✅ NOUVEAU

  const PreloadData({
    required this.state,
    this.error,
    this.criticalImageUrls = const [],
    this.carouselsInfo = const [],
    this.carouselData = const {},
    this.categoryHeaders = const {}, // ✅ NOUVEAU
  });

  PreloadData copyWith({
    PreloadState? state,
    String? error,
    List<String>? criticalImageUrls,
    List<CarouselLoadInfo>? carouselsInfo,
    Map<String, List<ExperienceItem>>? carouselData,
    Map<String, CategoryHeader>? categoryHeaders, // ✅ NOUVEAU
  }) {
    return PreloadData(
      state: state ?? this.state,
      error: error ?? this.error,
      criticalImageUrls: criticalImageUrls ?? this.criticalImageUrls,
      carouselsInfo: carouselsInfo ?? this.carouselsInfo,
      carouselData: carouselData ?? this.carouselData,
      categoryHeaders: categoryHeaders ?? this.categoryHeaders, // ✅ NOUVEAU
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

  /// ✅ API SPÉCIALISÉE : Préchargement catégorie spécifique
  Future<void> preloadCategory(String categoryId, City city) async {
    print('🚀 PRELOAD CATEGORY SPECIFIC: $categoryId pour ${city.cityName}');

    state = state.copyWith(state: PreloadState.loading);

    try {
      await _preloadSpecificCategory(categoryId, city);
      state = state.copyWith(state: PreloadState.ready);
      print('✅ PRELOAD CATEGORY SPECIFIC: Terminé');
    } catch (e) {
      print('❌ PRELOAD CATEGORY SPECIFIC: Erreur $e');
      state = state.copyWith(state: PreloadState.ready); // Fail-open
    }
  }

  /// Précharge données CityPage (toutes catégories)
  Future<void> _preloadCityPage(City city) async {
    try {
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

      // Jobs à charger
      final jobs = <(String sectionId, Category cat, int limit)>[
        ('7f94df23-ab30-4bf3-afb2-59320e5466a7', eventCategory, 10), // événements
        ...activityCategories.map((c) => ('5aa09feb-397a-4ad1-8142-7dcf0b2edd0f', c, 10)),
      ];

      final carouselData = <String, List<ExperienceItem>>{...state.carouselData};
      final imageUrls = <String>[...state.criticalImageUrls];
      final carouselsInfo = <CarouselLoadInfo>[];

      // Charger séquentiellement (simple)
      for (final (sectionId, category, limit) in jobs) {
        try {
          print('🔄 PRELOAD CITY JOB: ${category.name} (limit=$limit)');

          final items = await _loadCarouselData(city, category, sectionId, limit, imageUrls);
          final key = '${category.id}_$sectionId';

          if (items.isNotEmpty) {
            carouselData[key] = items;

            carouselsInfo.add(CarouselLoadInfo(
              categoryId: category.id,
              sectionId: sectionId,
              title: category.name,
              loadedItems: items.length,
              isPartial: true,
              totalAvailable: 25,
            ));

            print('✅ PRELOAD CITY STORED: "$key" → ${items.length} items');
          }

          // Mise à jour incrémentale
          state = state.copyWith(carouselData: carouselData);

        } catch (e) {
          print('❌ PRELOAD CITY JOB: Erreur ${category.name}: $e');
        }
      }

      // Mise à jour finale
      state = state.copyWith(
        carouselData: carouselData,
        carouselsInfo: carouselsInfo,
        criticalImageUrls: imageUrls,
      );

      print('✅ PRELOAD CITY: ${carouselsInfo.length} carrousels, ${carouselData.length} datasets');

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

      print('✅ WARM SILENTLY: $categoryId terminé (${state.carouselData.length} datasets)');
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

      final carouselData = <String, List<ExperienceItem>>{...state.carouselData};
      final imageUrls = <String>[...state.criticalImageUrls];

      print('🔄 PRELOAD SPECIFIC CATEGORY: $categoryId pour ${city.cityName}');

      // ✅ ÉVÉNEMENTS : Section spéciale
      if (categoryId == eventsCategoryId) {
        try {
          final eventsSectionId = '7f94df23-ab30-4bf3-afb2-59320e5466a7';
          final eventsKey = 'cat:$categoryId:featured:$eventsSectionId';

          final eventsItems = await _loadCategoryCarouselData(
              city, categoryId, eventsSectionId, null, limit, imageUrls);

          if (eventsItems.isNotEmpty) {
            carouselData[eventsKey] = eventsItems;
            print('✅ PRELOAD EVENTS REAL: $eventsKey → ${eventsItems.length} items');
          }
        } catch (e) {
          print('⚠️ PRELOAD EVENTS: Échec $e');
        }
      }
      // ✅ ACTIVITÉS : Section générale + subcategories
      else {
        try {
          final activitiesSectionId = '5aa09feb-397a-4ad1-8142-7dcf0b2edd0f';

          // Featured (sans subcategory)
          final featuredKey = 'cat:$categoryId:featured:$activitiesSectionId';
          final featuredItems = await _loadCategoryCarouselData(
              city, categoryId, activitiesSectionId, null, limit, imageUrls);

          if (featuredItems.isNotEmpty) {
            carouselData[featuredKey] = featuredItems;
            print('✅ PRELOAD FEATURED REAL: $featuredKey → ${featuredItems.length} items');
          }

          // ✅ CORRECTION : Vraies subcategories (pas d'IDs génériques)
          try {
            final subcategories = await ref.read(subCategoriesForCategoryProvider(categoryId).future);
            print('📋 SUBCATEGORIES FOUND: ${subcategories.length} pour $categoryId');

            // Utiliser les 2 premières subcategories réelles
            for (final subcategory in subcategories.take(2)) {
              final subKey = 'cat:$categoryId:sub:${subcategory.id}:$activitiesSectionId';
              final subItems = await _loadCategoryCarouselData(
                  city, categoryId, activitiesSectionId, subcategory.id, limit, imageUrls);

              if (subItems.isNotEmpty) {
                carouselData[subKey] = subItems;
                print('✅ PRELOAD SUB REAL: $subKey → ${subItems.length} items');
              }
            }
          } catch (e) {
            print('⚠️ PRELOAD SUBCATEGORIES: Pas de subcategories ou erreur: $e');
            // Pas grave, on a au moins featured
          }

        } catch (e) {
          print('⚠️ PRELOAD ACTIVITIES: Échec $e');
        }
      }

      // ✅ DUPLICATION CITY pour compatibilité immédiate
      final cityDuplicates = <String, List<ExperienceItem>>{};

      for (final entry in carouselData.entries) {
        final categoryKey = entry.key;
        final items = entry.value;

        // Si c'est une clé Category featured, dupliquer sous format City
        if (categoryKey.startsWith('cat:') && categoryKey.contains(':featured:')) {
          final parts = categoryKey.split(':');
          if (parts.length >= 4) {
            final catId = parts[1];
            final sectionId = parts[3];

            final cityKey = '${catId}_$sectionId';
            cityDuplicates[cityKey] = items;
            print('✅ PRELOAD DUPLICATE TO CITY: $cityKey → ${items.length} items');
          }
        }
      }

      // Ajouter les duplicatas
      carouselData.addAll(cityDuplicates);

      // Mise à jour state
      state = state.copyWith(
        carouselData: carouselData,
        criticalImageUrls: imageUrls,
      );

      print('✅ PRELOAD SPECIFIC CATEGORY: ${carouselData.length} total datasets');

    } catch (e) {
      print('❌ PRELOAD SPECIFIC CATEGORY: Erreur $e');
      rethrow;
    }
  }

  /// Précharge catégorie spécifique avec vraies données
  Future<void> _preloadSpecificCategory(String categoryId, City city) async {
    try {
      const limit = 3; // KISS: 3 items par carrousel
      final carouselData = <String, List<ExperienceItem>>{...state.carouselData};
      final imageUrls = <String>[...state.criticalImageUrls];

      // Featured section
      try {
        final featuredKey = 'cat:$categoryId:featured:default';
        final featuredItems = await _loadCategoryCarouselData(
            city, categoryId, 'default', null, limit, imageUrls);

        if (featuredItems.isNotEmpty) {
          carouselData[featuredKey] = featuredItems;
          print('✅ PRELOAD FEATURED: $featuredKey → ${featuredItems.length} items');
        }
      } catch (e) {
        print('⚠️ PRELOAD FEATURED: Échec $e');
      }

      // Subcategories
      try {
        final subKeys = ['sub1', 'sub2']; // 2 subcategories max

        for (final subId in subKeys) {
          final subKey = 'cat:$categoryId:sub:$subId:default';
          final subItems = await _loadCategoryCarouselData(
              city, categoryId, 'default', subId, limit, imageUrls);

          if (subItems.isNotEmpty) {
            carouselData[subKey] = subItems;
            print('✅ PRELOAD SUB: $subKey → ${subItems.length} items');
          }
        }
      } catch (e) {
        print('⚠️ PRELOAD SUB: Échec $e');
      }

      // Mise à jour state
      state = state.copyWith(
        carouselData: carouselData,
        criticalImageUrls: imageUrls,
      );

      print('✅ PRELOAD SPECIFIC CATEGORY: ${carouselData.length} total datasets');

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

      return items;

    } catch (e) {
      print('❌ PRELOAD CAROUSEL DATA: Erreur ${category.name}: $e');
      return [];
    }
  }

  /// Helper: Charge les données d'un carrousel CategoryPage
  Future<List<ExperienceItem>> _loadCategoryCarouselData(
      City city,
      String categoryId,
      String sectionId,
      String? subcategoryId,
      int limit,
      List<String> imageUrls,
      ) async {
    try {
      const String eventsCategoryId = 'c3b42899-fdc3-48f7-bd85-09be3381aba9';
      final isEvents = categoryId == eventsCategoryId;

      List<ExperienceItem> items;

      if (isEvents) {
        final events = await ref.read(getEventsUseCaseProvider).execute(
          latitude: city.lat,
          longitude: city.lon,
          sectionId: sectionId,
          categoryId: categoryId,
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
          categoryId: categoryId,
          subcategoryId: subcategoryId,
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

      return items;

    } catch (e) {
      print('❌ PRELOAD CATEGORY CAROUSEL: Erreur $categoryId/$sectionId: $e');
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


