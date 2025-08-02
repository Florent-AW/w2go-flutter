//lib/features/city_page/application/pagination/city_pagination_providers.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../preload/application/pagination_controller.dart';
import '../../../../core/domain/models/shared/experience_item.dart';
import '../../../../core/domain/models/shared/city_model.dart';
import '../../../search/application/state/city_selection_state.dart';
import 'city_activities_data_provider.dart';

/// Paramètres pour identifier un carrousel de pagination
class CityCarouselParams {
  final City city;
  final String sectionId;
  final String? categoryId;

  const CityCarouselParams({
    required this.city,
    required this.sectionId,
    this.categoryId,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is CityCarouselParams &&
              runtimeType == other.runtimeType &&
              city.id == other.city.id &&
              sectionId == other.sectionId &&
              categoryId == other.categoryId;

  @override
  int get hashCode =>
      city.id.hashCode ^ sectionId.hashCode ^ (categoryId?.hashCode ?? 0);

  //  String representation pour debug
  @override
  String toString() => 'CityCarouselParams(city: ${city.cityName}, section: $sectionId, category: $categoryId)';
}

/// Provider pour la pagination des activités d'une ville.
final cityActivitiesPaginationProvider =
StateNotifierProvider.family<  // ✅ RETIRER .autoDispose
    PaginationController<ExperienceItem>,
    PaginationState<ExperienceItem>,
    CityCarouselParams
>(
      (ref, params) {
    // ✅ CORRECTION : Aligner section événements avec preload
    const eventsCategoryId = 'c3b42899-fdc3-48f7-bd85-09be3381aba9';
    const eventsSectionId = '7f94df23-ab30-4bf3-afb2-59320e5466a7';

    final realSectionId = params.categoryId == eventsCategoryId
        ? eventsSectionId  // ✅ Forcer section événements = preload
        : params.sectionId; // Garder section normale pour activités

    print('🔧 SECTION ALIGNMENT: ${params.categoryId == eventsCategoryId ? "EVENTS" : "ACTIVITY"} → $realSectionId');

    final dataProvider = CityActivitiesDataProvider(
      ref: ref,
      city: params.city,
      sectionId: realSectionId, // ✅ Clé alignée preload
      categoryId: params.categoryId,
    );

    ref.listen(selectedCityProvider, (previous, next) {
      if (previous?.id != next?.id) {
        print('🔄 CITY CHANGE: Invalidation pagination pour ${next?.cityName}');
        ref.invalidateSelf();
      }
    });

    return PaginationController<ExperienceItem>(dataProvider);
  },
);


