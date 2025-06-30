// lib/core/theme/app_dimensions.dart

import 'package:flutter/material.dart';

/// Système de dimensions et d'espacements de l'application Lyra
///
/// Cette classe contient toutes les valeurs standards pour les espacements,
/// rayons, tailles et élévations à utiliser de manière cohérente dans toute l'application.
class AppDimensions {
  // Système d'espacement basé sur une grille de 4px
  // Système de nommage: space{N} où N est la valeur en pixels divisée par 4
  static const double space0 = 0;      // 0px - Pas d'espacement
  static const double space1 = 4;      // 4px - Très petit
  static const double space2 = 8;      // 8px - Petit
  static const double space3 = 12;     // 12px - Compact
  static const double space4 = 16;     // 16px - Standard
  static const double space5 = 20;     // 20px - Moyen
  static const double space6 = 24;     // 24px - Confortable
  static const double space8 = 32;     // 32px - Large
  static const double space10 = 40;    // 40px - Très large
  static const double space12 = 48;    // 48px - Extra large
  static const double space16 = 64;    // 64px - Énorme
  static const double space20 = 80;    // 80px - Super énorme
  static const double space24 = 96;    // 96px - Ultra large
  static const double space32 = 128;   // 128px - Maximum

  // Espacements nommés sémantiquement (plus facile à utiliser)
  static const double spacingXxxs = space1;   // 4px
  static const double spacingXxs = space2;    // 8px
  static const double spacingXs = space3;     // 12px
  static const double spacingS = space4;      // 16px
  static const double spacingM = space6;      // 24px
  static const double spacingL = space8;      // 32px
  static const double spacingXl = space12;    // 48px
  static const double spacingXxl = space16;   // 64px
  static const double spacingXxxl = space24;  // 96px

  // Paddings standards pour les containers
  static const EdgeInsets paddingXxs = EdgeInsets.all(spacingXxs);
  static const EdgeInsets paddingXs = EdgeInsets.all(spacingXs);
  static const EdgeInsets paddingS = EdgeInsets.all(spacingS);
  static const EdgeInsets paddingM = EdgeInsets.all(spacingM);
  static const EdgeInsets paddingL = EdgeInsets.all(spacingL);

  // Paddings horizontaux standards
  static const EdgeInsets paddingHorizontalXxs = EdgeInsets.symmetric(horizontal: spacingXxs);
  static const EdgeInsets paddingHorizontalXs = EdgeInsets.symmetric(horizontal: spacingXs);
  static const EdgeInsets paddingHorizontalS = EdgeInsets.symmetric(horizontal: spacingS);
  static const EdgeInsets paddingHorizontalM = EdgeInsets.symmetric(horizontal: spacingM);
  static const EdgeInsets paddingHorizontalL = EdgeInsets.symmetric(horizontal: spacingL);

  // Paddings verticaux standards
  static const EdgeInsets paddingVerticalXxs = EdgeInsets.symmetric(vertical: spacingXxs);
  static const EdgeInsets paddingVerticalXs = EdgeInsets.symmetric(vertical: spacingXs);
  static const EdgeInsets paddingVerticalS = EdgeInsets.symmetric(vertical: spacingS);
  static const EdgeInsets paddingVerticalM = EdgeInsets.symmetric(vertical: spacingM);
  static const EdgeInsets paddingVerticalL = EdgeInsets.symmetric(vertical: spacingL);

  // Paddings de page standards (horizontal seulement)
  static const EdgeInsets pagePaddingSmall = EdgeInsets.symmetric(horizontal: spacingS);
  static const EdgeInsets pagePaddingMedium = EdgeInsets.symmetric(horizontal: spacingM);
  static const EdgeInsets pagePaddingLarge = EdgeInsets.symmetric(horizontal: spacingL);

  // Rayons d'arrondi
  static const double radiusNone = 0;                // Pas d'arrondis
  static const double radiusXs = 4;                  // Très faible arrondi
  static const double radiusS = 8;                   // Faible arrondi
  static const double radiusM = 12;                  // Arrondi moyen
  static const double radiusL = 16;                  // Grand arrondi
  static const double radiusXl = 24;                 // Très grand arrondi
  static const double radiusCircular = 1000;         // Complètement circulaire

