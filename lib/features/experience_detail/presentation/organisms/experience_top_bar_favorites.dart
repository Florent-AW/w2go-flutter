// features/experience_detail/presentation/organisms/experience_top_bar_favorites.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import '../../../../core/domain/ports/providers/repositories/repository_providers.dart';
import '../../../../core/domain/models/shared/experience_item.dart';
import '../../../../core/theme/components/atoms/circle_favorite_button.dart';
import '../../../../core/theme/app_colors.dart';

class ExperienceTopBarFavorites extends ConsumerWidget {
  final ExperienceItem experienceItem;
  final VoidCallback? onToggled;
  const ExperienceTopBarFavorites({super.key, required this.experienceItem, this.onToggled});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final itemType = experienceItem.isEvent ? 'event' : 'activity';
    final itemId = experienceItem.id;
    final repo = ref.watch(favoritesRepositoryProvider);
    return StreamBuilder<bool>(
      stream: repo.isFavorite(itemType: itemType, itemId: itemId),
      initialData: false,
      builder: (context, snapshot) {
        final isFav = snapshot.data ?? false;
        if (snapshot.connectionState == ConnectionState.waiting && !snapshot.hasData) {
          return const SizedBox.shrink();
        }
        return CircleFavoriteButton(
          isFavorite: isFav,
          onPressed: () async {
            await repo.toggleFavorite(
              itemType: itemType,
              itemId: itemId,
              title: experienceItem.name,
              imageUrl: experienceItem.mainImageUrl,
              cityName: experienceItem.city,
              categoryName: experienceItem.categoryName,
              eventStart: experienceItem.startDate,
            );
            onToggled?.call();
          },
          backgroundColor: Colors.white,
          iconColor: AppColors.primary,
          size: 36,
          iconSize: 20,
        );
      },
    );
  }
}
