// lib/core/theme/components/atoms/app_text.dart

import 'package:flutter/material.dart';
import '../../app_typography.dart';
import '../../app_colors.dart';

/// Variantes de texte disponibles
enum TextVariant {
  title,      // Titres de premier niveau
  subtitle,   // Sous-titres
  body,       // Corps de texte standard
  caption,    // Petits textes, annotations
  button,     // Style de bouton
  label,      // Étiquettes et indications
}

/// Composant texte réutilisable et simplifié
///
/// Permet d'appliquer facilement les styles typographiques standardisés
class AppText extends StatelessWidget {
  /// Le texte à afficher
  final String text;

  /// La variante de style à appliquer
  final TextVariant variant;

  /// Si le texte est secondaire (moins visible)
  final bool isSecondary;

  /// Couleur personnalisée (optionnel)
  final Color? color;

  /// Alignement du texte
  final TextAlign? textAlign;

  /// Nombre maximum de lignes
  final int? maxLines;

  /// Si le texte doit être en gras
  final bool isBold;

  /// Si le texte doit être en italique
  final bool isItalic;

  const AppText(
      this.text, {
        Key? key,
        required this.variant,
        this.isSecondary = false,
        this.color,
        this.textAlign,
        this.maxLines,
        this.isBold = false,
        this.isItalic = false,
      }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Obtenir le style de base selon la variante
    TextStyle baseStyle = _getBaseStyle(context);

    // Appliquer les modifications
    final style = baseStyle.copyWith(
      color: color,
      fontWeight: isBold ? FontWeight.bold : null,
      fontStyle: isItalic ? FontStyle.italic : null,
    );

    return Text(
      text,
      style: style,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: maxLines != null ? TextOverflow.ellipsis : null,
    );
  }

  /// Obtient le style de base selon la variante
  TextStyle _getBaseStyle(BuildContext context) {
    switch (variant) {
      case TextVariant.title:
        return context.title;
      case TextVariant.subtitle:
        return context.subtitle;
      case TextVariant.body:
        return isSecondary ? context.bodySecondary : context.body;
      case TextVariant.caption:
        return isSecondary ? context.captionSecondary : context.caption;
      case TextVariant.button:
        return context.buttonStyle;
      case TextVariant.label:
        return isSecondary ? context.labelSecondary : context.label;
    }
  }

  /// Constructeurs pratiques pour les cas courants

  /// Titre principal
  static Widget title(String text, {Color? color, TextAlign? textAlign, bool isBold = false}) {
    return AppText(
      text,
      variant: TextVariant.title,
      color: color,
      textAlign: textAlign,
      isBold: isBold,
    );
  }

  /// Corps de texte
  static Widget body(
      String text, {
        bool isSecondary = false,
        Color? color,
        TextAlign? textAlign,
        int? maxLines,
        bool isBold = false,
      }) {
    return AppText(
      text,
      variant: TextVariant.body,
      isSecondary: isSecondary,
      color: color,
      textAlign: textAlign,
      maxLines: maxLines,
      isBold: isBold,
    );
  }

  /// Petit texte / légende
  static Widget caption(
      String text, {
        bool isSecondary = true,
        Color? color,
        TextAlign? textAlign,
      }) {
    return AppText(
      text,
      variant: TextVariant.caption,
      isSecondary: isSecondary,
      color: color,
      textAlign: textAlign,
    );
  }

  /// Étiquette
  static Widget label(
      String text, {
        bool isSecondary = false,
        Color? color,
        TextAlign? textAlign,
      }) {
    return AppText(
      text,
      variant: TextVariant.label,
      isSecondary: isSecondary,
      color: color,
      textAlign: textAlign,
    );
  }


}