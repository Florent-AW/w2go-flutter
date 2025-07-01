// lib/core/theme/components/atoms/activity_distance_badge.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../app_colors.dart';
import '../../app_typography.dart';
import '../../app_dimensions.dart';
import '../../../common/utils/distance_formatter.dart';
import '../../../domain/ports/providers/search/activity_distance_manager_providers.dart';

/// Badge de distance en forme de panneau de direction
/// Atom avec forme rectangulaire + pointe droite (comme panneau routier)
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
    final backgroundColor = _getBackgroundColor(distance);

    return CustomPaint(
      painter: _DirectionSignPainter(backgroundColor),
      child: Container(
        padding: EdgeInsets.only(
          left: AppDimensions.spacingXs,      // ✅ Gauche normal
          right: AppDimensions.spacingS,      // ✅ Droite plus large (16px au lieu de 12px)
          top: AppDimensions.spacingXxxs,
          bottom: AppDimensions.spacingXxxs,
        ),
        child: Text(
          distanceText,
          style: AppTypography.subtitleS(isDark: false).copyWith(
            color: Colors.white, // ✅ Toujours blanc
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  /// Détermine la couleur de fond selon la distance
  Color _getBackgroundColor(double distanceInMeters) {
    final distanceKm = distanceInMeters / 1000;

    if (distanceKm < 5) {
      return Colors.green.shade600; // Proche
    } else {
      return AppColors.primary; // Distance normale
    }
  }
}

/// CustomPainter pour créer la forme de panneau de direction
class _DirectionSignPainter extends CustomPainter {
  final Color backgroundColor;

  _DirectionSignPainter(this.backgroundColor);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.fill;

    final path = Path();
    final arrowWidth = 12.0; // ✅ Flèche plus longue
    final radius = 4.0; // ✅ Rayon d'arrondi

    // Rectangle principal avec angles arrondis
    path.moveTo(radius, 0);
    path.lineTo(size.width - arrowWidth, 0);

    // Pointe droite (flèche) avec courbes arrondies
    path.quadraticBezierTo(
      size.width - 2.0, size.height * 0.3, // ✅ Point de contrôle haut
      size.width, size.height / 2,         // ✅ Pointe de la flèche
    );
    path.quadraticBezierTo(
      size.width - 2.0, size.height * 0.7, // ✅ Point de contrôle bas
      size.width - arrowWidth, size.height, // ✅ Retour vers le rectangle
    );

    // Retour avec angles arrondis
    path.lineTo(radius, size.height);
    path.arcToPoint(
      Offset(0, size.height - radius),
      radius: Radius.circular(radius),
    );
    path.lineTo(0, radius);
    path.arcToPoint(
      Offset(radius, 0),
      radius: Radius.circular(radius),
    );
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}