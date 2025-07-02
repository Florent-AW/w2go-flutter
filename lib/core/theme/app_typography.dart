// lib/core/theme/app_typography.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// Système typographique complet de l'application
///
/// Centralise à la fois la gestion des polices et les styles typographiques
class AppTypography {
  // CONFIGURATION DES POLICES
  // =========================

  /// Police principale de l'application
  static String _primaryFontFamily = 'Jost';

  /// Si true, utilise Google Fonts, sinon utilise les polices locales du pubspec
  static bool _useGoogleFonts = true;

  /// Change la police principale (utile pour le testing A/B)
  static void changePrimaryFont(String fontFamily, {bool useGoogleFonts = true}) {
    _primaryFontFamily = fontFamily;
    _useGoogleFonts = useGoogleFonts;
  }

  // STYLES TYPOGRAPHIQUES DE BASE
  // ============================

  // Paramètres communs
  static const double _lineHeightNormal = 1.4;
  static const double _lineHeightCompact = 1.3;

  // STYLES PRINCIPAUX

  /// Titre principal (30px)
  static TextStyle titleL({bool isDark = false}) => _getFont(
    fontSize: 30,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.5,
    color: isDark ? Colors.white : AppColors.primary,
    height: _lineHeightNormal,
  );

  /// Titre principal (26px)
  static TextStyle titleM({bool isDark = false}) => _getFont(
    fontSize: 26,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.5,
    color: isDark ? Colors.white : AppColors.primary,
    height: _lineHeightNormal,
  );

  /// Titre principal (24px)
  static TextStyle title({bool isDark = false}) => _getFont(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.5,
    color: isDark ? Colors.white : AppColors.primary,
    height: _lineHeightNormal,
  );

  /// Titre secondaire (22px)
  static TextStyle titleS({bool isDark = false}) => _getFont(
    fontSize: 22,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.5,
    color: isDark ? Colors.white : AppColors.primary,
    height: _lineHeightNormal,
  );

  /// Titre secondaire (20px)
  static TextStyle titleXs({bool isDark = false}) => _getFont(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    letterSpacing: -0.5,
    color: isDark ? Colors.white : AppColors.primary,
    height: _lineHeightNormal,
  );

  /// Titre card (18px)
  static TextStyle titleXxs({
    bool isDark = false,
    bool isSecondary = false
  }) => _getFont(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.35,
    color: isDark ? Colors.white : AppColors.primary,
    height: _lineHeightCompact,
  );


  /// Sous-titre (16px)
  static TextStyle subtitle({
    bool isDark = false,
    bool isSecondary = false
  }) => _getFont(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.35,
    color: isDark ? Colors.white : AppColors.primary,
    height: _lineHeightCompact,
  );

  /// Sous-titre (13px)
  static TextStyle subtitleS({
    bool isDark = false,
    bool isSecondary = false
  }) => _getFont(
    fontSize: 13,
    fontWeight: FontWeight.normal,
    letterSpacing: 0.1,
    color: _getTextColor(isDark, isSecondary),
    height: _lineHeightNormal,
  );

  /// Corps de texte standard (16px)
  static TextStyle body({
    bool isDark = false,
    bool isSecondary = false
  }) => _getFont(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    letterSpacing: 0,
    color: _getTextColor(isDark, isSecondary),
    height: _lineHeightNormal,
  );

  /// Texte d'annotation (14px)
  static TextStyle caption({
    bool isDark = false,
    bool isSecondary = false
  }) => _getFont(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    letterSpacing: 0,
    color: _getTextColor(isDark, isSecondary, moreSubdued: true),
    height: _lineHeightNormal,
  );

  /// Style pour les catégories sélectionnables
  static TextStyle categoryLabel({
    required bool isActive,
    required String hexColor,
  }) {
    return _getFont(
      fontSize: 16,
      letterSpacing: -0.2,
      fontWeight: isActive ? FontWeight.w600 : FontWeight.w600,
      color: isActive
          ? Color(int.parse(hexColor.replaceAll('#', '0xFF')))
          : Colors.white,
      height: _lineHeightCompact,
    );
  }

  /// Style pour les boutons
  static TextStyle button({bool isDark = false}) => _getFont(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.1,
    color: isDark ? Colors.white : AppColors.primary,
    height: _lineHeightCompact,
  );

