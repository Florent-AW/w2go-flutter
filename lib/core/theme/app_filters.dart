// lib/core/theme/app_filters.dart

import 'package:flutter/material.dart';

abstract class AppFilters {
  // Désaturation de 10%
  static const ColorFilter desaturate = ColorFilter.matrix([
    0.8, 0, 0, 0, 0,    // Rouge à 90%
    0, 0.8, 0, 0, 0,    // Vert à 90%
    0, 0, 0.8, 0, 0,    // Bleu à 90%
    0, 0, 0, 1, 0,      // Alpha inchangé
  ]);

  // Filtre beige
  static final Color beigeOverlay = const Color(0xFFDE7C5A).withAlpha(20); // ~0.1 opacity
}