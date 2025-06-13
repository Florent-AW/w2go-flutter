// lib/core/theme/components/physics/threshold_40px_physics.dart

import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:infinite_carousel/infinite_carousel.dart';

/// Utilitaire : ressort sur-critique pour éliminer 100% du rebond
SpringDescription _criticallyDamped({
  required double stiffness,
  double mass = 1.0,
}) {
  final critical = 2 * math.sqrt(stiffness * mass);
  // Légèrement > 1 pour un arrêt net, jamais de retour
  return SpringDescription(
    mass: mass,
    stiffness: stiffness,
    damping: critical * 1.1, // ✅ Sur-amorti = zéro oscillation
  );
}

/// Physics avec seuil de déclenchement de 40px + fin de course rapide SANS rebond
class Threshold40pxPhysics extends InfiniteScrollPhysics {
  const Threshold40pxPhysics({
    this.triggerPx = 40.0,
    this.landingFactor = 1.7,
    this.itemExtent,
    ScrollPhysics? parent,
  }) : super(parent: parent);

  final double triggerPx;
  final double landingFactor;
  final double? itemExtent; // on récupère celle du carousel si null

  @override
  Threshold40pxPhysics applyTo(ScrollPhysics? ancestor) =>
      Threshold40pxPhysics(
        triggerPx: triggerPx,
        landingFactor: landingFactor,
        itemExtent: itemExtent,
        parent: buildParent(ancestor), // ✅ Héritage correct du parent
      );

  /// ✅ CORRIGÉ : Snapping avec logique directionnelle précise
  double _getTargetPixels(ScrollMetrics position, Tolerance tolerance, double velocity) {
    // ✅ SIMPLIFIÉ : Utiliser seulement l'API publique
    final extent = itemExtent ?? 300.0; // Utiliser itemExtent passé en paramètre

    // ✅ NOUVEAU : Position fractionnelle pour éviter le bug "saut de 2"
    final cardPos = position.pixels / extent;      // position "fractionnelle"
    final offset = (cardPos - cardPos.floor()) * extent;
    int index;                                     // sera décidé ci-dessous

    // ✅ CORRIGÉ : Logique directionnelle précise
    if (velocity > 0) {
      index = (offset > triggerPx)
          ? cardPos.floor() + 1               // passe à la suivante
          : cardPos.floor();                  // reste
    } else if (velocity < 0) {
      index = (offset < extent - triggerPx)
          ? cardPos.ceil() - 1                // passe à la précédente (−1)
          : cardPos.ceil();                   // reste
    } else {
      index = cardPos.round();               // aucun fling → arrondi classique
    }

    // Clamp pour éviter de dépasser les bornes
    final maxIndex = (position.maxScrollExtent / extent).floor();
    index = index.clamp(0, maxIndex);

    return (index * extent).toDouble();
  }

  /// ✅ CORRIGÉ : Ressort sur-critique pour zéro rebond
  @override
  Simulation? createBallisticSimulation(ScrollMetrics position, double velocity) {
    // Si pas de velocity significative, comportement par défaut
    if (velocity.abs() < tolerance.velocity) {
      return super.createBallisticSimulation(position, velocity);
    }

    final target = _getTargetPixels(position, tolerance, velocity);

    if ((target - position.pixels).abs() < tolerance.distance) {
      return null;
    }

    // ✅ NOUVEAU : Ressort sur-critique = zéro rebond
    final stiffness = 300.0 * landingFactor;
    final spring = _criticallyDamped(stiffness: stiffness);

    return ScrollSpringSimulation(
      spring,
      position.pixels,
      target,
      velocity,
      tolerance: tolerance,
    );
  }
}