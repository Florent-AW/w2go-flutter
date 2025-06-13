// lib/core/theme/components/atoms/app_button.dart
import 'package:flutter/material.dart';
import '../../app_typography.dart';
import '../../extensions/button_tokens.dart';

/// Composant bouton standardisé suivant le design system
class AppButton extends StatelessWidget {
  /// Texte affiché sur le bouton
  final String label;

  /// Action à exécuter lors du tap
  final VoidCallback? onPressed;

  /// Variante de bouton (style)
  final ButtonVariant variant;

  /// Taille du bouton
  final ButtonSize size;

  /// Si true, bouton prend toute la largeur disponible
  final bool isFullWidth;

  /// Si true, affiche un indicateur de chargement
  final bool isLoading;

  /// Icône à afficher avant le texte (optionnel)
  final IconData? leftIcon;

  /// Icône à afficher après le texte (optionnel)
  final IconData? rightIcon;

  // Constructeurs nommés suivant le pattern factory enum
  const AppButton.primary({
    Key? key,
    required this.label,
    required this.onPressed,
    this.size = ButtonSize.large,
    this.isFullWidth = false,
    this.isLoading = false,
    this.leftIcon,
    this.rightIcon,
  }) : variant = ButtonVariant.primary,
        super(key: key);

  const AppButton.secondary({
    Key? key,
    required this.label,
    required this.onPressed,
    this.size = ButtonSize.large,
    this.isFullWidth = false,
    this.isLoading = false,
    this.leftIcon,
    this.rightIcon,
  }) : variant = ButtonVariant.secondary,
        super(key: key);

  const AppButton.accent({
    Key? key,
    required this.label,
    required this.onPressed,
    this.size = ButtonSize.large,
    this.isFullWidth = false,
    this.isLoading = false,
    this.leftIcon,
    this.rightIcon,
  }) : variant = ButtonVariant.accent,
        super(key: key);

  const AppButton.error({
    Key? key,
    required this.label,
    required this.onPressed,
    this.size = ButtonSize.large,
    this.isFullWidth = false,
    this.isLoading = false,
    this.leftIcon,
    this.rightIcon,
  }) : variant = ButtonVariant.error,
        super(key: key);

  const AppButton.outline({
    Key? key,
    required this.label,
    required this.onPressed,
    this.size = ButtonSize.large,
    this.isFullWidth = false,
    this.isLoading = false,
    this.leftIcon,
    this.rightIcon,
  }) : variant = ButtonVariant.outline,
        super(key: key);

  const AppButton.text({
    Key? key,
    required this.label,
    required this.onPressed,
    this.size = ButtonSize.large,
    this.isFullWidth = false,
    this.isLoading = false,
    this.leftIcon,
    this.rightIcon,
  }) : variant = ButtonVariant.text,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isDisabled = onPressed == null || isLoading;
    final ButtonTokens tokens = Theme.of(context).extension<ButtonTokens>() ??
        (Theme.of(context).brightness == Brightness.dark
            ? ButtonTokens.dark()
            : ButtonTokens.light());

    final effectiveTokens = isDisabled ? tokens.disabled(context) : tokens;

    return Semantics(
      button: true,
      enabled: !isDisabled,
      label: '$label button',
      child: SizedBox(
        width: isFullWidth ? double.infinity : null,
        height: effectiveTokens.heights[size],
        child: ElevatedButton(
          onPressed: isDisabled ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: effectiveTokens.backgroundColors[variant],
            foregroundColor: effectiveTokens.contentColors[variant],
            elevation: 0,
            shadowColor: Colors.transparent,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(100),
              side: effectiveTokens.outlineBorderSides[variant] ?? BorderSide.none,
            ),
          ),
          child: _buildButtonContent(context, isDisabled, effectiveTokens),
        ),
      ),
    );
  }

  /// Construit le contenu interne du bouton (texte, icônes, loader)
  Widget _buildButtonContent(BuildContext context, bool isDisabled, ButtonTokens tokens) {
    if (isLoading) {
      return SizedBox(
        width: 24,
        height: 24,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(
            tokens.contentColors[variant] ?? Colors.white,
          ),
        ),
      );
    }

    final List<Widget> children = [];

    if (leftIcon != null) {
      children.add(Icon(
        leftIcon,
        size: tokens.iconSizes[size],
        color: tokens.contentColors[variant],
      ));
      children.add(const SizedBox(width: 8));
    }

    children.add(Text(
      label,
      style: AppTypography.button(
        isDark: Theme.of(context).brightness == Brightness.dark,
      ).copyWith(
        color: tokens.contentColors[variant],
      ),
    ));

    if (rightIcon != null) {
      children.add(const SizedBox(width: 8));
      children.add(Icon(
        rightIcon,
        size: tokens.iconSizes[size],
        color: tokens.contentColors[variant],
      ));
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: children,
    );
  }
}