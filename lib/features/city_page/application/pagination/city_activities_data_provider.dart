// lib/features/city_page/application/pagination/city_activities_data_provider.dart

import '../../../../core/domain/pagination/paginated_data_provider.dart';
import '../../../../core/domain/pagination/paginated_result.dart';
import '../../../../core/domain/models/shared/experience_item.dart';
import '../../../../core/domain/models/shared/city_model.dart';
import '../../../search/application/state/activity_providers.dart';
import '../../../search/application/state/event_providers.dart';
import '../../../../core/domain/ports/providers/search/activity_distance_manager_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provider paginé pour les activités d'une ville
class CityActivitiesDataProvider extends ExperienceDataProvider {
  final Ref _ref;
  final City _city;
  final String _sectionId;
  final String? _categoryId;

  CityActivitiesDataProvider({
    required Ref ref,
    required City city,
    required String sectionId,
    String? categoryId,
  }) : _ref = ref,
        _city = city,
        _sectionId = sectionId,
        _categoryId = categoryId;

  @override
  String get providerId => 'city_activities_${_city.id}_${_sectionId}_${_categoryId ?? 'all'}';

  @override
  int get defaultPageSize => 20;

  @override
  int get preloadPageSize => _categoryId == 'c3b42899-fdc3-48f7-bd85-09be3381aba9' ? 10 : 5; // Events: 10, Activities: 5

  @override
  double get latitude => _city.lat;

  @override
  double get longitude => _city.lon;

  @override
  String get sectionId => _sectionId;

  @override
  String? get categoryId => _categoryId;

  @override
  String? get subcategoryId => null;
  @override
  Future<PaginatedResult<ExperienceItem>> loadPage({
    required int offset,
    required int limit,
    Map<String, dynamic>? filters,
  }) async {
    try {
      // ✅ AJOUT : Log pour debug
      print('🗂️ PROVIDER $providerId: offset=$offset limit=$limit');

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

      // ✅ NOUVEAU : Logger les IDs retournés par la RPC
      final itemIds = items.map((item) => item.id).toList();
      print('🗂️ PROVIDER $providerId: IDs retournés = ${itemIds.join(", ")}');

      // ✅ Calculer les valeurs (une seule fois)
      final nextOffset = offset + items.length;
      final hasMore = items.length == limit;

      // ✅ AJOUT : Log pour vérifier
      print('🗂️ PROVIDER $providerId: → returned=${items.length} nextOffset=$nextOffset hasMore=$hasMore');

      return PaginatedResult(
        items: items,
        hasMore: hasMore,
        nextOffset: nextOffset,
      );

    } catch (e) {
      print('❌ CITY PAGINATION: Erreur $providerId: $e');
      rethrow;
    }
  }
}