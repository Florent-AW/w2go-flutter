// lib/core/theme/app_colors.dart

import 'package:flutter/material.dart';

/// Système de couleurs de l'application Lyra
///
/// Cette classe contient toutes les couleurs utilisées dans l'application,
/// organisées de manière sémantique et accessibles via des getters contextuels.
/// Elle gère automatiquement les thèmes clairs et sombres.
class AppColors {
  // Couleurs primaires
  static const Color primary = Color(0xFF2A1E5C);
  static const Color primaryDark = Color(0xFF2A1E5C);
  static const Color primaryLight = Color(0xFFFAFAFA);

  // Couleurs secondaires
  static const Color secondary = Color(0xFF44AF69); // Nature
  static const Color secondaryDark = Color(0xFF358F54);
  static const Color secondaryLight = Color(0xFF7AC894);

  // Couleurs d'accent
  static const Color accent = Color(0xFFFF390E); // Événements
  static const Color accentDark = Color(0xFF8A5E18);
  static const Color accentLight = Color(0xFFD19F4F);

  // Couleurs neutres
  static const Color neutral900 = Color(0xFF212121); // Le plus foncé
  static const Color neutral800 = Color(0xFF424242);
  static const Color neutral700 = Color(0xFF616161);
  static const Color neutral600 = Color(0xFF757575);
  static const Color neutral500 = Color(0xFF9E9E9E);
  static const Color neutral400 = Color(0xFFBDBDBD);
  static const Color neutral300 = Color(0xFFE0E0E0);
  static const Color neutral200 = Color(0xFFEEEEEE);
  static const Color neutral100 = Color(0xFFF5F5F5);
  static const Color neutral50 = Color(0xFFFAFAFA);  // Le plus clair

  // Couleurs sémantiques
  static const Color success = Color(0xFF4CAF50);
  static const Color successDark = Color(0xFF3B8C3D);
  static const Color successLight = Color(0xFF81C784);

  static const Color error = Color(0xFFFF5252);
  static const Color errorDark = Color(0xFFD32F2F);
  static const Color errorLight = Color(0xFFFF8A80);

  static const Color warning = Color(0xFFFFC107);
  static const Color warningDark = Color(0xFFFFA000);
  static const Color warningLight = Color(0xFFFFD54F);

  static const Color info = Color(0xFF2196F3);
  static const Color infoDark = Color(0xFF1976D2);
  static const Color infoLight = Color(0xFF64B5F6);

  // Couleurs de fond
  static const Color background = Color(0xFFFEFEFE);
  static const Color backgroundDark = Color(0xff0f0722);

  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color surfaceDark = Color(0xFF1E1E1E);

  static const Color blueBackground = Color(0xff0f0722);

  // Couleurs spécifiques aux catégories
  static const Color categoryGastronomie = Color(0xFF7B2C44);
  static const Color categoryCulture = Color(0xFFEFA00B);
  static const Color categoryEvenements = Color(0xFFFF390E);
  static const Color categoryBienEtre = Color(0xFFE09367);
  static const Color categoryDetenteSoiree = Color(0xFF041E39);
  static const Color categorySportsLoisirs = Color(0xFF00798C);
  static const Color categoryNature = Color(0xFF005E5D);

  // Versions dark des couleurs de catégorie
  static const Color categoryGastronomieDark = Color(0xFF7A0617);
  static const Color categoryCultureDark = Color(0xFFD19F4F);
  static const Color categoryEvenementsDark = Color(0xFFFF6E4E);
  static const Color categoryBienEtreDark = Color(0xFFECB395);
  static const Color categoryDetenteSoireeDark = Color(0xFF1A3C5E);
  static const Color categorySportsLoisirsDark = Color(0xFF4DACBD);
  static const Color categoryNatureDark = Color(0xFF7AC894);

  /// Obtient les couleurs des catégories en fonction du mode clair/sombre
  static Color getCategoryColor(String category, {bool isDark = false}) {
    switch (category.toLowerCase()) {
      case 'gastronomie':
        return isDark ? categoryGastronomieDark : categoryGastronomie;
      case 'culture':
        return isDark ? categoryCultureDark : categoryCulture;
      case 'evenements':
      case 'événements':
        return isDark ? categoryEvenementsDark : categoryEvenements;
      case 'bien-etre':
      case 'bien être':
        return isDark ? categoryBienEtreDark : categoryBienEtre;
      case 'detente-soiree':
      case 'détente et soirée':
        return isDark ? categoryDetenteSoireeDark : categoryDetenteSoiree;
      case 'sports-loisirs':
      case 'sports & loisirs':
        return isDark ? categorySportsLoisirsDark : categorySportsLoisirs;
      case 'nature':
        return isDark ? categoryNatureDark : categoryNature;
      default:
        return isDark ? primaryDark : primary;
    }
  }

  /// Génère un ColorScheme complet pour le thème clair
  static ColorScheme get lightColorScheme => ColorScheme(
    primary: primary,
    primaryContainer: primaryLight,
    secondary: secondary,
    secondaryContainer: secondaryLight,
    surface: surfaceLight,
    background: background,
    error: error,
    onPrimary: Colors.white,
    onSecondary: Colors.white,
    onSurface: neutral800,
    onBackground: neutral900,
    onError: Colors.white,
    brightness: Brightness.light,
  );

  /// Génère un ColorScheme complet pour le thème sombre
  static ColorScheme get darkColorScheme => ColorScheme(
    primary: primaryDark,
    primaryContainer: primary,
    secondary: secondaryDark,
    secondaryContainer: secondary,
    surface: surfaceDark,
    background: backgroundDark,
    error: errorDark,
    onPrimary: Colors.white,
    onSecondary: Colors.white,
    onSurface: neutral200,
    onBackground: neutral100,
    onError: Colors.white,
    brightness: Brightness.dark,
  );

  /// Retourne les couleurs adaptées au contexte actuel (clair/sombre)
  static Color getContextualColor(BuildContext context, Color lightColor, Color darkColor) {
    final brightness = Theme.of(context).brightness;
    return brightness == Brightness.light ? lightColor : darkColor;
  }

  /// Adapte automatiquement une couleur pour le mode sombre en l'éclaircissant
  static Color adaptToDarkMode(Color color, {double lightenFactor = 0.2}) {
    final hslColor = HSLColor.fromColor(color);
    return hslColor.withLightness((hslColor.lightness + lightenFactor).clamp(0.0, 1.0)).toColor();
  }

  // COULEURS POUR SHIMMER EFFECT
  // Couleurs pour l'effet de chargement en mode clair
  static const Color shimmerBaseLight = Color(0xFFE0E0E0);
  static const Color shimmerHighlightLight = Color(0xFFF5F5F5);

  // Couleurs pour l'effet de chargement en mode sombre
  static const Color shimmerBaseDark = Color(0xFF303030);
  static const Color shimmerHighlightDark = Color(0xFF383838);

  // Pour la compatibilité avec l'ancien code
  static const Color shimmerBase = shimmerBaseLight;
  static const Color shimmerHighlight = shimmerHighlightLight;

  // Getters qui renvoient la couleur appropriée selon le mode
  static Color getShimmerBase(bool isDark) => isDark ? shimmerBaseDark : shimmerBaseLight;
  static Color getShimmerHighlight(bool isDark) => isDark ? shimmerHighlightDark : shimmerHighlightLight;

}