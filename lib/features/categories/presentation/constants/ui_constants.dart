// lib/features/categories/presentation/constants/ui_constants.dart

import 'package:flutter/material.dart';

/// Constantes UI pour la page Catégorie
class CategoryUIConstants {
  /// Hauteur relative de la section cover (~55% de l'écran, conforme au cahier des charges)
  static const double coverHeight = 0.55;

  /// Hauteur maximale absolue de la cover (360dp max)
  static const double maxCoverHeight = 600.0;

  /// Correction pour l'espace entre onglets et cover (superposition)
  static const double tabOverlap = 2.5;

  /// Hauteur de la barre d'onglets
  static const double tabHeight = 63.0;

  /// Radius des onglets
  static const double tabRadius = 8.0;

  /// Opacité du scrim de base (40%)
  static const double scrimOpacity = 0.4;

  /// Opacité maximale du scrim au scroll (70%)
  static const double scrimMaxOpacity = 0.7;

  /// Vitesse maximale de défilement (pour ClampingScrollPhysics)
  static const double maxScrollVelocity = 12000.0;

  /// Durée d'attente de précachage d'image (ms)
  static const int imagePrecacheTimeout = 300;

  /// Seuil de swipe horizontal bloqué (en pixels)
  static const double horizontalSwipeThreshold = 10.0;

  /// Nombre maximum d'images précachées
  static const int maxPrecachedImages = 3;
}