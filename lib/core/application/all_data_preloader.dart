// lib/core/application/all_data_preloader.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../domain/models/shared/experience_item.dart';
import '../domain/models/shared/city_model.dart';
import '../../features/city_page/application/providers/city_experiences_controller.dart';
import '../../features/search/application/state/city_selection_state.dart';
import '../../features/categories/application/state/categories_provider.dart';
import '../../features/categories/application/state/subcategories_provider.dart';
import '../../features/search/application/state/activity_providers.dart';
import '../../features/search/application/state/event_providers.dart';

part 'all_data_preloader.g.dart';


@riverpod
class AllDataPreloader extends _$AllDataPreloader {
  @override
  Map<String, List<ExperienceItem>> build() => {};

  /// One Shot Loading COMPLET : Charge CityPage + TOUTES les catégories
  Future<void> loadCompleteCity(String cityId) async {
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
    }
  }

  Future<Map<String, List<ExperienceItem>>?> _loadCityPageData(String cityId) async {
    try {
      final cityExperiences = await ref.read(cityExperiencesControllerProvider(cityId).future);

      final Map<String, List<ExperienceItem>> cityData = {};
      for (final categoryExp in cityExperiences) {
        for (final sectionExp in categoryExp.sections) {
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

      // ✅ 1. Charger Featured avec use case direct
      final featuredData = await _loadCategoryFeatured(city, categoryId);
      if (featuredData.isNotEmpty) {
        categoryData['${categoryId}_featured'] = featuredData;
      }

      // ✅ 2. Charger première subcategory avec use case direct
      final subcategoryData = await _loadCategorySubcategory(city, categoryId);
      if (subcategoryData.isNotEmpty) {
        categoryData['${categoryId}_subcategory'] = subcategoryData;
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
      const String featuredSectionId = 'a62c6046-8814-456f-91ba-b65aa7e73137';
      final isEvents = categoryId == eventsCategoryId;

      if (isEvents) {
        // ✅ Événements Featured
        final events = await ref.read(getEventsUseCaseProvider).execute(
          latitude: city.lat,
          longitude: city.lon,
          sectionId: featuredSectionId,
          categoryId: categoryId,
          limit: 8, // Preload optimisé
        );

        return events.map((event) => ExperienceItem.event(event)).toList();
      } else {
        // ✅ Activités Featured
        final activities = await ref.read(getActivitiesUseCaseProvider).execute(
          latitude: city.lat,
          longitude: city.lon,
          sectionId: featuredSectionId,
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

  Future<List<ExperienceItem>> _loadCategorySubcategory(City city, String categoryId) async {
    try {
      // ✅ Récupérer première subcategory disponible
      final subcategories = await ref.read(subCategoriesForCategoryProvider(categoryId).future);

      if (subcategories.isEmpty) {
        return [];
      }

      final firstSubcategory = subcategories.first;
      const String subcategorySectionId = '5aa09feb-397a-4ad1-8142-7dcf0b2edd0f';

      // ✅ Charger activités de la première subcategory
      final activities = await ref.read(getActivitiesUseCaseProvider).execute(
        latitude: city.lat,
        longitude: city.lon,
        sectionId: subcategorySectionId,
        categoryId: categoryId,
        subcategoryId: firstSubcategory.id,
        limit: 5, // Preload optimisé
      );

      return activities.map((activity) => ExperienceItem.activity(activity)).toList();

    } catch (e) {
      print('❌ Subcategory $categoryId: Erreur $e');
      return [];
    }
  }


}
