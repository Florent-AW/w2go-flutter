// lib/features/preload/application/all_data_preloader.dart

import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter/painting.dart';

import '../../../core/domain/models/shared/experience_item.dart';
import '../../../core/domain/models/shared/city_model.dart';
import '../../search/application/state/city_selection_state.dart';
import '../../categories/application/state/categories_provider.dart';
import '../../categories/application/state/subcategories_provider.dart';
import '../../search/application/state/activity_providers.dart';
import '../../search/application/state/event_providers.dart';

part 'all_data_preloader.g.dart';

class SectionIds {
  static const String featured = 'a62c6046-8814-456f-91ba-b65aa7e73137';
  static const String subcategory = '5aa09feb-397a-4ad1-8142-7dcf0b2edd0f';
  static const String citySection = '5aa09feb-397a-4ad1-8142-7dcf0b2edd0f';
}

@riverpod
class AllDataPreloader extends _$AllDataPreloader {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  @override
  Map<String, List<ExperienceItem>> build() {
    return {};
  }

  /// Charge exactement 3 items pour TOUS les carrousels (city + categories)
  /// Total: ~35 carrousels × 3 items = 105 items maximum
  Future<void> load3ItemsEverywhere(String cityId) async {
    if (_isLoading) {
      print('⚠️ PRELOAD: Déjà en cours, ignoré');
      return;
    }

    _isLoading = true;
    _clearMemoryCache();
    state = {};

    final startTime = DateTime.now();
    const timeout = Duration(seconds: 10);
    print('🚀 PRELOAD 3-ITEMS: Démarrage pour $cityId');

    try {
      final city = ref.read(selectedCityProvider);
      if (city == null) throw Exception('Aucune ville sélectionnée');

      final result = await Future.wait([
        _load3ItemsCityPage(city),
        _load3ItemsAllCategoryPages(city),
      ], eagerError: false).timeout(timeout);

      final Map<String, List<ExperienceItem>> allData = {};
      for (var data in result) {
        if (data != null) allData.addAll(data);
      }

      state = allData;
      final duration = DateTime.now().difference(startTime);
      print('✅ PRELOAD 3-ITEMS: ${allData.length} carrousels (${duration.inMilliseconds}ms)');

    } catch (e) {
      print('❌ PRELOAD 3-ITEMS: Timeout ou erreur $e');
      state = {...state};
    } finally {
      _isLoading = false;
    }
  }

  /// Charge CityPage : 1 carrousel × 7 catégories = 7 carrousels
  Future<Map<String, List<ExperienceItem>>?> _load3ItemsCityPage(City city) async {
    try {
      final categories = await ref.read(categoriesProvider.future);
      final Map<String, List<ExperienceItem>> cityData = {};

      final results = await Future.wait(
        categories.take(7).map((category) => _load3ItemsCityCarousel(city, category.id)),
        eagerError: false,
      );

      for (var data in results) {
        if (data != null) cityData.addAll(data);
      }

      print('✅ CityPage: ${cityData.length} carrousels');
      return cityData;
    } catch (e) {
      print('❌ CityPage: Erreur $e');
      return {};
    }
  }

  /// Charge CategoryPages : (1 Featured + 3 Subcategories) × 7 catégories = 28 carrousels
  Future<Map<String, List<ExperienceItem>>?> _load3ItemsAllCategoryPages(City city) async {
    try {
      final categories = await ref.read(categoriesProvider.future);
      final Map<String, List<ExperienceItem>> categoriesData = {};

      final results = await Future.wait(
        categories.take(7).map((category) => _load3ItemsCategoryPageCarousels(city, category.id)),
        eagerError: false,
      );

      for (var data in results) {
        if (data != null) categoriesData.addAll(data);
      }

      print('✅ CategoryPages: ${categoriesData.length} carrousels');
      return categoriesData;
    } catch (e) {
      print('❌ CategoryPages: Erreur $e');
      return {};
    }
  }

