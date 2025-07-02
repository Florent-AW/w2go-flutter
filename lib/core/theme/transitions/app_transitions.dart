// lib/core/theme/transitions/app_transitions.dart

import 'package:flutter/material.dart';

/// Transitions d'application centralisées et sobres
class AppTransitions {

  /// Slide transition horizontale minimale (presque invisible)
  static Widget slideTransition({
    required Animation<double> animation,
    required Widget child,
    SlideDirection direction = SlideDirection.rightToLeft,
  }) {
    const double slideOffset = 0.15; // ✅ Très subtil (15% au lieu de 100%)

    Offset begin;
    const Offset end = Offset.zero;

    switch (direction) {
      case SlideDirection.rightToLeft:
        begin = const Offset(slideOffset, 0.0);
        break;
      case SlideDirection.leftToRight:
        begin = const Offset(-slideOffset, 0.0);
        break;
      case SlideDirection.topToBottom:
        begin = const Offset(0.0, -slideOffset);
        break;
      case SlideDirection.bottomToTop:
        begin = const Offset(0.0, slideOffset);
        break;
    }

    return SlideTransition(
      position: Tween<Offset>(
        begin: begin,
        end: end,
      ).animate(CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutQuart, // ✅ Courbe très douce
      )),
      child: FadeTransition(
        opacity: Tween<double>(
          begin: 0.85, // ✅ Fade très subtil (85% → 100%)
          end: 1.0,
        ).animate(CurvedAnimation(
          parent: animation,
          curve: Curves.easeOut,
        )),
        child: child,
      ),
    );
  }

  /// Fade transition minimale
  static Widget fadeTransition({
    required Animation<double> animation,
    required Widget child,
  }) {
    return FadeTransition(
      opacity: Tween<double>(
        begin: 0.9, // ✅ Très subtil
        end: 1.0,
      ).animate(CurvedAnimation(
        parent: animation,
        curve: Curves.easeOut,
      )),
      child: child,
    );
  }
}

/// Direction de slide
enum SlideDirection {
  rightToLeft,
  leftToRight,
  topToBottom,
  bottomToTop,
}