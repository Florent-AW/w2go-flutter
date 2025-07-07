// lib/core/theme/components/physics/loop_snap_scroll_physics.dart

import 'dart:math' as math;
import 'package:flutter/widgets.dart';
import 'package:flutter/physics.dart';

class LoopSnapScrollPhysics extends ScrollPhysics {
  const LoopSnapScrollPhysics({
    required this.itemExtent,
    this.anchor = 0.0,
    ScrollPhysics? parent,
  }) : super(parent: parent);

  final double itemExtent;
  final double anchor;

  @override
  LoopSnapScrollPhysics applyTo(ScrollPhysics? ancestor) =>
      LoopSnapScrollPhysics(
        itemExtent: itemExtent,
        anchor: anchor,
        parent: buildParent(ancestor),
      );

  double _getPage(double pixels) => (pixels / itemExtent) - anchor;

  double _getTargetPixels(ScrollMetrics position, double velocity) {
    final double page = _getPage(position.pixels);

    double targetPage;
    if (velocity < -tolerance.velocity) {
      targetPage = page.floorToDouble();
    } else if (velocity > tolerance.velocity) {
      targetPage = page.ceilToDouble();
    } else {
      targetPage = page.roundToDouble();
    }

    return (targetPage + anchor) * itemExtent;
  }

  @override
  Simulation? createBallisticSimulation(
      ScrollMetrics position, double velocity) {
    final double target = _getTargetPixels(position, velocity);

    if ((target - position.pixels).abs() < tolerance.distance &&
        velocity.abs() < tolerance.velocity) {
      return null;
    }

    return ScrollSpringSimulation(
      _snapSpring, // ✅ CORRECTION : Utiliser _snapSpring
      position.pixels,
      target,
      velocity,
      tolerance: tolerance,
    );
  }

// ✅ CORRECTION : Préfixe _ pour éviter conflit avec ScrollPhysics.spring
  static const SpringDescription _snapSpring = SpringDescription(
    mass: 1,
    stiffness: 350,
    damping: 38,
  );
}