  static TextStyle buttonS({bool isDark = false}) => _getFont(
    fontSize: 15,
    fontWeight: FontWeight.w500,
    letterSpacing: 0,
    color: isDark ? Colors.white : AppColors.primary,
    height: _lineHeightCompact,
  );

  static TextStyle buttonXs({bool isDark = false}) => _getFont(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
    color: isDark ? Colors.white : AppColors.primary,
    height: _lineHeightCompact,
  );

  /// Style pour les étiquettes ou libellés
  static TextStyle label({
    bool isDark = false,
    bool isSecondary = false
  }) => _getFont(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.2,
    color: _getTextColor(isDark, isSecondary),
    height: _lineHeightCompact,
  );

  // MÉTHODES UTILITAIRES
  // ===================

  /// Obtient la couleur du texte selon le mode et l'importance
  static Color _getTextColor(bool isDark, bool isSecondary, {bool moreSubdued = false}) {
    if (isSecondary) {
      return isDark
          ? Colors.white.withOpacity(moreSubdued ? 0.5 : 0.7)
          : AppColors.primary;
    } else {
      return isDark ? Colors.white : AppColors.primary;
    }
  }

  /// Méthode principale pour obtenir un style typographique
  static TextStyle _getFont({
    required double fontSize,
    FontWeight fontWeight = FontWeight.normal,
    Color? color,
    double? height,
    double? letterSpacing,
    TextDecoration? decoration,
    FontStyle? fontStyle,
  }) {
    // Utiliser Google Fonts si activé
    if (_useGoogleFonts) {
      switch (_primaryFontFamily.toLowerCase()) {
        case 'jost':
          return GoogleFonts.jost(
            fontSize: fontSize,
            fontWeight: fontWeight,
            color: color,
            height: height,
            letterSpacing: letterSpacing,
            decoration: decoration,
            fontStyle: fontStyle,
          );

        default:
          return TextStyle(
            fontFamily: _primaryFontFamily,
            fontSize: fontSize,
            fontWeight: fontWeight,
            color: color,
            height: height,
            letterSpacing: letterSpacing,
            decoration: decoration,
            fontStyle: fontStyle,
          );
      }
    } else {
      return TextStyle(
        fontFamily: _primaryFontFamily,
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color,
        height: height,
        letterSpacing: letterSpacing,
        decoration: decoration,
        fontStyle: fontStyle,
      );
    }
  }

  /// Crée un TextTheme complet pour l'application
  static TextTheme createTextTheme(bool isDark) {
    return TextTheme(
      displayLarge: title(isDark: isDark),
      displayMedium: subtitle(isDark: isDark),
      displaySmall: body(isDark: isDark, isSecondary: false),
      bodyLarge: body(isDark: isDark, isSecondary: false),
      bodyMedium: caption(isDark: isDark, isSecondary: false),
      bodySmall: caption(isDark: isDark, isSecondary: true),
      labelMedium: label(isDark: isDark, isSecondary: false),
    );
  }
}

/// Extension pour faciliter l'accès aux styles dans les widgets
extension TextStyleExtension on BuildContext {
  bool get isDark => Theme.of(this).brightness == Brightness.dark;

  TextStyle get title => AppTypography.title(isDark: isDark);
  TextStyle get titleL => AppTypography.titleL(isDark: isDark);
  TextStyle get titleM => AppTypography.titleM(isDark: isDark);
  TextStyle get titleS => AppTypography.titleS(isDark: isDark);
  TextStyle get titleXs => AppTypography.titleXs(isDark: isDark);
  TextStyle get titleXxs => AppTypography.titleXxs(isDark: isDark);
  TextStyle get subtitle => AppTypography.subtitle(isDark: isDark);
  TextStyle get subtitleS => AppTypography.subtitleS(isDark: isDark);
  TextStyle get body => AppTypography.body(isDark: isDark);
  TextStyle get bodySecondary => AppTypography.body(isDark: isDark, isSecondary: true);
  TextStyle get caption => AppTypography.caption(isDark: isDark);
  TextStyle get captionSecondary => AppTypography.caption(isDark: isDark, isSecondary: true);
  TextStyle get buttonStyle => AppTypography.button(isDark: isDark);
  TextStyle get buttonS => AppTypography.buttonS(isDark: isDark);
  TextStyle get buttonXs => AppTypography.buttonXs(isDark: isDark);
  TextStyle get label => AppTypography.label(isDark: isDark);
  TextStyle get labelSecondary => AppTypography.label(isDark: isDark, isSecondary: true);
}