//lib/features/city_page/application/pagination/city_pagination_providers.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/application/pagination_controller.dart';
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

/// Provider pour la pagination des activités d’une ville.
final cityActivitiesPaginationProvider =
StateNotifierProvider.family.autoDispose<
    PaginationController<ExperienceItem>,   // Notifier
    PaginationState<ExperienceItem>,        // State
    CityCarouselParams                      // Paramètre
>(
      (ref, params) {
    // Data-provider spécifique (ville + catégorie + section)
    final dataProvider = CityActivitiesDataProvider(
      ref: ref,
      city: params.city,
      sectionId: params.sectionId,
      categoryId: params.categoryId,
    );

    // 🔄 Invalidation automatique quand la ville change
    ref.listen(selectedCityProvider, (previous, next) {
      if (previous?.id != next?.id) {
        print(
          '🔄 CITY CHANGE: Invalidation pagination pour ${next?.cityName}',
        );
        // Grâce à .autoDispose, le controller sera libéré
        // et recréé avec la nouvelle ville au prochain watch().
      }
    });

    return PaginationController<ExperienceItem>(dataProvider);
  },
);


