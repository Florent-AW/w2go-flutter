// lib/routes/app_router.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../features/welcome/presentation/pages/welcome_page.dart';
import '../features/categories/presentation/pages/category_page.dart';
import '../features/city_page/presentation/pages/city_page.dart';
import '../features/experience_detail/presentation/pages/experience_detail_page.dart';
import '../features/shared_ui/presentation/widgets/organisms/generic_bottom_bar.dart';
import '../features/home/presentation/pages/home_shell.dart';
import '../features/preload/presentation/loading_route.dart';
import '../core/domain/models/shared/experience_item.dart';
import '../core/domain/models/activity/search/searchable_activity.dart';
import '../core/domain/models/activity/base/activity_base.dart';
import '../core/domain/models/event/search/searchable_event.dart';
import '../core/domain/models/event/base/event_base.dart';
import 'route_names.dart';
import 'flow_manager.dart';

/// Route optimisée pour les Hero transitions
class HeroOptimizedRoute<T> extends PageRouteBuilder<T> {
  final Widget child;
  final Duration transitionDuration;

  HeroOptimizedRoute({
    required this.child,
    this.transitionDuration = const Duration(milliseconds: 400),
    RouteSettings? settings,
  }) : super(
    pageBuilder: (context, animation, secondaryAnimation) => child,
    settings: settings,
    transitionDuration: transitionDuration,
    reverseTransitionDuration: transitionDuration,
    // ✅ CORRECTION PLAN : Aucun FadeTransition
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      print('🎭 HERO ROUTE: Pure Hero transition (Matej Resetar approved)');
      return child; // ✅ Pas de FadeTransition = pas de conflit
    },
  );

  @override
  bool get maintainState => true;

  @override
  bool get opaque => true; // ✅ Route opaque
}

/// Gestionnaire central des routes de l'application
class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings, WidgetRef ref) {
    print('📍 Génération de route pour: ${settings.name}');

    // Extraire l'ID de catégorie si présent dans le chemin
    String? categoryId;
    if (settings.name?.startsWith('/category/') ?? false) {
      categoryId = settings.name?.split('/').last;
    }

    // Extraire l'ID d'activité si présent dans le chemin
    String? activityId;
    if (settings.name?.startsWith('/activity-details/') ?? false) {
      activityId = settings.name?.split('/').last;
    }

    // Extraire l'ID d'événement si présent dans le chemin
    String? eventId;
    if (settings.name?.startsWith('/event-details/') ?? false) {
      eventId = settings.name?.split('/').last;
    }

    // Vérifier si l'utilisateur peut accéder à cette route
    final canAccess = FlowManager.canAccessRoute(ref, settings.name ?? '');

    // Rediriger vers la page d'accueil si l'accès est refusé
    if (!canAccess && settings.name != RouteNames.welcome) {
      return MaterialPageRoute(
        builder: (_) => const WelcomePage(),
        settings: const RouteSettings(name: RouteNames.welcome),
      );
    }

