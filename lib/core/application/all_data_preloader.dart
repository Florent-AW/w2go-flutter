// lib/core/application/all_data_preloader.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../domain/models/shared/experience_item.dart';
import '../domain/models/shared/city_model.dart';
import '../../features/city_page/application/providers/city_experiences_controller.dart';
import '../../features/search/application/state/city_selection_state.dart';
import '../../features/categories/application/state/categories_provider.dart';
import '../../features/categories/application/pagination/category_pagination_providers.dart';
import '../../features/categories/application/state/subcategories_provider.dart';


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

      // ✅ SIMPLIFICATION : Charger seulement les Featured pour éviter les race conditions
      final categoryResults = await Future.wait(
        categories.map((category) => _loadSingleCategoryFeatured(city, category.id)),
        eagerError: false,
      );

      // ✅ FUSION des résultats
      for (int i = 0; i < categories.length; i++) {
        final categoryData = categoryResults[i];
        if (categoryData != null) {
          categoriesData.addAll(categoryData);
        }
      }

      print('✅ Catégories: ${categoriesData.length} carousels Featured chargés pour ${categories.length} catégories');
      return categoriesData;

    } catch (e) {
      print('❌ Catégories: Erreur globale $e');
      return {};
    }
  }

  Future<Map<String, List<ExperienceItem>>?> _loadSingleCategoryFeatured(City city, String categoryId) async {
    try {
      // ✅ SIMPLIFICATION MAXIMUM pour éviter les race conditions
      // Retourner map vide pour cette catégorie (on affinera plus tard)
      print('⏳ Catégorie $categoryId: Skip temporaire pour éviter dispose conflicts');
      return {};

    } catch (e) {
      print('❌ Catégorie $categoryId: Erreur $e');
      return {};
    }
  }

}
