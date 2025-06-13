// lib/features/welcome/presentation/widgets/molecules/welcome_background.dart
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../../core/theme/components/molecules/background_container.dart';
import '../../../../../core/theme/app_colors.dart';

/// Fond spécifique pour la page d'accueil avec éléments décoratifs
class WelcomeBackground extends StatelessWidget {
  /// Le contenu à afficher
  final Widget child;

  /// Padding à appliquer au contenu
  final EdgeInsetsGeometry? padding;

  const WelcomeBackground({
    Key? key,
    required this.child,
    this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Construire les décorations spécifiques à la welcome page
    final decorations = _buildWelcomeDecorations(context);
    print('🎭 Decorations count: ${decorations.length}');


    // Utiliser le BackgroundContainer générique
    return BackgroundContainer(
      variant: BackgroundVariant.primary, // Utiliser la couleur primaire
      padding: padding,
      decorations: decorations,
      child: child,
    );
  }

  /// Construire les éléments décoratifs spécifiques à la welcome page
  List<Widget> _buildWelcomeDecorations(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return [
      // Pin de localisation en haut à droite
      Positioned(
        top: screenSize.height * -0.13,  // Vous pouvez ajuster cette valeur pour positionner le pin
        right: screenSize.width * -0.4, // Ajusté pour que plus de pin soit visible
        child: SvgPicture.asset(
          'assets/logos/pin_orange_violet.svg',
          height: screenSize.height * 0.7, // Exactement la moitié de la hauteur de l'écran
          // La largeur peut être omise pour maintenir les proportions du SVG
          // Ou vous pouvez définir un rapport largeur/hauteur spécifique:
          fit: BoxFit.contain, // Assurez-vous que le SVG est correctement contenu
        ),
      ),
    ];
  }
}