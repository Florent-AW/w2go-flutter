// lib/features/shared_ui/presentation/widgets/organisms/generic_experience_carousel.dart

import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:infinite_carousel/infinite_carousel.dart';
import 'package:flutter/scheduler.dart';
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

/// Carousel générique pour afficher différentes listes d'expériences (activités + événements)
/// ✅ ÉVOLUTION vers ExperienceItem pour unifier Activities et Events
class GenericExperienceCarousel extends ConsumerStatefulWidget {
  /// [tous les paramètres existants restent identiques]
  final String title;
  final String? subtitle;
  final List<ExperienceItem>? experiences;
  final bool isLoading;
  final String? errorMessage;
  final VoidCallback? onSeeAllPressed;
  final double height;
  final int loadingItemCount;
  final bool showDistance;
  final Widget Function(BuildContext, VoidCallback, ExperienceItem)? openBuilder;
  final InfiniteScrollController? scrollController;
  final String? heroPrefix;
  final bool isPartial;
  final VoidCallback? onRequestCompletion;
  final VoidCallback? onLoadMore;

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
    this.isPartial = false,
    this.onRequestCompletion,
    this.onLoadMore,
  }) : super(key: key);

  @override
  ConsumerState<GenericExperienceCarousel> createState() => _GenericExperienceCarouselState();
}

class _GenericExperienceCarouselState extends ConsumerState<GenericExperienceCarousel> {
  Timer? _completionTimer;
  int _lastTriggerIndex = -1;

  @override
  void initState() {
    super.initState();

    // ✅ Timer immédiat si déjà partiel dès initState (ancien comportement)
    if (widget.isPartial && widget.onRequestCompletion != null) {
      print('🔄 TIMER T1: Démarrage immédiat pour ${widget.title}');
      _scheduleCompletion();
    }
  }

  @override
  void dispose() {
    _completionTimer?.cancel();
    super.dispose();
  }

  /// ✅ NOUVEAU : Planifier la complétion automatique
  void _scheduleCompletion() {
    _completionTimer = Timer(const Duration(milliseconds: 1500), () {
      if (mounted && widget.onRequestCompletion != null) {
        print('🔄 COMPLÉTION T1: Déclenchement pour ${widget.title}');
        widget.onRequestCompletion!();
      }
    });
  }

  /// Détecte si on doit charger plus d'items - SEUIL ADAPTATIF
  void _checkLoadMore(int currentIndex) {
    if (widget.onLoadMore == null) return;

    final totalItems = widget.experiences?.length ?? 0;
    if (totalItems == 0) return;

    // ✅ CORRECTION 1 : Seuil adaptatif au lieu de fixe
    final triggerPosition = (totalItems / 2).floor(); // Moitié du chunk courant

    // Éviter triggers multiples au même index
    if (currentIndex <= _lastTriggerIndex) return;

    final shouldTrigger = currentIndex >= (totalItems - triggerPosition);

    if (shouldTrigger) {
      print('🔄 T2 LAZY LOADING: Trigger à l\'index $currentIndex/$totalItems (seuil adaptatif: $triggerPosition)');
      _lastTriggerIndex = currentIndex;
      widget.onLoadMore!();
    }
  }


  @override
  Widget build(BuildContext context) {  // ✅ Enlever WidgetRef ref du build
    // 1️⃣ Toujours afficher si loading (avec skeleton)
    if (widget.isLoading) {  // ✅ Ajouter widget.
      return _buildFullSection(context);
    }

    // 2️⃣ Toujours afficher si erreur (avec message d'erreur)
    if (widget.errorMessage != null) {  // ✅ Ajouter widget.
      return _buildFullSection(context);
    }

    // 3️⃣ NOUVEAU : Masquer complètement si vide (ni titre ni espace)
    if (widget.experiences == null || widget.experiences!.isEmpty) {  // ✅ Ajouter widget.
      return const SizedBox.shrink();
    }

    // 4️⃣ Afficher la section complète si on a des données
    return _buildFullSection(context);
  }