    // Router standard basé sur le nom de la route
    switch (settings.name) {
      case RouteNames.welcome:
        return MaterialPageRoute(
          builder: (_) => const WelcomePage(),
          settings: settings,
        );

      case RouteNames.category:
        return MaterialPageRoute(
          builder: (_) => const HomeShell(initialTab: BottomNavTab.explorer),
          settings: settings,
        );

// ✅ NOUVEAU cas pour /city
      case RouteNames.city:
        return MaterialPageRoute(
          builder: (_) => const HomeShell(initialTab: BottomNavTab.visiter),
          settings: settings,
        );

      // ❌ DÉSACTIVÉ : Ancien système LoadingRoute
      // case '/loading':
      //   final Map args = settings.arguments as Map? ?? {};
      //   final city = args['city'];
      //   final targetPageType = args['targetPageType'] as String? ?? 'city';
      //
      //   if (city == null) {
      //     return MaterialPageRoute(
      //       builder: (_) => const WelcomePage(),
      //       settings: settings,
      //     );
      //   }
      //
      //   return MaterialPageRoute(
      //     builder: (_) => LoadingRoute(
      //       targetCity: city,
      //       targetPageType: targetPageType,
      //     ),
      //     settings: settings,
      //   );

      default:
      // Gestion des routes avec ID de catégorie
        if (settings.name?.contains('/category') ?? false) {
          return MaterialPageRoute(
            builder: (_) => const CategoryPage(),
            settings: settings,
          );
        }

        // Gestion des routes avec ID de ville
        if (settings.name?.startsWith('/city/') ?? false) {
          final cityId = settings.name?.split('/').last;
          return MaterialPageRoute(
            builder: (_) => CityPage(cityId: cityId),
            settings: settings,
          );
        }

        // Gestion des routes de détail d'événement (Navigation unifiée)
        if (settings.name?.startsWith('/event-details/') ?? false) {
          final Map<String, dynamic> args =
              settings.arguments as Map<String, dynamic>? ?? {};

          try {
            // Créer un ExperienceItem.event pour la navigation unifiée
            final searchableEvent = SearchableEvent(
              base: EventBase(
                id: eventId ?? '',
                name: args['title'] ?? 'Événement',
                description: args['description'],
                latitude: (args['latitude'] as num?)?.toDouble() ?? 0.0,
                longitude: (args['longitude'] as num?)?.toDouble() ?? 0.0,
                categoryId: args['categoryId'] ?? '',
                startDate: args['startDate'] != null
                    ? DateTime.tryParse(args['startDate']) ?? DateTime.now()
                    : DateTime.now(),
                endDate: args['endDate'] != null
                    ? DateTime.tryParse(args['endDate']) ?? DateTime.now()
                    : DateTime.now(),
                bookingRequired: args['bookingRequired'] ?? false,
                hasMultipleOccurrences: args['hasMultipleOccurrences'] ?? false,
                isRecurring: args['isRecurring'] ?? false,
              ),
              categoryName: args['categoryName'],
              subcategoryName: args['subcategoryName'],
              subcategoryIcon: args['subcategoryIcon'],
              city: args['city'],
              mainImageUrl: args['imageUrl'],
            );

            final experienceItem = ExperienceItem.event(searchableEvent);

            return HeroOptimizedRoute(
              child: Builder(
                builder: (context) => ExperienceDetailPage(
                  experienceItem: experienceItem,
                  onClose: () => Navigator.of(context).pop(),
                ),
              ),
              settings: settings,
            );
          } catch (e) {
            print('❌ Erreur création ExperienceItem.event: $e');
            return _buildErrorRoute(settings, 'Erreur lors du chargement de l\'événement');
          }
        }

        // ✅ Gestion des routes de détail d'activité (Navigation unifiée)
        if (settings.name?.startsWith('/activity-details/') ?? false) {
          final Map<String, dynamic> args =
              settings.arguments as Map<String, dynamic>? ?? {};
          final heroContext = args['heroContext'] as String?;

          try {
            // Créer un ExperienceItem.activity pour la navigation unifiée
            final searchableActivity = SearchableActivity(
              base: ActivityBase(
                id: activityId ?? '',
                name: args['title'] ?? 'Activité',
                description: args['description'],
                latitude: (args['latitude'] as num?)?.toDouble() ?? 0.0,
                longitude: (args['longitude'] as num?)?.toDouble() ?? 0.0,
                categoryId: args['categoryId'] ?? '',
                city: args['city'],
              ),
              categoryName: args['categoryName'],
              subcategoryName: args['subcategoryName'],
              subcategoryIcon: args['subcategoryIcon'],
              mainImageUrl: args['imageUrl'] ?? '',
            );

            final experienceItem = ExperienceItem.activity(searchableActivity);

            return HeroOptimizedRoute(
              child: Builder(
                builder: (context) => ExperienceDetailPage(
                  experienceItem: experienceItem,
                  onClose: () => Navigator.of(context).pop(),
                ),
              ),
              settings: settings,
            );
          } catch (e) {
            print('❌ Erreur création ExperienceItem.activity: $e');
            return _buildErrorRoute(settings, 'Erreur lors du chargement de l\'activité');
          }
        }

        // Route par défaut en cas d'erreur
        return _buildErrorRoute(settings, 'Route ${settings.name} non trouvée');
    }
  }

  /// Helper pour créer une route d'erreur standardisée
  static MaterialPageRoute _buildErrorRoute(RouteSettings settings, String message) {
    return MaterialPageRoute(
      builder: (context) => Scaffold(
        appBar: AppBar(
          title: const Text('Erreur'),
          backgroundColor: Colors.red.shade50,
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 64,
                  color: Colors.red.shade400,
                ),
                const SizedBox(height: 16),
                Text(
                  'Navigation impossible',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.red.shade700,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Retour'),
                ),
              ],
            ),
          ),
        ),
      ),
      settings: settings,
    );
  }

  /// ✅ HELPER STATIC : Créer route Event (pour usage programmatique)
  static HeroOptimizedRoute createEventRoute({
    required String eventId,
    String? imageUrl,
    String? title,
    String? categoryName,
    String? subcategoryName,
    String? subcategoryIcon,
    String? city,
    String? description,
    double? latitude,
    double? longitude,
    String? categoryId,
    DateTime? startDate,
    DateTime? endDate,
    bool? bookingRequired,
  }) {
    try {
      final searchableEvent = SearchableEvent(
        base: EventBase(
          id: eventId,
          name: title ?? 'Événement',
          description: description,
          latitude: latitude ?? 0.0,
          longitude: longitude ?? 0.0,
          categoryId: categoryId ?? '',
          startDate: startDate ?? DateTime.now(),
          endDate: endDate ?? DateTime.now(),
          bookingRequired: bookingRequired ?? false,
        ),
        categoryName: categoryName,
        subcategoryName: subcategoryName,
        subcategoryIcon: subcategoryIcon,
        city: city,
        mainImageUrl: imageUrl,
      );

      final experienceItem = ExperienceItem.event(searchableEvent);

      return HeroOptimizedRoute(
        child: ExperienceDetailPage(
          experienceItem: experienceItem,
          onClose: () {}, // ✅ Sera surchargé par l'appelant
        ),
      );
    } catch (e) {
      return HeroOptimizedRoute(
        child: Scaffold(
          body: Center(
            child: Text('Erreur lors du chargement de l\'événement: $e'),
          ),
        ),
      );
    }
  }

  /// ✅ HELPER STATIC : Créer route Activity unifiée (pour usage programmatique)
  static HeroOptimizedRoute createActivityRoute({
    required String activityId,
    String? imageUrl,
    String? title,
    String? categoryName,
    String? subcategoryName,
    String? subcategoryIcon,
    String? city,
    String? description,
    double? latitude,
    double? longitude,
    String? categoryId,
  }) {
    try {
      final searchableActivity = SearchableActivity(
        base: ActivityBase(
          id: activityId,
          name: title ?? 'Activité',
          description: description,
          latitude: latitude ?? 0.0,
          longitude: longitude ?? 0.0,
          categoryId: categoryId ?? '',
          city: city,
        ),
        categoryName: categoryName,
        subcategoryName: subcategoryName,
        subcategoryIcon: subcategoryIcon,
        mainImageUrl: imageUrl ?? '',
      );

      final experienceItem = ExperienceItem.activity(searchableActivity);

      return HeroOptimizedRoute(
        child: ExperienceDetailPage(
          experienceItem: experienceItem,
          onClose: () {}, // ✅ Sera surchargé par l'appelant
        ),
      );
    } catch (e) {
      return HeroOptimizedRoute(
        child: Scaffold(
          body: Center(
            child: Text('Erreur lors du chargement de l\'activité: $e'),
          ),
        ),
      );
    }
  }
}