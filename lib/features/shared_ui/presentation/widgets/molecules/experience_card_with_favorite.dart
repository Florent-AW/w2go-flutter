// features/shared_ui/presentation/widgets/molecules/experience_card_with_favorite.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/domain/models/shared/experience_item.dart';
import '../../../../../core/domain/ports/providers/repositories/repository_providers.dart';
import 'featured_experience_card.dart';

class ExperienceCardWithFavorite extends ConsumerWidget {
  final ExperienceItem experience;
  final String heroTag;
  final double? width;
  final double? overrideDistance; // meters (fallback for badge)
  final bool showDistance;
  final bool showSubcategory;
  final VoidCallback? onTap;

  const ExperienceCardWithFavorite({
    super.key,
    required this.experience,
    required this.heroTag,
    this.width,
    this.overrideDistance,
    this.showDistance = true,
    this.showSubcategory = true,
    this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repo = ref.watch(favoritesRepositoryProvider);
    final itemType = experience.isEvent ? 'event' : 'activity';
    final itemId = experience.id;

    return StreamBuilder<bool>(
      stream: repo.isFavorite(itemType: itemType, itemId: itemId),
      initialData: false,
      builder: (context, snapshot) {
        final isFav = snapshot.data ?? false;
        return FeaturedExperienceCard(
          experience: experience,
          heroTag: heroTag,
          width: width,
          overrideDistance: overrideDistance,
          showDistance: showDistance,
          isFavorite: isFav,
          showSubcategory: showSubcategory,
          onFavoritePress: () async {
            await repo.toggleFavorite(
              itemType: itemType,
              itemId: itemId,
              title: experience.name,
              imageUrl: experience.mainImageUrl,
              cityName: experience.city,
              categoryName: experience.categoryName,
              eventStart: experience.startDate,
            );
          },
          onTap: onTap,
        );
      },
    );
  }
}
