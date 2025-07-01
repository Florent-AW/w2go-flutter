// lib/core/common/utils/viewport_clamped_rect_tween_mixin.dart

import "package:flutter/material.dart";

mixin ViewportClampedRectTweenMixin {
  static const double _minY = 56.0;
  static const double _maxScreenFactor = .60;

  RectTween viewportClampedRectTween(Rect? begin, Rect? end, BuildContext ctx) {
    if (begin == null || end == null) {
      return RectTween(begin: begin, end: end);
    }

    final maxY = MediaQuery.of(ctx).size.height * _maxScreenFactor;

    double clampY(double y) =>
        y < _minY ? _minY : (y > maxY ? maxY : y);

    final clampedBegin = Rect.fromLTWH(
      begin.left,
      clampY(begin.top),
      begin.width,
      begin.height,
    );

    return MaterialRectCenterArcTween(begin: clampedBegin, end: end);
  }
}