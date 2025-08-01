// lib/core/application/all_data_preloader.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter/painting.dart';
import '../domain/models/shared/experience_item.dart';
import '../domain/models/shared/city_model.dart';
import '../../features/city_page/application/providers/city_experiences_controller.dart';
import '../../features/search/application/state/city_selection_state.dart';
import '../../features/categories/application/state/categories_provider.dart';
import '../../features/categories/application/state/subcategories_provider.dart';
import '../../features/search/application/state/activity_providers.dart';
import '../../features/search/application/state/event_providers.dart';

part 'all_data_preloader.g.dart';

/// IDs de sections constants pour éviter les magic strings
class SectionIds {
  static const String featured = 'a62c6046-8814-456f-91ba-b65aa7e73137';
  static const String subcategory = '5aa09feb-397a-4ad1-8142-7dcf0b2edd0f';
  static const String cityEventsSection = '7f94df23-ab30-4bf3-afb2-59320e5466a7';
  static const String cityActivitiesSection = '5aa09feb-397a-4ad1-8142-7dcf0b2edd0f';
}

@riverpod
class AllDataPreloader extends _$AllDataPreloader {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  @override
  Map<String, List<ExperienceItem>> build() => {};

  /// One Shot Loading COMPLET avec protection contre double déclenchement
  Future<void> loadCompleteCity(String cityId) async {
    // ✅ Protection contre double déclenchement
    if (_isLoading) {
      print('⚠️ PRELOAD: Déjà en cours, ignoré');
      return;
    }

    _isLoading = true;
    // ✅ Purge mémoire avant nouveau chargement
    _clearMemoryCache();
    state = {}; // reset précédent
    print('🚀 PRELOAD ONE SHOT COMPLET: Démarrage pour $cityId');

    try {
      final city = ref.read(selectedCityProvider);
      if (city == null) throw Exception('Aucune ville sélectionnée');

      // ✅ CHARGEMENT PARALLÈLE : CityPage + toutes les catégories
      final results = await Future.wait([
        _loadCityPageData(cityId),
        _loadAllCategoriesData(city),
      ], eagerError: false);

      // ✅ FUSION des données
      final Map<String, List<ExperienceItem>> allData = {};
      allData.addAll(results[0] ?? {});
      allData.addAll(results[1] ?? {});

      state = allData;
      print('✅ PRELOAD ONE SHOT COMPLET: ${allData.length} carousels chargés');

    } catch (e) {
      print('❌ PRELOAD ONE SHOT COMPLET: Erreur $e');
      state = {};
    } finally {
      _isLoading = false;
    }
  }

  void _clearMemoryCache() {
    try {
      PaintingBinding.instance.imageCache.clear();
      print('🧹 PRELOAD: Cache mémoire purgé');
    } catch (e) {
      print('⚠️ PRELOAD: Erreur purge cache: $e');
    }
  }

  Future<Map<String, List<ExperienceItem>>?> _loadCityPageData(String cityId) async {
    try {
      final cityExperiences = await ref.read(cityExperiencesControllerProvider(cityId).future);
      final Map<String, List<ExperienceItem>> cityData = {};

      for (final categoryExp in cityExperiences) {
        for (final sectionExp in categoryExp.sections) {
          // ✅ Clé normalisée : categoryId_sectionId
          final key = '${categoryExp.category.id}_${sectionExp.section.id}';
          cityData[key] = sectionExp.experiences;
        }
      }

      print('✅ CityPage: ${cityData.length} carousels chargés');
      return cityData;

    } catch (e) {
      print('❌ CityPage: Erreur $e');
      return {};
    }
  }

