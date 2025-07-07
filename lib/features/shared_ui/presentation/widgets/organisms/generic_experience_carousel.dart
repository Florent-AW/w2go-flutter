// lib/features/shared_ui/presentation/widgets/organisms/generic_experience_carousel.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:infinite_carousel/infinite_carousel.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_dimensions.dart';
import '../../../../../core/theme/app_typography.dart';
import '../../../../../core/theme/components/physics/threshold_40px_physics.dart';
import '../../../../../core/domain/models/shared/experience_item.dart';
import '../../../../../core/domain/models/shared/city_model.dart';
import '../../../../../core/common/utils/navigation_utils.dart';
import '../../../../../core/theme/components/molecules/infinite_paging_carousel.dart';
import '../../../../../core/domain/models/activity/search/searchable_activity.dart';
import '../../../../../core/domain/models/activity/base/activity_base.dart';
import '../../../../../core/domain/ports/providers/search/activity_distance_manager_providers.dart';
import '../../../../search/application/state/city_selection_state.dart';
import '../molecules/featured_experience_card.dart';

/// Widget métier pour afficher des carrousels d'expériences (activités + événements)
///
/// Responsabilités:
/// - Interface complète (titre, état, callbacks métier)
/// - Gestion des états métier (loading, error, empty)
/// - Intégration domain ExperienceItem
/// - Délégation technique à InfinitePagingCarousel
///
/// La logique T0/T1/T2 est gérée par les wrappers parents via PaginationController
class GenericExperienceCarousel extends ConsumerStatefulWidget {
  /// Titre du carrousel
  final String title;

  /// Sous-titre optionnel
  final String? subtitle;

  /// Liste des expériences à afficher
  final List<ExperienceItem>? experiences;

  /// Indique un chargement en cours
  final bool isLoading;

  /// Message d'erreur à afficher
  final String? errorMessage;

  /// Callback pour le bouton "Voir tout"
  final VoidCallback? onSeeAllPressed;

  /// Callback pour le lazy loading T2 (délégué à InfinitePagingCarousel)
  final VoidCallback? onLoadMore;

  /// Hauteur du carrousel
  final double height;

  /// Afficher les distances
  final bool showDistance;

  /// Builder personnalisé pour l'ouverture d'expérience
  final Widget Function(BuildContext, VoidCallback, ExperienceItem)? openBuilder;

  /// Contrôleur de scroll optionnel
  final InfiniteScrollController? scrollController;

  /// Préfixe pour les hero tags (éviter conflits)
  final String? heroPrefix;

  const GenericExperienceCarousel({
    Key? key,
    required this.title,
    this.subtitle,
    this.experiences,
    this.isLoading = false,
    this.errorMessage,
    this.onSeeAllPressed,
    this.onLoadMore,
    this.height = 240.0,
    this.showDistance = true,
    this.openBuilder,
    this.scrollController,
    this.heroPrefix,
  }) : super(key: key);

  @override
  ConsumerState<GenericExperienceCarousel> createState() => _GenericExperienceCarouselState();
}

class _GenericExperienceCarouselState extends ConsumerState<GenericExperienceCarousel> {
  static const int _skeletonItemCount = 3;

  @override
  Widget build(BuildContext context) {
    // 1️⃣ Toujours afficher si loading (avec skeleton)
    if (widget.isLoading) {
      return _buildFullSection(context);
    }

    // 2️⃣ Toujours afficher si erreur (avec message d'erreur)
    if (widget.errorMessage != null) {
      return _buildFullSection(context);
    }

    // 3️⃣ Masquer complètement si vide (ni titre ni espace)
    if (widget.experiences == null || widget.experiences!.isEmpty) {
      return const SizedBox.shrink();
    }

    // 4️⃣ Afficher la section complète si on a des données
    return _buildFullSection(context);
  }