  /// Charge 1 carrousel CityPage pour une catégorie
  /// Clé: categoryId_sectionId
  Future<Map<String, List<ExperienceItem>>> _load3ItemsCityCarousel(
      City city,
      String categoryId
      ) async {
    try {
      final cityData = <String, List<ExperienceItem>>{};
      const eventsCatId = 'c3b42899-fdc3-48f7-bd85-09be3381aba9';
      final isEvents = categoryId == eventsCatId;

      if (isEvents) {
        final ev = await ref.read(getEventsUseCaseProvider).execute(
          latitude: city.lat,
          longitude: city.lon,
          sectionId: SectionIds.citySection,
          categoryId: categoryId,
          limit: 3,
        );
        if (ev.isNotEmpty) {
          final key = '${categoryId}_${SectionIds.citySection}';
          cityData[key] = ev.map(ExperienceItem.event).toList();
        }
      } else {
        final acts = await ref.read(getActivitiesUseCaseProvider).execute(
          latitude: city.lat,
          longitude: city.lon,
          sectionId: SectionIds.citySection,
          categoryId: categoryId,
          limit: 3,
        );
        if (acts.isNotEmpty) {
          final key = '${categoryId}_${SectionIds.citySection}';
          cityData[key] = acts.map(ExperienceItem.activity).toList();
        }
      }

      return cityData;
    } catch (e) {
      print('❌ CityCarousel $categoryId: Erreur ignorée $e');
      return {};
    }
  }

  /// Charge 4 carrousels CategoryPage pour une catégorie (1 Featured + 3 Subcategories)
  /// Clés: categoryId_featuredId, categoryId_subcategoryId_subId
  Future<Map<String, List<ExperienceItem>>> _load3ItemsCategoryPageCarousels(
      City city,
      String categoryId
      ) async {
    try {
      final Map<String, List<ExperienceItem>> categoryData = {};

      // 1. Featured carousel : 3 items
      final featuredData = await _load3ItemsCategoryFeatured(city, categoryId);
      if (featuredData.isNotEmpty) {
        final key = '${categoryId}_${SectionIds.featured}';
        categoryData[key] = featuredData;
      }

      // 2. Subcategories carousels : 3 items chacun, max 3 subcategories
      final subData = await _load3ItemsCategorySubcategories(city, categoryId);
      categoryData.addAll(subData);

      return categoryData;
    } catch (e) {
      print('❌ CategoryPage $categoryId: Erreur ignorée $e');
      return {};
    }
  }

  /// Charge Featured carousel pour une catégorie
  Future<List<ExperienceItem>> _load3ItemsCategoryFeatured(
      City city,
      String categoryId
      ) async {
    try {
      const eventsCatId = 'c3b42899-fdc3-48f7-bd85-09be3381aba9';
      final isEvents = categoryId == eventsCatId;

      if (isEvents) {
        final ev = await ref.read(getEventsUseCaseProvider).execute(
          latitude: city.lat,
          longitude: city.lon,
          sectionId: SectionIds.featured,
          categoryId: categoryId,
          limit: 3,
        );
        return ev.map(ExperienceItem.event).toList();
      } else {
        final acts = await ref.read(getActivitiesUseCaseProvider).execute(
          latitude: city.lat,
          longitude: city.lon,
          sectionId: SectionIds.featured,
          categoryId: categoryId,
          limit: 3,
        );
        return acts.map(ExperienceItem.activity).toList();
      }
    } catch (e) {
      print('❌ Featured $categoryId: Erreur ignorée $e');
      return [];
    }
  }

  /// Charge Subcategories carousels pour une catégorie (max 3 subcategories)
  Future<Map<String, List<ExperienceItem>>> _load3ItemsCategorySubcategories(
      City city,
      String categoryId
      ) async {
    try {
      final Map<String, List<ExperienceItem>> subData = {};
      final subs = await ref.read(subCategoriesForCategoryProvider(categoryId).future);

      for (var sub in subs.take(3)) {
        final acts = await ref.read(getActivitiesUseCaseProvider).execute(
          latitude: city.lat,
          longitude: city.lon,
          sectionId: SectionIds.subcategory,
          categoryId: categoryId,
          subcategoryId: sub.id,
          limit: 3,
        );

        if (acts.isNotEmpty) {
          final key = '${categoryId}_${SectionIds.subcategory}_${sub.id}';
          subData[key] = acts.map(ExperienceItem.activity).toList();
        }
      }
      return subData;
    } catch (e) {
      print('❌ Subcategories $categoryId: Erreur ignorée $e');
      return {};
    }
  }

  /// Purge le cache mémoire des images
  void _clearMemoryCache() {
    try {
      PaintingBinding.instance.imageCache.clear();
      print('🧹 PRELOAD: Cache mémoire purgé');
    } catch (e) {
      print('⚠️ PRELOAD: Erreur purge cache: $e');
    }
  }
}