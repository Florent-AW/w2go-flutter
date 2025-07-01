// lib/features/experience_detail/presentation/utils/hero_rect_tween_mixin.dart

import 'package:flutter/material.dart';

/// Mixin providing a Hero rect tween that clamps the starting Y
/// coordinate inside a viewport range to shorten return animations
/// when the original Hero widget is far off‑screen.
mixin ViewportClampedRectTweenMixin<T extends StatefulWidget> on State<T> {
  Tween<Rect?> viewportClampedRectTween(Rect? begin, Rect? end) {
    if (begin == null || end == null) {
      return RectTween(begin: begin, end: end);
    }

    const double minY = 56.0;
    final double maxY = MediaQuery.of(context).size.height * 0.6;

    double clampY(double y) {
      if (y < minY) return minY;
      if (y > maxY) return maxY;
      return y;
    }

    final clampedBegin = Rect.fromLTWH(
      begin.left,
      clampY(begin.top),
      begin.width,
      begin.height,
    );

    return MaterialRectCenterArcTween(begin: clampedBegin, end: end);
  }
}