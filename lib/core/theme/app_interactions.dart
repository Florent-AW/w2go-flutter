// lib/core/theme/app_interactions.dart

import 'package:flutter/material.dart';
import 'package:flutter_touch_ripple/flutter_touch_ripple.dart';
import 'enums/ripple_type.dart';

class AppInteractions {
  static Widget addCircularRipple({
    required Widget child,
    required VoidCallback? onTap,
    Color? rippleColor,
  }) {
    return TouchRipple(
      onTap: onTap,
      rippleColor: rippleColor?.withAlpha(20),
      rippleScale: 1.8,
      // Plus grand maintenant qu'on a le clipping
      previewDuration: const Duration(milliseconds: 300),
      tappableDuration: const Duration(milliseconds: 300),
      focusColor: Colors.transparent,
      hoverColor: Colors.transparent,
      useFocusEffect: false,
      useHoverEffect: false,
      rippleBorderRadius: BorderRadius.circular(100),
      child: child,
    );
  }


  /// Ripple compact pour boutons d'action, icônes et éléments UI petits
  /// Optimisé pour rester dans les limites du composant
  static Widget addCompactRipple({
    required Widget child,
    required VoidCallback? onTap,
    Color? rippleColor,
    double? customScale,
    double? customBlur,
    double? customRadius,
    bool debugMode = false,
  }) {
    if (debugMode) {
      print('🎯 CompactRipple - Scale: ${customScale ?? _compactRippleScale}, Blur: ${customBlur ?? _compactRippleBlur}');
    }

    return TouchRipple(
      onTap: onTap,
      rippleColor: (rippleColor ?? Colors.grey).withAlpha(_compactRippleAlpha),
      rippleScale: customScale ?? _compactRippleScale,
      previewDuration: durationShort,
      tappableDuration: durationShort,
      focusColor: Colors.transparent,
      hoverColor: Colors.transparent,
      useFocusEffect: false,
      useHoverEffect: false,
      rippleBorderRadius: BorderRadius.circular(customRadius ?? _compactRippleRadius),
      child: child,
    );
  }

  /// Ripple étendu pour surfaces larges (cards, containers)
  static Widget addExtendedRipple({
    required Widget child,
    required VoidCallback? onTap,
    Color? rippleColor,
    bool debugMode = false,
  }) {
    if (debugMode) {
      print('🎯 ExtendedRipple - Scale: $_extendedRippleScale, Blur: $_extendedRippleBlur');
    }

    return TouchRipple(
      onTap: onTap,
      rippleColor: (rippleColor ?? Colors.grey).withAlpha(_extendedRippleAlpha),
      rippleScale: _extendedRippleScale,
      previewDuration: durationMedium,
      tappableDuration: durationMedium,
      focusColor: Colors.transparent,
      hoverColor: Colors.transparent,
      useFocusEffect: false,
      useHoverEffect: false,
      rippleBorderRadius: BorderRadius.circular(_extendedRippleRadius),
      child: child,
    );
  }

  /// Factory method pour choisir automatiquement le bon type de ripple
  static Widget adaptiveRipple({
    required Widget child,
    required VoidCallback? onTap,
    required RippleType type,
    Color? rippleColor,
    bool debugMode = false,
  }) {
    switch (type) {
      case RippleType.compact:
        return addCompactRipple(
          child: child,
          onTap: onTap,
          rippleColor: rippleColor,
          debugMode: debugMode,
        );
      case RippleType.standard:
        return addCircularRipple(
          child: child,
          onTap: onTap,
          rippleColor: rippleColor,
        );
      case RippleType.extended:
        return addExtendedRipple(
          child: child,
          onTap: onTap,
          rippleColor: rippleColor,
          debugMode: debugMode,
        );
    }
  }

  /// Durée très courte (100ms) - Pour micro-interactions
  static const Duration durationFast = Duration(milliseconds: 100);

  /// Durée courte (200ms) - Pour la plupart des interactions simples
  static const Duration durationShort = Duration(milliseconds: 200);

  /// Durée standard (300ms) - Pour les animations standards
  static const Duration durationMedium = Duration(milliseconds: 300);

  /// Durée longue (400ms) - Pour les transitions plus complexes
  static const Duration durationLong = Duration(milliseconds: 400);

  /// Durée très longue (600ms) - Pour les animations d'entrée/sortie d'écran
  static const Duration durationXLong = Duration(milliseconds: 600);

  // ANIMATIONS SPÉCIFIQUES POUR LA PAGE CATÉGORIE

  /// Durée du fade de la cover (300ms)
  static const Duration categoryFadeDuration = Duration(milliseconds: 300);

  /// Durée du fade du contenu (180ms)
  static const Duration categoryContentFadeDuration = Duration(milliseconds: 180);

  /// Délai avant de démarrer le fade du contenu (80ms après le début du fade de la cover)
  static const Duration categoryContentFadeDelay = Duration(milliseconds: 80);

  /// Durée de l'animation pour centrer un onglet (120ms)
  static const Duration categoryTabScrollDuration = Duration(milliseconds: 120);

  /// Durée de l'animation pour réinitialiser le scroll (180ms)
  static const Duration categoryScrollResetDuration = Duration(milliseconds: 180);

  /// Courbe pour l'animation de reset du scroll
  static const Curve categoryScrollResetCurve = Curves.linearToEaseOut;

