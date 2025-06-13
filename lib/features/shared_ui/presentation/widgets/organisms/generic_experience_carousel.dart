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
import '../../../../../core/domain/models/activity/search/searchable_activity.dart';
import '../../../../../core/domain/models/activity/base/activity_base.dart';
import '../../../../../core/domain/ports/providers/search/activity_distance_manager_providers.dart';
import '../../../../search/application/state/city_selection_state.dart';
import '../molecules/featured_experience_card.dart';

/// Carousel générique pour afficher différentes listes d'expériences (activités + événements)
/// ✅ ÉVOLUTION vers ExperienceItem pour unifier Activities et Events
class GenericExperienceCarousel extends ConsumerWidget {
  /// Titre du carousel
  final String title;

  /// Sous-titre optionnel
  final String? subtitle;

  /// Liste des expériences à afficher
  final List<ExperienceItem>? experiences;

  /// Indique si les données sont en cours de chargement
  final bool isLoading;

  /// Fonction appelée en cas d'erreur
  final String? errorMessage;

  /// Callback pour l'action "Voir tout"
  final VoidCallback? onSeeAllPressed;

  /// Hauteur du carousel
  final double height;

  /// Nombre d'éléments en chargement
  final int loadingItemCount;

  /// Affichage de la distance optionnel
  final bool showDistance;

  /// Fonction personnalisée pour ouvrir l'expérience (optionnelle)
  final Widget Function(BuildContext, VoidCallback, ExperienceItem)? openBuilder;
  final InfiniteScrollController? scrollController;
  final String? heroPrefix;

  const GenericExperienceCarousel({
    Key? key,
    required this.title,
    this.subtitle,
    this.experiences,
    this.isLoading = false,
    this.errorMessage,
    this.onSeeAllPressed,
    this.height = 240.0,
    this.loadingItemCount = 3,
    this.openBuilder,
    this.showDistance = true,
    this.scrollController,
    this.heroPrefix,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ✅ CORRECTION : Vérifier au début si on doit afficher la section

    // 1️⃣ Toujours afficher si loading (avec skeleton)
    if (isLoading) {
      return _buildFullSection(context, ref);
    }

    // 2️⃣ Toujours afficher si erreur (avec message d'erreur)
    if (errorMessage != null) {
      return _buildFullSection(context, ref);
    }

    // 3️⃣ NOUVEAU : Masquer complètement si vide (ni titre ni espace)
    if (experiences == null || experiences!.isEmpty) {
      return const SizedBox.shrink(); // ✅ RIEN du tout si vide
    }

    // 4️⃣ Afficher la section complète si on a des données
    return _buildFullSection(context, ref);
  }

  /// ✅ NOUVEAU : Méthode pour construire la section complète (titre + contenu)
  Widget _buildFullSection(BuildContext context, WidgetRef ref) {
    final allDistances = ref.watch(activityDistancesProvider);
    final selectedCity = ref.watch(selectedCityProvider);

    return RepaintBoundary(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ✅ Titre et bouton "Voir tout"
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppDimensions.spacingS,
              vertical: AppDimensions.spacingXs,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: context.titleS,
                    ),
                  ],
                ),
                if (onSeeAllPressed != null)
                  TextButton(
                    onPressed: onSeeAllPressed,
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
          ),