  Future<Map<String, List<ExperienceItem>>?> _loadAllCategoriesData(City city) async {
    try {
      // ✅ Récupérer toutes les catégories disponibles
      final categories = await ref.read(categoriesProvider.future);
      final Map<String, List<ExperienceItem>> categoriesData = {};

      // ✅ CHARGEMENT PARALLÈLE : Featured pour chaque catégorie
      final categoryResults = await Future.wait(
        categories.map((category) => _loadSingleCategoryData(city, category.id)),
        eagerError: false,
      );

      // ✅ FUSION des résultats de chaque catégorie
      for (int i = 0; i < categories.length; i++) {
        final categoryData = categoryResults[i];
        if (categoryData != null) {
          categoriesData.addAll(categoryData);
        }
      }

      print('✅ Catégories: ${categoriesData.length} carousels chargés pour ${categories.length} catégories');
      return categoriesData;

    } catch (e) {
      print('❌ Catégories: Erreur globale $e');
      return {};
    }
  }

  Future<Map<String, List<ExperienceItem>>?> _loadSingleCategoryData(City city, String categoryId) async {
    try {
      final Map<String, List<ExperienceItem>> categoryData = {};

      // ✅ 1. Charger Featured avec clé normalisée
      final featuredData = await _loadCategoryFeatured(city, categoryId);
      if (featuredData.isNotEmpty) {
        final featuredKey = '${categoryId}_${SectionIds.featured}';
        categoryData[featuredKey] = featuredData;
      }

      // ✅ 2. Charger première subcategory avec clé normalisée incluant subcategoryId
      final subcategoryData = await _loadCategorySubcategory(city, categoryId);
      if (subcategoryData.isNotEmpty) {
        categoryData.addAll(subcategoryData); // subcategoryData contient déjà les bonnes clés
      }

      print('✅ Catégorie $categoryId: ${categoryData.length} carousels chargés');
      return categoryData;

    } catch (e) {
      print('❌ Catégorie $categoryId: Erreur $e');
      return {};
    }
  }

  Future<List<ExperienceItem>> _loadCategoryFeatured(City city, String categoryId) async {
    try {
      const String eventsCategoryId = 'c3b42899-fdc3-48f7-bd85-09be3381aba9';
      final isEvents = categoryId == eventsCategoryId;

      if (isEvents) {
        // ✅ Événements Featured
        final events = await ref.read(getEventsUseCaseProvider).execute(
          latitude: city.lat,
          longitude: city.lon,
          sectionId: SectionIds.featured,
          categoryId: categoryId,
          limit: 8, // Preload optimisé
        );

        return events.map((event) => ExperienceItem.event(event)).toList();
      } else {
        // ✅ Activités Featured
        final activities = await ref.read(getActivitiesUseCaseProvider).execute(
          latitude: city.lat,
          longitude: city.lon,
          sectionId: SectionIds.featured,
          categoryId: categoryId,
          limit: 8, // Preload optimisé
        );

        return activities.map((activity) => ExperienceItem.activity(activity)).toList();
      }

    } catch (e) {
      print('❌ Featured $categoryId: Erreur $e');
      return [];
    }
  }

  Future<Map<String, List<ExperienceItem>>> _loadCategorySubcategory(City city, String categoryId) async {
    try {
      final Map<String, List<ExperienceItem>> subcategoryData = {};

      // ✅ Récupérer les 3 premières subcategories disponibles
      final subcategories = await ref.read(subCategoriesForCategoryProvider(categoryId).future);
      final subcategoriesToLoad = subcategories.take(3).toList();

      if (subcategoriesToLoad.isEmpty) {
        return subcategoryData;
      }

      // ✅ Charger chaque subcategory avec clé unique
      for (final subcategory in subcategoriesToLoad) {
        final activities = await ref.read(getActivitiesUseCaseProvider).execute(
          latitude: city.lat,
          longitude: city.lon,
          sectionId: SectionIds.subcategory,
          categoryId: categoryId,
          subcategoryId: subcategory.id,
          limit: 5, // Preload optimisé
        );

        if (activities.isNotEmpty) {
          // ✅ Clé unique avec subcategoryId pour éviter les écrasements
          final subcategoryKey = '${categoryId}_${SectionIds.subcategory}_${subcategory.id}';
          subcategoryData[subcategoryKey] = activities.map((activity) => ExperienceItem.activity(activity)).toList();
        }
      }

      return subcategoryData;

    } catch (e) {
      print('❌ Subcategory $categoryId: Erreur $e');
      return {};
    }
  }
}