  // COURBES D'ANIMATION

  /// Standard pour la plupart des animations
  static const Curve standardEasing = Curves.easeInOut;

  /// Pour les éléments qui entrent à l'écran
  static const Curve inEasing = Curves.easeOut;

  /// Pour les éléments qui sortent de l'écran
  static const Curve outEasing = Curves.easeIn;

  /// Pour les animations emphathiques (rebonds)
  static const Curve emphasisEasing = Curves.elasticOut;

  /// Pour les déplacements naturels (accélération puis décélération)
  static const Curve naturalEasing = Curves.easeInOutCubic;

  /// Pour un effet de ressort réaliste
  static const Curve springEasing = Curves.elasticOut;

  /// Courbe pour les transitions de la page catégorie (fastOutSlowIn)
  static const Curve categorySwitchCurve = Curves.fastOutSlowIn;

  // DÉLAIS

  /// Délai court pour décaler légèrement des animations
  static const Duration delayShort = Duration(milliseconds: 50);

  /// Délai moyen pour séquencer des animations
  static const Duration delayMedium = Duration(milliseconds: 150);

  /// Délai long pour séparer clairement des animations
  static const Duration delayLong = Duration(milliseconds: 300);


  // RIPPLE CONFIGURATIONS
  /// Configuration pour ripple compact (boutons petits/icônes)
  static const double _compactRippleScale = 1.0;
  static const double _compactRippleBlur = 2.0;
  static const double _compactRippleRadius = 50.0;
  static const int _compactRippleAlpha = 25;

  /// Configuration pour ripple standard (boutons normaux)
  static const double _standardRippleScale = 1.8;
  static const double _standardRippleBlur = 3.0;
  static const double _standardRippleRadius = 100.0;
  static const int _standardRippleAlpha = 20;

  /// Configuration pour ripple étendu (grandes surfaces)
  static const double _extendedRippleScale = 2.2;
  static const double _extendedRippleBlur = 4.0;
  static const double _extendedRippleRadius = 150.0;
  static const int _extendedRippleAlpha = 15;

  // MÉTHODES D'ANIMATION

  /// Crée une animation fade-in
  static Widget fadeIn({
    required Widget child,
    Duration duration = durationMedium,
    Curve curve = inEasing,
    Duration delay = Duration.zero,
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0.0, end: 1.0),
      duration: duration,
      curve: curve,
      builder: (context, value, child) => Opacity(
        opacity: value,
        child: child,
      ),
      child: child,
    );
  }

  /// Crée une animation slide-in depuis le bas
  static Widget slideInFromBottom({
    required Widget child,
    Duration duration = durationMedium,
    Curve curve = inEasing,
    double offset = 50.0,
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: offset, end: 0.0),
      duration: duration,
      curve: curve,
      builder: (context, value, child) => Transform.translate(
        offset: Offset(0, value),
        child: child,
      ),
      child: child,
    );
  }

  /// Crée une animation combinée fade-in et slide-in
  static Widget fadeSlideIn({
    required Widget child,
    Duration duration = durationMedium,
    Curve curve = inEasing,
    double offset = 30.0,
    Duration delay = Duration.zero,
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0.0, end: 1.0),
      duration: duration,
      curve: curve,
      builder: (context, value, child) => Opacity(
        opacity: value,
        child: Transform.translate(
          offset: Offset(0, offset * (1 - value)),
          child: child,
        ),
      ),
      child: child,
    );
  }


  /// Effet de ripple personnalisé pour les interactions tactiles
  static Widget withRipple({
    required Widget child,
    required VoidCallback onTap,
    Color? splashColor,
    BorderRadius? borderRadius,
    Duration duration = durationShort,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        splashColor: splashColor,
        borderRadius: borderRadius,
        child: child,
      ),
    );
  }

  /// Animation séquentielle pour les listes d'éléments
  static List<Widget> staggeredList({
    required List<Widget> children,
    Duration initialDelay = Duration.zero,
    Duration staggerDelay = delayShort,
    Duration itemDuration = durationMedium,
    Curve curve = inEasing,
    double offset = 30.0,
  }) {
    List<Widget> result = [];

    for (int i = 0; i < children.length; i++) {
      final delay = initialDelay + (staggerDelay * i);
      result.add(
        AnimatedBuilder(
          animation: Listenable.merge([]),  // Dummy animation
          builder: (context, _) {
            return FutureBuilder(
              future: Future.delayed(delay),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return fadeSlideIn(
                    child: children[i],
                    duration: itemDuration,
                    curve: curve,
                    offset: offset,
                  );
                } else {
                  return Opacity(opacity: 0, child: children[i]);
                }
              },
            );
          },
        ),
      );
    }

    return result;
  }

  // TRANSITIONS DE PAGE

  /// Transition de page avec fade
  static PageRouteBuilder<T> fadeTransition<T>({
    required Widget page,
    Duration duration = durationLong,
  }) {
    return PageRouteBuilder<T>(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionDuration: duration,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
    );
  }

  /// Transition de page avec slide depuis la droite
  static PageRouteBuilder<T> slideTransition<T>({
    required Widget page,
    Duration duration = durationLong,
  }) {
    return PageRouteBuilder<T>(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionDuration: duration,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        final tween = Tween(begin: begin, end: end);
        final offsetAnimation = animation.drive(tween);

        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
      },
    );
  }



}
