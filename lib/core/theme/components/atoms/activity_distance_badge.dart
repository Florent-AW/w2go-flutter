// lib/core/theme/components/atoms/activity_distance_badge.dart

import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../app_colors.dart';
import '../../app_typography.dart';
import '../../app_dimensions.dart';
import '../../../common/utils/distance_formatter.dart';
import '../../../domain/ports/providers/search/activity_distance_manager_providers.dart';

/// Badge de distance pour une activité
///
/// Atom dumb qui affiche la distance formatée avec code couleur :
/// - < 5km : Vert (Colors.green.shade600)
/// - >= 5km : Gris (Colors.grey.shade600)
///
/// Utilise le système existant activityDistancesProvider (comme FeaturedActivitiesCarousel)
class ActivityDistanceBadge extends ConsumerWidget {
  final String activityId;
  final double? fallbackDistance;

  const ActivityDistanceBadge({
    Key? key,
    required this.activityId,
    this.fallbackDistance,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allDistances = ref.watch(activityDistancesProvider);
    final distance = allDistances[activityId] ?? fallbackDistance;

    if (distance == null) {
      return const SizedBox.shrink();
    }

    final distanceText = DistanceFormatter.formatDistanceLabel(distance);
    final distanceColor = _getDistanceColor(distance);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          LucideIcons.milestone,
          size: AppDimensions.iconSizeS,
          color: distanceColor,
        ),
        SizedBox(width: AppDimensions.spacingXxxs),
        Text(
          distanceText,
          style: AppTypography.caption(
            isDark: isDark,
          ).copyWith(
            color: distanceColor,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  /// Détermine la couleur selon la distance
  ///
  /// Logique métier :
  /// - < 5km : Vert (proximité)
  /// - >= 5km : Couleur de texte normale de l'app
  Color _getDistanceColor(double distanceInMeters) {
    final distanceKm = distanceInMeters / 1000;

    if (distanceKm < 5) {
      return Colors.green; // Proche
    } else {
      return AppColors.primary; // Couleur de texte normale
    }
  }
}