  // Border radius
  static BorderRadius borderRadiusNone = BorderRadius.circular(radiusNone);
  static BorderRadius borderRadiusXs = BorderRadius.circular(radiusXs);
  static BorderRadius borderRadiusS = BorderRadius.circular(radiusS);
  static BorderRadius borderRadiusM = BorderRadius.circular(radiusM);
  static BorderRadius borderRadiusL = BorderRadius.circular(radiusL);
  static BorderRadius borderRadiusXl = BorderRadius.circular(radiusXl);
  static BorderRadius borderRadiusCircular = BorderRadius.circular(radiusCircular);

  // Hauteurs standardisées pour les composants
  static const double buttonHeightS = 32;     // Petit bouton
  static const double buttonHeightM = 36;     // Bouton standard
  static const double buttonHeightL = 40;     // Grand bouton
  static const double buttonHeightXl = 44;    // Très grand bouton

  static const double buttonWidthS = 80;     // Petit bouton
  static const double buttonWidthM = 120;     // Bouton standard
  static const double buttonWidthL = 160;     // Grand bouton
  static const double buttonWidthXl = 200;    // Très grand bouton

  static const double inputHeightS = 36;      // Petit champ de saisie
  static const double inputHeightM = 44;      // Champ standard
  static const double inputHeightL = 52;      // Grand champ

  static const double appBarHeight = 56;      // Hauteur standard de la barre d'application
  static const double tabBarHeight = 48;      // Hauteur de la barre d'onglets
  static const double bottomNavBarHeight = 56; // Hauteur de la barre de navigation inférieure

  // Tailles d'icônes
  static const double iconSizeXs = 12;        // Très petite icône
  static const double iconSizeS = 16;         // Petite icône
  static const double iconSizeSM = 20;         // Petite icône
  static const double iconSizeM = 24;         // Icône standard
  static const double iconSizeL = 32;         // Grande icône
  static const double iconSizeXl = 48;        // Très grande icône

  // Niveaux d'élévation (pour les ombres)
  static const double elevationNone = 0;      // Pas d'élévation
  static const double elevationXs = 1;        // Très faible élévation
  static const double elevationS = 2;         // Faible élévation (cartes)
  static const double elevationM = 4;         // Élévation moyenne (barres d'app)
  static const double elevationL = 8;         // Forte élévation (FAB, dialogs)
  static const double elevationXl = 16;       // Très forte élévation (modals)

  // Taille de l'avatar
  static const double avatarSizeS = 32;       // Petit avatar
  static const double avatarSizeM = 40;       // Avatar moyen
  static const double avatarSizeL = 56;       // Grand avatar
  static const double avatarSizeXl = 80;      // Très grand avatar

  // Épaisseurs de bordure
  static const double borderWidthThin = 1;    // Bordure fine
  static const double borderWidthRegular = 2; // Bordure standard
  static const double borderWidthThick = 3;   // Bordure épaisse

  // Dimensions de activity card
  static const double activityCardHeight = 420.0;
  static const double activityCardHeaderHeight = 0.5;
  static const double activityCardDefaultWidth = 280.0; // Largeur minimale de sécurité



  // Breakpoints pour le design responsive
  static const double breakpointXs = 0;       // Extra petit (téléphones en portrait)
  static const double breakpointS = 480;      // Petit (téléphones en paysage)
  static const double breakpointM = 768;      // Moyen (tablettes)
  static const double breakpointL = 1024;     // Large (tablettes paysage / petits ordinateurs)
  static const double breakpointXl = 1440;    // Extra large (ordinateurs)

  // Méthodes utilitaires pour le responsive

  /// Détermine si l'écran actuel est considéré comme petit (téléphone en portrait)
  static bool isSmallScreen(BuildContext context) {
    return MediaQuery.of(context).size.width < breakpointS;
  }

  /// Détermine si l'écran actuel est considéré comme moyen (tablette)
  static bool isMediumScreen(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= breakpointS && width < breakpointL;
  }

  /// Détermine si l'écran actuel est considéré comme large (tablette paysage / petit ordinateur)
  static bool isLargeScreen(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= breakpointL && width < breakpointXl;
  }

  /// Détermine si l'écran actuel est considéré comme extra large (ordinateur)
  static bool isExtraLargeScreen(BuildContext context) {
    return MediaQuery.of(context).size.width >= breakpointXl;
  }

