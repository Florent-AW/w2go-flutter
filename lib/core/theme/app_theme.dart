// lib/core/theme/app_theme.dart

import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_typography.dart';
import 'app_dimensions.dart';
import 'extensions/button_tokens.dart';
import 'extensions/selection_tokens.dart';
import 'extensions/action_tokens.dart';
import 'extensions/text_field_tokens.dart';
import 'package:flutter/services.dart';

/// Configuration complète du thème de l'application Lyra
class AppTheme {
  // Empêche l'instanciation de la classe
  AppTheme._();

  /// Génère le thème clair de l'application
  static ThemeData lightTheme(BuildContext context) {
    return _buildTheme(context, Brightness.light);
  }

  /// Génère le thème sombre de l'application
  static ThemeData darkTheme(BuildContext context) {
    return _buildTheme(context, Brightness.dark);
  }

  /// Construit le thème avec la luminosité spécifiée
  static ThemeData _buildTheme(BuildContext context, Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    final colorScheme = isDark ? AppColors.darkColorScheme : AppColors.lightColorScheme;

    // Construction du thème de base
    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,

      // Couleurs principales
      primaryColor: colorScheme.primary,
      scaffoldBackgroundColor: colorScheme.background,
      canvasColor: colorScheme.background,

      // Configuration de la barre d'état
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        elevation: AppDimensions.elevationS,
        systemOverlayStyle: isDark
            ? SystemUiOverlayStyle.light.copyWith(
          statusBarColor: Colors.transparent,
        )
            : SystemUiOverlayStyle.dark.copyWith(
          statusBarColor: Colors.transparent,
        ),
        centerTitle: false,
        iconTheme: IconThemeData(
          color: colorScheme.onSurface,
          size: AppDimensions.iconSizeM,
        ),
        titleTextStyle: AppTypography.subtitle(isDark: isDark),
      ),

      // Configuration des cartes
      cardTheme: CardThemeData(
        color: colorScheme.surface,
        elevation: AppDimensions.elevationS,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusM),
        ),
        clipBehavior: Clip.hardEdge,
      ),

      // Configuration des champs de saisie
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: isDark
            ? AppColors.neutral800.withOpacity(0.5)
            : AppColors.neutral100,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusM),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusM),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusM),
          borderSide: BorderSide(
            color: colorScheme.primary,
            width: AppDimensions.borderWidthThin,
          ),
        ),
        contentPadding: AppDimensions.paddingS,
      ),

      // Configuration du thème des icônes
      iconTheme: IconThemeData(
        color: colorScheme.onSurface,
        size: AppDimensions.iconSizeM,
      ),

      // Typographie complète
      textTheme: AppTypography.createTextTheme(isDark),

      // Extensions de thème
      extensions: [
        isDark ? ButtonTokens.dark() : ButtonTokens.light(),
        isDark ? SelectionTokens.dark() : SelectionTokens.light(),
        isDark ? ActionTokens.dark() : ActionTokens.light(),
        isDark ? TextFieldTokens.dark() : TextFieldTokens.light(),
      ],
    );
  }

  /// Configure les styles de l'application pour les versions iOS et Android
  static void setupSystemUI({required bool isDarkMode}) {
    // Configurer la barre d'état
    SystemChrome.setSystemUIOverlayStyle(
      isDarkMode
          ? SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: AppColors.backgroundDark,
        systemNavigationBarIconBrightness: Brightness.light,
      )
          : SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: AppColors.background,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );

    // Orienter l'application en mode portrait uniquement
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }
}