          // ✅ Contenu du carousel
          Container(
            height: AppDimensions.activityCardHeight - 20,
            margin: EdgeInsets.only(bottom: AppDimensions.spacingXs),
            child: _buildContent(context, ref, allDistances, selectedCity),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(
      BuildContext context,
      WidgetRef ref,
      Map<String, double> allDistances,
      City? selectedCity,
      ) {
    final baseKey = (key is ValueKey) ? (key as ValueKey).value : key;

    // ✅ Afficher le chargement
    if (isLoading) {
      return _buildLoadingState(context);
    }

    // ✅ Afficher le message d'erreur
    if (errorMessage != null) {
      return Center(
        child: Text(
          errorMessage!,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: AppColors.error,
          ),
        ),
      );
    }

    // ✅ SUPPRIMÉ : La vérification isEmpty est maintenant dans build()
    // À ce stade, on est sûr d'avoir des expériences non vides

    // ✅ Pré-calculer les distances
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _precacheDistancesIfNeeded(experiences!, ref, allDistances);
    });

    // ✅ Carousel avec données
    return AppDimensions.buildResponsiveCarousel(
      builder: (context, constraints) {
        final cardWidth = AppDimensions.calculateCarouselCardWidth(constraints);
        final itemExtent = cardWidth + AppDimensions.spacingS;

        return RepaintBoundary(
          child: InfiniteCarousel.builder(
            key: baseKey != null ? ValueKey('${baseKey}_infinite') : null,
            controller: scrollController,
            itemCount: experiences!.length,
            itemExtent: itemExtent,
            anchor: 0.0,
            velocityFactor: 0.8,
            loop: false,
            physics: Threshold40pxPhysics(
              landingFactor: 1.7,
              triggerPx: 40.0,
              itemExtent: itemExtent,
            ),
            onIndexChanged: (index) {
              // Optionnel : tracking analytics
            },
            itemBuilder: (context, index, realIndex) {
              final experience = experiences![index];
              final distance = allDistances[experience.id] ?? experience.distance ?? 0.0;

              // ✅ GÉNÉRATION heroTag STABLE et UNIQUE
              final heroTag = heroPrefix != null
                  ? 'activity-hero-${experience.id}-$heroPrefix'
                  : 'activity-hero-${experience.id}-${title.toLowerCase().replaceAll(' ', '-')}';

              return Padding(
                padding: EdgeInsets.only(
                  left: 0,
                  right: AppDimensions.spacingS,
                ),
                child: FeaturedExperienceCard(
                  key: ValueKey(heroTag),
                  heroTag: heroTag,
                  width: cardWidth,
                  experience: experience,
                  overrideDistance: distance,
                  showDistance: showDistance,
                  isFavorite: false,
                  showSubcategory: true,
                  onTap: () async {
                    print('🎯 CAROUSEL TAP: heroTag = "$heroTag" pour ${experience.name}');

                    // ✅ NOUVEAU : Ramener la carte au centre avant navigation
                    if (scrollController != null) {
                      await scrollController!.animateToItem(
                        index,
                        duration: const Duration(milliseconds: 120),
                        curve: Curves.easeOut,
                      );
                    }

                    if (experience.isEvent) {
                      print('📅 Navigation vers événement: ${experience.name}');
                      // TODO: Navigation événement
                    } else {
                      print('🏛️ Navigation avec NavigationUtils classique');
                      NavigationUtils.navigateToActivityDetail(
                        context,
                        activity: experience.asActivity!,
                        heroTag: heroTag,
                      );
                    }
                  },
                ),
              );
            },          ),
        );
      },
    );
  }

  Widget _buildLoadingState(BuildContext context) {
    final baseKey = (key is ValueKey) ? (key as ValueKey).value : key;

    return AppDimensions.buildResponsiveCarousel(
      builder: (context, constraints) {
        final cardWidth = AppDimensions.calculateCarouselCardWidth(constraints);
        final itemExtent = cardWidth + AppDimensions.spacingS;

        return Skeletonizer(
          enabled: true,
          child: InfiniteCarousel.builder(
            key: baseKey != null ? ValueKey('${baseKey}_loading') : null,
            controller: scrollController,
            itemCount: loadingItemCount,
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
              // ✅ Générer heroTag pour le skeleton
              final skeletonHeroTag = 'skeleton-hero-$index-${baseKey ?? 'default'}';

              return Padding(
                padding: EdgeInsets.only(
                  left: 0,
                  right: AppDimensions.spacingS,
                ),
                child: FeaturedExperienceCard(
                  width: cardWidth,
                  heroTag: skeletonHeroTag,  // ✅ AJOUT obligatoire
                  experience: ExperienceItem.activity(
                    // Mock activity pour le skeleton
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
                  ),
                  showDistance: showDistance,
                  isFavorite: false,
                  showSubcategory: true,
                ),
              );
            },
          ),
        );      },
    );
  }

  /// ✅ NOUVEAU : Pré-calcule les distances SEULEMENT si nécessaire (évite boucle infinie)
  Future<void> _precacheDistancesIfNeeded(
      List<ExperienceItem> experiences,
      WidgetRef ref,
      Map<String, double> currentDistances,
      ) async {
    try {
      // ✅ GARDE : Vérifier si les distances sont déjà calculées
      final missingExperiences = experiences.where((experience) =>
      !currentDistances.containsKey(experience.id)).toList();

      if (missingExperiences.isEmpty) {
        // Toutes les distances sont déjà en cache
        return;
      }

      final distanceNotifier = ref.read(activityDistancesProvider.notifier);

      // Convertir seulement les expériences manquantes
      final experiencesData = missingExperiences.map((experience) => (
      id: experience.id,
      lat: experience.latitude,
      lon: experience.longitude,
      )).toList();

      // Utiliser la méthode batch du nouveau système
      await distanceNotifier.cacheActivitiesDistances(experiencesData);

      print('✅ EXPERIENCE MIGRATION: ${missingExperiences.length} distances calculées');
    } catch (e) {
      print('❌ EXPERIENCE MIGRATION: Erreur $e');
    }
  }
}