  /// Retourne une valeur qui s'adapte à la taille de l'écran
  static double responsiveSize(
      BuildContext context, {
        required double small,
        double? medium,
        double? large,
        double? extraLarge,
      }) {
    final screenWidth = MediaQuery.of(context).size.width;

    if (screenWidth >= breakpointXl && extraLarge != null) {
      return extraLarge;
    } else if (screenWidth >= breakpointL && large != null) {
      return large;
    } else if (screenWidth >= breakpointS && medium != null) {
      return medium;
    } else {
      return small;
    }
  }

  /// Obtient le padding horizontal de page adapté à la taille de l'écran
  static EdgeInsets getResponsivePagePadding(BuildContext context) {
    if (isSmallScreen(context)) {
      return pagePaddingSmall;
    } else if (isMediumScreen(context)) {
      return pagePaddingMedium;
    } else {
      return pagePaddingLarge;
    }
  }

  // ================================
  // CAROUSEL RESPONSIVE SYSTEM v1.0
  // ================================

  // Breakpoints spécifiques carousels (naming neutre)
  static const double carouselBp1Card = 600;    // Mobile portrait/paysage
  static const double carouselBp2Cards = 900;   // Tablet portrait + mobile paysage
  // > 900px = 3 cards (tablet paysage)

  // Largeur minimale pour garantir la lisibilité
  static const double carouselMinCardWidth = 288.0;

  /// Détermine le nombre de cards à afficher selon la largeur disponible
  ///
  /// Utilise LayoutBuilder context pour robustesse (split-screen, foldables)
  /// Returns: 1, 2 ou 3 cards selon les breakpoints
  static int getCarouselCardCount(BoxConstraints constraints) {
    final availableWidth = constraints.maxWidth;

    if (availableWidth < carouselBp1Card) return 1;
    if (availableWidth < carouselBp2Cards) return 2;
    return 3;
  }

  /// Calcule la largeur optimale d'une card de carousel
  ///
  /// Intègre peeking adaptatif et validation largeur minimale
  /// [constraints] : BoxConstraints du LayoutBuilder parent
  /// Returns: Largeur calculée, jamais < carouselMinCardWidth
  /// Calcule la largeur optimale d'une card de carousel
  static double calculateCarouselCardWidth(BoxConstraints constraints) {
    final availableWidth = constraints.maxWidth;
    final cardCount = getCarouselCardCount(constraints);

    // ✅ NOUVEAU : Peeking fixe de 10px au lieu d'adaptatif
    const peekWidth = 16.0; // ✅ Fixe à 10px comme demandé

    // Padding horizontal du carousel (left + right)
    const horizontalPadding = spacingS * 2; // 32px (16px * 2)

    // Spacing entre les cards
    final spacingBetween = spacingS * (cardCount - 1); // 16px entre cards

    // Calcul largeur brute
    final calculatedWidth = (availableWidth - horizontalPadding - spacingBetween - peekWidth) / cardCount;

    // ✅ Validation largeur minimale pour lisibilité
    final finalWidth = calculatedWidth.clamp(carouselMinCardWidth, double.infinity);

    return finalWidth;
  }

  /// Méthode helper pour LayoutBuilder dans les carousels
  ///
  /// Remplace MediaQuery.of(context).size.width pour plus de robustesse
  /// Usage: LayoutBuilder(builder: (context, constraints) => ...)
  static Widget buildResponsiveCarousel({
    required Widget Function(BuildContext context, BoxConstraints constraints) builder,
  }) {
    return LayoutBuilder(builder: builder);
  }

  /// Validation pour tests golden - vérifie les largeurs critiques
  ///
  /// Usage dans tests: AppDimensions.validateCarouselSizes()
  static Map<String, dynamic> validateCarouselSizes() {
    // Tailles de test (iPhone SE, iPad Mini, iPad Pro)
    final testSizes = [
      (width: 360.0, name: 'iPhone SE'),
      (width: 820.0, name: 'iPad Mini'),
      (width: 1366.0, name: 'iPad Pro'),
    ];

    final results = <String, dynamic>{};

    for (final size in testSizes) {
      final constraints = BoxConstraints(maxWidth: size.width);
      final cardCount = getCarouselCardCount(constraints);
      final cardWidth = calculateCarouselCardWidth(constraints);

      results[size.name] = {
        'width': size.width,
        'cardCount': cardCount,
        'cardWidth': cardWidth.round(),
        'isValid': cardWidth >= carouselMinCardWidth,
      };
    }

    return results;
  }

}