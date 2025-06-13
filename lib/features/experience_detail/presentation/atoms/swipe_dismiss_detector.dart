// lib/features/experience_detail/presentation/atoms/swipe_dismiss_detector.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// ✅ ATOM : Détecteur de swipe down pour fermeture page
class SwipeDismissDetector extends StatefulWidget {
  final VoidCallback onDismiss;
  final double height;

  const SwipeDismissDetector({
    Key? key,
    required this.onDismiss,
    this.height = 60.0,
  }) : super(key: key);

  @override
  State<SwipeDismissDetector> createState() => _SwipeDismissDetectorState();
}

class _SwipeDismissDetectorState extends State<SwipeDismissDetector> {
  static const double _distanceThreshold = 100.0;
  static const double _velocityThreshold = 300.0;
  double _dragDistance = 0.0;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      height: widget.height,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onVerticalDragUpdate: (details) {
          if (details.primaryDelta == null) return;
          // Accumuler seulement le mouvement vers le bas
          if (details.primaryDelta! > 0) {
            _dragDistance += details.primaryDelta!;
          }
        },
        onVerticalDragEnd: (details) {
          final velocity = details.primaryVelocity ?? 0;
          if (_dragDistance > _distanceThreshold || velocity > _velocityThreshold) {
            widget.onDismiss();
            HapticFeedback.lightImpact();
          }
          _dragDistance = 0;
        },
        child: Center(
          child: Container(
            width: 40,
            height: 5,
            decoration: BoxDecoration(
              color: Colors.white54,
              borderRadius: BorderRadius.circular(2.5),
            ),
          ),
        ),
      ),
    );
  }
}