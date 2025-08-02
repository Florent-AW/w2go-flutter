// lib/features/preload/application/preload_controller.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/domain/models/shared/city_model.dart';
import '../../../core/domain/models/shared/category_model.dart';
import '../../../core/domain/models/shared/experience_item.dart';
import '../../../core/domain/ports/providers/search/activity_distance_manager_providers.dart';
import '../../search/application/state/activity_providers.dart';
import '../../search/application/state/event_providers.dart';
import '../../search/application/state/section_discovery_providers.dart';
import '../../categories/application/state/categories_provider.dart';
import '../../../features/search/application/state/experience_providers.dart';


enum PreloadState { idle, loading, ready }

class PreloadData {
  final PreloadState state;
  final String? error;
  final List<String> criticalImageUrls;
  final List<CarouselLoadInfo> carouselsInfo;
  final Map<String, List<ExperienceItem>> carouselData; // ✅ NOUVEAU

  const PreloadData({
    required this.state,
    this.error,
    this.criticalImageUrls = const [],
    this.carouselsInfo = const [],
    this.carouselData = const {}, // ✅ NOUVEAU
  });

  PreloadData copyWith({
    PreloadState? state,
    String? error,
    List<String>? criticalImageUrls,
    List<CarouselLoadInfo>? carouselsInfo,
    Map<String, List<ExperienceItem>>? carouselData,
  }) {
    return PreloadData(
      state: state ?? this.state,
      error: error ?? this.error,
      criticalImageUrls: criticalImageUrls ?? this.criticalImageUrls,
      carouselsInfo: carouselsInfo ?? this.carouselsInfo,
      carouselData: carouselData ?? this.carouselData,
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

  /// Démarre le préchargement pour une ville et page cible
  Future<void> startPreload(City city, String targetPageType) async {
    print('🚀 PRELOAD: Démarrage pour ${city.cityName}, page: $targetPageType');

    state = state.copyWith(state: PreloadState.loading);

    try {
      // Gérer selon le type de page cible
      if (targetPageType == 'city') {
        await _preloadCityPage(city);
      } else if (targetPageType == 'category') {
        await _preloadCategoryPage(city);  // ✅ NOUVEAU
      }
      // TODO: Ajouter d'autres types si nécessaire

      state = state.copyWith(state: PreloadState.ready);
      print('✅ PRELOAD: Terminé avec succès');

    } catch (e) {
      print('❌ PRELOAD: Erreur: $e');
      state = state.copyWith(
        state: PreloadState.ready, // On continue quand même
        error: e.toString(),
      );
    }
  }

  /// Charge les vraies données d'un carrousel avec cache des distances
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

      // ✅ NOUVEAU : Logs de debug pour les événements
      print('🔍 PRELOAD DATA DEBUG: ${category.name} (id: ${category.id})');
      print('  - isEvents: $isEvents');
      print('  - city: ${city.cityName} (${city.lat}, ${city.lon})');
      print('  - sectionId: $sectionId');
      print('  - limit: $limit');

      List<ExperienceItem> items;

      if (isEvents) {
        print('🔍 PRELOAD EVENTS: Appel getEventsUseCaseProvider...');

        final events = await ref.read(getEventsUseCaseProvider).execute(
          latitude: city.lat,
          longitude: city.lon,
          sectionId: sectionId,
          categoryId: category.id,
          limit: limit,
        );

        print('🔍 PRELOAD EVENTS: Résultat = ${events.length} événements');

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
        print('🔍 PRELOAD ACTIVITIES: Appel getActivitiesUseCaseProvider...');

        final activities = await ref.read(getActivitiesUseCaseProvider).execute(
          latitude: city.lat,
          longitude: city.lon,
          sectionId: sectionId,
          categoryId: category.id,
          limit: limit,
        );

        print('🔍 PRELOAD ACTIVITIES: Résultat = ${activities.length} activités');

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

      // Collecter URLs d'images pour précache
      for (final item in items) {
        if (item.mainImageUrl?.isNotEmpty == true) {
          imageUrls.add(item.mainImageUrl!);
        }
      }

      print('✅ PRELOAD DATA: ${category.name} → ${items.length} items (limit: $limit)');
      return items;

    } catch (e) {
      print('❌ PRELOAD DATA: Erreur ${category.name}: $e');
      return [];
    }
  }

  /// Précharge les vraies données d'une CityPage selon plan différentiel
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

      // 2. Construire la liste des tâches à charger
      final jobs = <(String sectionId, Category cat, int limit)>[
        ('7f94df23-ab30-4bf3-afb2-59320e5466a7', eventCategory, 10),                 // événements
        ...activityCategories.map((c) => ('5aa09feb-397a-4ad1-8142-7dcf0b2edd0f', c, 10)),
      ];

      final carouselsInfo = <CarouselLoadInfo>[];
      final carouselData = <String, List<ExperienceItem>>{...state.carouselData}; // ✅ Conserver l'existant
      final imageUrls = <String>[...state.criticalImageUrls]; // ✅ Conserver l'existant

      // 3. Charger chaque carrousel et stocker immédiatement
      for (final (sectionId, category, limit) in jobs) {
        try {
          print('🔄 PRELOAD JOB: ${category.name} (${category.id}) avec limit=$limit');

          final items = await _loadCarouselData(city, category, sectionId, limit, imageUrls);
          final key = '${category.id}_$sectionId';

          // ✅ STOCKAGE IMMÉDIAT dans carouselData
          if (items.isNotEmpty) {
            carouselData[key] = items;

            carouselsInfo.add(CarouselLoadInfo(
              categoryId: category.id,
              sectionId: sectionId,
              title: category.name,
              loadedItems: items.length,
              isPartial: true, // Déclenche T1
              totalAvailable: 25,
            ));

            print('✅ PRELOAD STORED: "$key" → ${items.length} items');
          } else {
            print('⚠️ PRELOAD EMPTY: "$key" → 0 items');
          }

          // ✅ MISE À JOUR INCRÉMENTALE du state (pour injection immédiate si besoin)
          state = state.copyWith(
            carouselData: carouselData,
            criticalImageUrls: imageUrls,
          );

        } catch (e) {
          print('❌ PRELOAD JOB: Erreur ${category.name}: $e');
          // Continue avec les autres carrousels
        }
      }

      // 4. Mise à jour finale du state
      state = state.copyWith(
        criticalImageUrls: imageUrls,
        carouselsInfo: carouselsInfo,
        carouselData: carouselData, // ✅ Toutes les données collectées
      );

      print('✅ PRELOAD CITY: ${carouselsInfo.length} carrousels, ${carouselData.length} datasets, ${imageUrls.length} images');

    } catch (e) {
      print('❌ PRELOAD: Erreur _preloadCityPage: $e');
      rethrow;
    }
  }

  /// Précharge les métadonnées d'une CategoryPage (structure + images uniquement)
  Future<void> _preloadCategoryPage(City city) async {
    try {
      // 1. Récupérer la première catégorie
      final allCategories = await ref.read(categoriesProvider.future);
      if (allCategories.isEmpty) {
        throw Exception('Aucune catégorie disponible');
      }

      final firstCategory = allCategories.first;
      print('🔄 PRELOAD CATEGORY: Structure de ${firstCategory.name} pour ${city.cityName}');

      final carouselsInfo = <CarouselLoadInfo>[];
      final imageUrls = <String>[];

      // 2. ✅ NOUVEAU : Récupérer structure Featured (PAS les données)
      await _collectFeaturedStructure(city, firstCategory, carouselsInfo, imageUrls);

      // 3. ✅ NOUVEAU : Récupérer structure Subcategory (PAS les données)
      await _collectSubcategoryStructure(city, firstCategory, carouselsInfo, imageUrls);

      // 4. Mettre à jour le state
      state = state.copyWith(
        criticalImageUrls: imageUrls,
        carouselsInfo: carouselsInfo,
      );

      print('✅ PRELOAD CATEGORY: ${carouselsInfo.length} carrousels, ${imageUrls.length} images');

    } catch (e) {
      print('❌ PRELOAD CATEGORY: Erreur: $e');
      rethrow;
    }
  }

  /// Collecte la structure Featured sans charger les données d'expériences
  Future<void> _collectFeaturedStructure(
      City city,
      Category category,
      List<CarouselLoadInfo> carouselsInfo,
      List<String> imageUrls,
      ) async {
    try {
      // Récupérer les sections Featured (structure uniquement)
      final featuredSections = await ref.read(featuredSectionsByCategoryProvider(category.id).future);

      if (featuredSections != null) {
        for (final section in featuredSections) {
          // ✅ MÉTADONNÉES SEULEMENT (pas de vraies données)
          carouselsInfo.add(CarouselLoadInfo(
            categoryId: category.id,
            sectionId: section.id,
            title: section.title,
            loadedItems: 10,
            // Métadonnée : taille preload
            isPartial: true,
            // ✅ IMPORTANT : Déclenche T1 dans wrapper
            totalAvailable: 25, // Métadonnée : taille complète estimée
          ));


          print('📋 PRELOAD FEATURED STRUCTURE: ${section.title}');
        }
      }

    } catch (e) {
      print('❌ PRELOAD FEATURED STRUCTURE: Erreur: $e');
      // Ne pas faire rethrow pour ne pas bloquer le preload
    }
  }

  /// Collecte la structure Subcategory sans charger les données d'expériences
  Future<void> _collectSubcategoryStructure(
      City city,
      Category category,
      List<CarouselLoadInfo> carouselsInfo,
      List<String> imageUrls,
      ) async {
    try {
      // Récupérer les sections Subcategory (structure uniquement)
      final subcategorySections = await ref.read(effectiveSubcategorySectionsProvider(category.id).future);

      // Charger les 3 premières sections (comme avant)
      final sectionsToLoad = subcategorySections.take(3).toList();

      for (final section in sectionsToLoad) {
        // ✅ MÉTADONNÉES SEULEMENT (pas de vraies données)
        carouselsInfo.add(CarouselLoadInfo(
          categoryId: category.id,
          sectionId: section.id,
          title: section.title,
          loadedItems: 5, // Métadonnée : taille preload
          isPartial: true, // ✅ IMPORTANT : Déclenche T1 dans wrapper
          totalAvailable: 25, // Métadonnée : taille complète estimée
        ));

        print('📋 PRELOAD SUBCATEGORY STRUCTURE: ${section.title}');
      }

    } catch (e) {
      print('❌ PRELOAD SUBCATEGORY STRUCTURE: Erreur: $e');
      // Ne pas faire rethrow pour ne pas bloquer le preload
    }
  }

  /// Reset l'état
  void reset() {
    state = const PreloadData(state: PreloadState.idle);
  }
}