  /// Construit la section complète (titre + contenu)
  Widget _buildFullSection(BuildContext context) {
    final allDistances = ref.watch(activityDistancesProvider);
    final selectedCity = ref.watch(selectedCityProvider);

    return RepaintBoundary(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header avec titre et bouton "Voir tout"
          _buildHeader(context),

          // Contenu du carousel
          Container(
            height: AppDimensions.activityCardHeight - 20,
            child: _buildContent(context, allDistances, selectedCity),
          ),
        ],
      ),
    );
  }

  /// Construit le header avec titre et bouton "Voir tout"
  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: AppDimensions.spacingS,
        right: AppDimensions.spacingS,
        top: 0,
        bottom: AppDimensions.spacingXs,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.title,
                style: context.title,
              ),
              if (widget.subtitle != null)
                Text(
                  widget.subtitle!,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.neutral600,
                  ),
                ),
            ],
          ),
          if (widget.onSeeAllPressed != null)
            TextButton(
              onPressed: widget.onSeeAllPressed,
              child: Text(
                'Voir tout',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
    );
  }

  /// Construit le contenu du carousel (data, loading, ou erreur)
  Widget _buildContent(
      BuildContext context,
      Map<String, double> allDistances,
      City? selectedCity,
      ) {
    final baseKey = (widget.key is ValueKey) ? (widget.key as ValueKey).value : widget.key;

    // État de chargement
    if (widget.isLoading) {
      return _buildLoadingState(context, baseKey);
    }

    // État d'erreur
    if (widget.errorMessage != null) {
      return _buildErrorState(context);
    }

    // Pré-calculer les distances si nécessaire
    if (widget.experiences?.isNotEmpty == true) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _precacheDistancesIfNeeded(widget.experiences!, allDistances);
        }
      });
    }

    // Carousel avec données - Utilise InfinitePagingCarousel
    return AppDimensions.buildResponsiveCarousel(
      builder: (context, constraints) {
        final cardWidth = AppDimensions.calculateCarouselCardWidth(constraints);

        return InfinitePagingCarousel<ExperienceItem>(
          key: baseKey != null ? ValueKey('${baseKey}_infinite') : null,
          items: widget.experiences!,
          height: AppDimensions.activityCardHeight - 20,
          scrollController: widget.scrollController,

          // Configuration lazy loading T2
          onLoadMore: widget.onLoadMore,
          hasMore: true, // Sera connecté au PaginationController dans les wrappers
          isLoading: false, // Sera connecté au PaginationController dans les wrappers
          lookAhead: 10,

          // Configuration pré-cache images
          precacheAhead: 3,
          getImageUrl: (experience) => experience.mainImageUrl,

          // Builder des items
          itemBuilder: (context, experience, index) {
            final distance = allDistances[experience.id] ?? experience.distance ?? 0.0;

            // Génération heroTag stable et unique
            final heroTag = widget.heroPrefix != null
                ? 'activity-hero-${experience.id}-${widget.heroPrefix}'
                : 'activity-hero-${experience.id}-${widget.title.toLowerCase().replaceAll(' ', '-')}';

            return FeaturedExperienceCard(
              key: ValueKey(heroTag),
              heroTag: heroTag,
              width: cardWidth,
              experience: experience,
              overrideDistance: distance,
              showDistance: widget.showDistance,
              isFavorite: false,
              showSubcategory: true,
              onTap: () => _handleExperienceTap(context, experience, heroTag, index),
            );
          },
        );
      },
    );
  }

  /// Gère le tap sur une expérience
  Future<void> _handleExperienceTap(
      BuildContext context,
      ExperienceItem experience,
      String heroTag,
      int index,
      ) async {
    print('🎯 CAROUSEL TAP: heroTag = "$heroTag" pour ${experience.name}');

    // Ramener la carte au centre avant navigation
    if (widget.scrollController != null) {
      await widget.scrollController!.animateToItem(
        index,
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOut,
      );
    }

    // Navigation selon le type d'expérience
    if (experience.isEvent) {
      print('📅 Navigation vers événement: ${experience.name}');
      if (experience.asEvent != null) {
        NavigationUtils.navigateToEventDetail(
          context,
          event: experience.asEvent!,
          heroTag: heroTag,
        );
      } else {
        print('❌ CAROUSEL TAP: experience.asEvent est null !');
      }
    } else {
      print('🏛️ Navigation vers activité: ${experience.name}');
      NavigationUtils.navigateToActivityDetail(
        context,
        activity: experience.asActivity!,
        heroTag: heroTag,
      );
    }
  }

  /// Construit l'état de chargement avec skeletons
  Widget _buildLoadingState(BuildContext context, dynamic baseKey) {
    return AppDimensions.buildResponsiveCarousel(
      builder: (context, constraints) {
        final cardWidth = AppDimensions.calculateCarouselCardWidth(constraints);
        final itemExtent = cardWidth + AppDimensions.spacingS;

        return Skeletonizer(
          enabled: true,
          child: InfiniteCarousel.builder(
            key: baseKey != null ? ValueKey('${baseKey}_loading') : null,
            controller: widget.scrollController,
            itemCount: _skeletonItemCount,
            itemExtent: itemExtent,
            anchor: 0.0,
            velocityFactor: 0.8,
            loop: false,
            physics: Threshold40pxPhysics(
              landingFactor: 1.7,
              triggerPx: 40.0,
              itemExtent: itemExtent,
            ),
            itemBuilder: (context, index, realIndex) {
              // Génération heroTag pour le skeleton
              final skeletonHeroTag = 'skeleton-hero-$index-${baseKey ?? 'default'}';

              return Padding(
                padding: EdgeInsets.only(
                  left: 0,
                  right: AppDimensions.spacingS,
                ),
                child: FeaturedExperienceCard(
                  width: cardWidth,
                  heroTag: skeletonHeroTag,
                  experience: _createSkeletonExperience(index),
                  showDistance: widget.showDistance,
                  isFavorite: false,
                  showSubcategory: true,
                ),
              );
            },
          ),
        );
      },
    );
  }

  /// Construit l'état d'erreur
  Widget _buildErrorState(BuildContext context) {
    return Center(
      child: Text(
        widget.errorMessage!,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: AppColors.error,
        ),
      ),
    );
  }

  /// Crée une expérience skeleton pour le loading
  ExperienceItem _createSkeletonExperience(int index) {
    return ExperienceItem.activity(
      SearchableActivity(
        base: ActivityBase(
          id: 'skeleton-$index',
          name: 'Expérience skeleton ${index + 1}',
          description: 'Description exemple',
          latitude: 0.0,
          longitude: 0.0,
          categoryId: '',
          city: 'Ville exemple',
          bookingRequired: false,
        ),
        categoryName: 'Culture',
        subcategoryName: 'Exemple',
        subcategoryIcon: 'castle',
        distance: 5.0,
        mainImageUrl: 'https://picsum.photos/400/240',
      ),
    );
  }

  /// Pré-calcule les distances SEULEMENT si nécessaire (évite boucle infinie)
  Future<void> _precacheDistancesIfNeeded(
      List<ExperienceItem> experiences,
      Map<String, double> currentDistances,
      ) async {
    try {
      // Vérifier si les distances sont déjà calculées
      final missingExperiences = experiences.where((experience) =>
      !currentDistances.containsKey(experience.id)).toList();

      if (missingExperiences.isEmpty) {
        // Toutes les distances sont déjà en cache - SORTIR
        return;
      }

      print('🔄 DISTANCE CACHE: ${missingExperiences.length} nouvelles distances à calculer');

      final distanceNotifier = ref.read(activityDistancesProvider.notifier);

      // Convertir seulement les expériences manquantes
      final experiencesData = missingExperiences.map((experience) => (
      id: experience.id,
      lat: experience.latitude,
      lon: experience.longitude,
      )).toList();

      // Utiliser la méthode batch du système de distances
      await distanceNotifier.cacheActivitiesDistances(experiencesData);

      print('✅ DISTANCE CACHE: ${missingExperiences.length} distances calculées');
    } catch (e) {
      print('❌ DISTANCE CACHE: Erreur $e');
    }
  }
}