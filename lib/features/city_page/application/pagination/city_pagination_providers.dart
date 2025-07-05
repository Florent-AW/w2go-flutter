//lib/features/city_page/application/pagination/city_pagination_providers.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/application/pagination_controller.dart';
import '../../../../core/domain/models/shared/experience_item.dart';
import '../../../../core/domain/models/shared/city_model.dart';
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
}

/// Provider pour un controller de pagination city activities
final cityActivitiesPaginationProvider =
StateNotifierProvider.family<
    PaginationController<ExperienceItem>,
    PaginationState<ExperienceItem>,
    CityCarouselParams>(
      (ref, params) {
    final dataProvider = CityActivitiesDataProvider(
      ref: ref,
      city: params.city,
      sectionId: params.sectionId,
      categoryId: params.categoryId,
    );

    return PaginationController<ExperienceItem>(dataProvider);
      },
);