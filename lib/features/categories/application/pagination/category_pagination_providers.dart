// lib/features/categories/application/pagination/category_pagination_providers.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../preload/application/pagination_controller.dart';
import '../../../../core/domain/pagination/paginated_data_provider.dart';
import '../../../../core/domain/pagination/paginated_result.dart';
import '../../../../core/domain/models/shared/experience_item.dart';
import '../../../../core/domain/models/shared/city_model.dart';
import '../../../search/application/state/activity_providers.dart';
import '../../../search/application/state/event_providers.dart';
import '../../../../core/domain/ports/providers/search/activity_distance_manager_providers.dart';

/// Paramètres pour identifier un carrousel CategoryPage de façon unique
class CategoryCarouselParams {
  final City city;
  final String sectionId;
  final String categoryId;
  final String? subcategoryId; // null pour Featured, non-null pour Subcategory

  const CategoryCarouselParams({
    required this.city,
    required this.sectionId,
    required this.categoryId,
    this.subcategoryId,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is CategoryCarouselParams &&
              runtimeType == other.runtimeType &&
              city.id == other.city.id &&
              sectionId == other.sectionId &&
              categoryId == other.categoryId &&
              subcategoryId == other.subcategoryId;

  @override
  int get hashCode =>
      city.id.hashCode ^
      sectionId.hashCode ^
      categoryId.hashCode ^
      (subcategoryId?.hashCode ?? 0);

  @override
  String toString() {
    return 'CategoryCarouselParams(city: ${city.cityName}, section: $sectionId, category: $categoryId, subcategory: $subcategoryId)';
  }
}

/// Data provider pour carrousels Featured (Activities + Events)
class CategoryFeaturedDataProvider extends ExperienceDataProvider {
  final Ref _ref;
  final City _city;
  final String _sectionId;
  final String _categoryId;

  CategoryFeaturedDataProvider({
    required Ref ref,
    required City city,
    required String sectionId,
    required String categoryId,
  }) : _ref = ref,
        _city = city,
        _sectionId = sectionId,
        _categoryId = categoryId;

  @override
  String get providerId => 'category_featured_${_city.id}_${_sectionId}_${_categoryId}';

  @override
  int get defaultPageSize => 25;

  @override
  int get preloadPageSize => 10; // Featured : toujours 10 items en preload

  @override
  double get latitude => _city.lat;

  @override
  double get longitude => _city.lon;

  @override
  String get sectionId => _sectionId;

  @override
  String? get categoryId => _categoryId;

  @override
  String? get subcategoryId => null; // Featured n'a pas de subcategoryId

  @override
  Future<PaginatedResult<ExperienceItem>> loadPage({
    required int offset,
    required int limit,
    Map<String, dynamic>? filters,
  }) async {
    try {
      print('🗂️ CATEGORY FEATURED $providerId: offset=$offset limit=$limit');

      const String eventsCategoryId = 'c3b42899-fdc3-48f7-bd85-09be3381aba9';
      final isEvents = _categoryId == eventsCategoryId;

      List<ExperienceItem> items;

      if (isEvents) {
        final events = await _ref.read(getEventsUseCaseProvider).execute(
          latitude: latitude,
          longitude: longitude,
          sectionId: sectionId,
          categoryId: categoryId!,
          limit: limit,
          offset: offset,
        );

        if (events.isNotEmpty) {
          _ref.read(activityDistancesProvider.notifier).cacheActivitiesDistances(
            events.map((event) => (
            id: event.base.id,
            lat: event.base.latitude,
            lon: event.base.longitude,
            )).toList(),
          );
        }

        items = events.map((event) => ExperienceItem.event(event)).toList();
      } else {
        final activities = await _ref.read(getActivitiesUseCaseProvider).execute(
          latitude: latitude,
          longitude: longitude,
          sectionId: sectionId,
          categoryId: categoryId,
          limit: limit,
          offset: offset,
        );

        if (activities.isNotEmpty) {
          _ref.read(activityDistancesProvider.notifier).cacheActivitiesDistances(
            activities.map((activity) => (
            id: activity.base.id,
            lat: activity.base.latitude,
            lon: activity.base.longitude,
            )).toList(),
          );
        }

        items = activities.map((activity) => ExperienceItem.activity(activity)).toList();
      }

      final nextOffset = offset + items.length;
      final hasMore = items.length == limit;

      print('🗂️ CATEGORY FEATURED $providerId: → returned=${items.length} nextOffset=$nextOffset hasMore=$hasMore');

      return PaginatedResult(
        items: items,
        hasMore: hasMore,
        nextOffset: nextOffset,
      );

    } catch (e) {
      print('❌ CATEGORY FEATURED: Erreur $providerId: $e');
      rethrow;
    }
  }
}

/// Data provider pour carrousels Subcategory (Activities uniquement)
class CategorySubcategoryDataProvider extends ExperienceDataProvider {
  final Ref _ref;
  final City _city;
  final String _sectionId;
  final String _categoryId;
  final String _subcategoryId;

  CategorySubcategoryDataProvider({
    required Ref ref,
    required City city,
    required String sectionId,
    required String categoryId,
    required String subcategoryId,
  }) : _ref = ref,
        _city = city,
        _sectionId = sectionId,
        _categoryId = categoryId,
        _subcategoryId = subcategoryId;

  @override
  String get providerId => 'category_subcategory_${_city.id}_${_sectionId}_${_categoryId}_${_subcategoryId}';

  @override
  int get defaultPageSize => 25;

  @override
  int get preloadPageSize => 5; // Subcategory : 5 items en preload

  @override
  double get latitude => _city.lat;

  @override
  double get longitude => _city.lon;

  @override
  String get sectionId => _sectionId;

  @override
  String? get categoryId => _categoryId;

  @override
  String? get subcategoryId => _subcategoryId;

  @override
  Future<PaginatedResult<ExperienceItem>> loadPage({
    required int offset,
    required int limit,
    Map<String, dynamic>? filters,
  }) async {
    try {
      print('🗂️ CATEGORY SUBCATEGORY $providerId: offset=$offset limit=$limit');

      // Subcategory ne gère que les activités (pas d'événements)
      final activities = await _ref.read(getActivitiesUseCaseProvider).execute(
        latitude: latitude,
        longitude: longitude,
        sectionId: sectionId,
        categoryId: categoryId,
        subcategoryId: subcategoryId, // Filtre par sous-catégorie
        limit: limit,
        offset: offset,
      );

      if (activities.isNotEmpty) {
        _ref.read(activityDistancesProvider.notifier).cacheActivitiesDistances(
          activities.map((activity) => (
          id: activity.base.id,
          lat: activity.base.latitude,
          lon: activity.base.longitude,
          )).toList(),
        );
      }

      final items = activities.map((activity) => ExperienceItem.activity(activity)).toList();
      final nextOffset = offset + items.length;
      final hasMore = items.length == limit;

      print('🗂️ CATEGORY SUBCATEGORY $providerId: → returned=${items.length} nextOffset=$nextOffset hasMore=$hasMore');

      return PaginatedResult(
        items: items,
        hasMore: hasMore,
        nextOffset: nextOffset,
      );

    } catch (e) {
      print('❌ CATEGORY SUBCATEGORY: Erreur $providerId: $e');
      rethrow;
    }
  }
}

/// Provider de PaginationController pour carrousels Featured
final categoryFeaturedPaginationProvider = StateNotifierProvider.family<
    PaginationController<ExperienceItem>,
    PaginationState<ExperienceItem>,
    CategoryCarouselParams
>((ref, params) {
  print('🎯 PAGINATION CONTROLLER FEATURED: ${params.toString()}');

  final dataProvider = CategoryFeaturedDataProvider(
    ref: ref,
    city: params.city,
    sectionId: params.sectionId,
    categoryId: params.categoryId,
  );

  return PaginationController<ExperienceItem>(dataProvider);
});

/// Provider de PaginationController pour carrousels Subcategory
final categorySubcategoryPaginationProvider = StateNotifierProvider.family<
    PaginationController<ExperienceItem>,
    PaginationState<ExperienceItem>,
    CategoryCarouselParams
>((ref, params) {
  print('🎯 PAGINATION CONTROLLER SUBCATEGORY: ${params.toString()}');

  // Vérifier que subcategoryId est défini pour les carrousels Subcategory
  if (params.subcategoryId == null) {
    throw ArgumentError('subcategoryId ne peut pas être null pour CategorySubcategoryDataProvider');
  }

  final dataProvider = CategorySubcategoryDataProvider(
    ref: ref,
    city: params.city,
    sectionId: params.sectionId,
    categoryId: params.categoryId,
    subcategoryId: params.subcategoryId!,
  );

  return PaginationController<ExperienceItem>(dataProvider);
});

/// Helper pour créer les paramètres Featured
CategoryCarouselParams createFeaturedParams({
  required City city,
  required String sectionId,
  required String categoryId,
}) {
  return CategoryCarouselParams(
    city: city,
    sectionId: sectionId,
    categoryId: categoryId,
    subcategoryId: null, // Featured n'a pas de subcategoryId
  );
}

/// Helper pour créer les paramètres Subcategory
CategoryCarouselParams createSubcategoryParams({
  required City city,
  required String sectionId,
  required String categoryId,
  required String subcategoryId,
}) {
  return CategoryCarouselParams(
    city: city,
    sectionId: sectionId,
    categoryId: categoryId,
    subcategoryId: subcategoryId,
  );
}