  /// ✅ NOUVEAU : Méthode pour construire la section complète (titre + contenu)
  Widget _buildFullSection(BuildContext context) {
    final allDistances = ref.watch(activityDistancesProvider);
    final selectedCity = ref.watch(selectedCityProvider);

    return RepaintBoundary(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ✅ Titre et bouton "Voir tout"
          Padding(
            padding: EdgeInsets.only(
              left: AppDimensions.spacingS,
              right: AppDimensions.spacingS,
              top: 0, // ✅ Top padding très réduit
              bottom: AppDimensions.spacingXs, // ✅ Bottom normal
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.title,  // ✅ Ajouter widget.
                      style: context.title,
                    ),
                  ],
                ),
                if (widget.onSeeAllPressed != null)  // ✅ Ajouter widget.
                  TextButton(
                    onPressed: widget.onSeeAllPressed,  // ✅ Ajouter widget.
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
    final baseKey = (widget.key is ValueKey) ? (widget.key as ValueKey).value : widget.key;

    // ✅ Afficher le chargement
    if (widget.isLoading) {
      return _buildLoadingState(context);
    }


    // ✅ Afficher le message d'erreur
    if (widget.errorMessage != null) {
      return Center(
        child: Text(
          widget.errorMessage!,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: AppColors.error,
          ),
        ),
      );
    }

    // À ce stade, on est sûr d'avoir des expériences non vides

    // Pré-calculer les distances avec garde
    if (widget.experiences?.isNotEmpty == true) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) { // ✅ Garde mounted
          _precacheDistancesIfNeeded(widget.experiences!, ref, allDistances);
        }
      });
    }

    // ✅ Carousel avec données
    // ✅ NOUVEAU : Utiliser InfinitePagingCarousel au lieu d'InfiniteCarousel
    return AppDimensions.buildResponsiveCarousel(
      builder: (context, constraints) {
        final cardWidth = AppDimensions.calculateCarouselCardWidth(constraints);

        return InfinitePagingCarousel<ExperienceItem>(
          key: baseKey != null ? ValueKey('${baseKey}_infinite') : null,
          items: widget.experiences!,
          height: AppDimensions.activityCardHeight - 20,
          scrollController: widget.scrollController,
          // ✅ NOUVEAU : Props pour lazy loading
          onLoadMore: widget.onLoadMore,
          hasMore: true, // TODO: sera connecté au PaginationController
          isLoading: false, // TODO: sera connecté au PaginationController
          lookAhead: 10,
          precacheAhead: 3, // ✅ NOUVEAU : 3 images d'avance
          getImageUrl: (experience) => experience.mainImageUrl, // ✅ NOUVEAU : Extraire URL
          itemBuilder: (context, experience, index) {
            final distance = allDistances[experience.id] ?? experience.distance ?? 0.0;

            // ✅ GÉNÉRATION heroTag STABLE et UNIQUE
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
              onTap: () async {
                print('🎯 CAROUSEL TAP: heroTag = "$heroTag" pour ${experience.name}');

                // ✅ NOUVEAU : Ramener la carte au centre avant navigation
                if (widget.scrollController != null) {
                  await widget.scrollController!.animateToItem(
                    index,
                    duration: const Duration(milliseconds: 120),
                    curve: Curves.easeOut,
                  );
                }

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
                  print('🏛️ Navigation avec NavigationUtils classique');
                  NavigationUtils.navigateToActivityDetail(
                    context,
                    activity: experience.asActivity!,
                    heroTag: heroTag,
                  );
                }
              },
            );
          },
        );
      },
    );
  }

  Widget _buildLoadingState(BuildContext context) {
    final baseKey = (widget.key is ValueKey) ? (widget.key as ValueKey).value : widget.key;

    return AppDimensions.buildResponsiveCarousel(
      builder: (context, constraints) {
        final cardWidth = AppDimensions.calculateCarouselCardWidth(constraints);
        final itemExtent = cardWidth + AppDimensions.spacingS;

        return Skeletonizer(
          enabled: true,
          child: InfiniteCarousel.builder(
            key: baseKey != null ? ValueKey('${baseKey}_loading') : null,
            controller: widget.scrollController,
            itemCount: widget.loadingItemCount,
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
                  showDistance: widget.showDistance,
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

      // Utiliser la méthode batch du nouveau système
      await distanceNotifier.cacheActivitiesDistances(experiencesData);

      print('✅ DISTANCE CACHE: ${missingExperiences.length} distances calculées');
    } catch (e) {
      print('❌ DISTANCE CACHE: Erreur $e');
    }
  }

  @override
  void didUpdateWidget(covariant GenericExperienceCarousel oldWidget) {
    super.didUpdateWidget(oldWidget);

    // ✅ RESET _lastTriggerIndex quand les items augmentent (loadMore réussi)
    final oldItemCount = oldWidget.experiences?.length ?? 0;
    final newItemCount = widget.experiences?.length ?? 0;

    if (newItemCount > oldItemCount) {
      print('🔄 T2 RESET: Items passés de $oldItemCount → $newItemCount, reset trigger index');
      _lastTriggerIndex = -1; // ✅ Reset pour permettre nouveaux triggers
    }

    // ✅ Détecter le passage false → true pour isPartial
    if (!oldWidget.isPartial && widget.isPartial && widget.onRequestCompletion != null) {
      print('🔄 TIMER T1: Détection false→true pour ${widget.title}');
      _scheduleCompletion();
    }
  }

}