// lib/features/experience_detail/presentation/organisms/activity_recommendations_section.dart


import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infinite_carousel/infinite_carousel.dart';
import '../../../../core/domain/services/shared/activity_recommendation_service.dart';
import '../../../../core/domain/models/shared/experience_item.dart';
import '../../../../core/domain/models/activity/search/searchable_activity.dart';
import '../../../shared_ui/presentation/widgets/organisms/generic_experience_carousel.dart';
import '../pages/experience_detail_page.dart';
import '../../../experience_detail/application/providers/experience_recommendations_provider.dart';

/// Section complète des recommandations d'activités
///
/// Affiche 2 carousels : similaires + à proximité
class ActivityRecommendationsSection extends ConsumerWidget {
  final String activityId;
  final Widget Function(BuildContext, VoidCallback, dynamic)? openBuilder;

  const ActivityRecommendationsSection({
    Key? key,
    required this.activityId,
    this.openBuilder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        _buildSimilarActivitiesCarousel(context, ref),
        _buildNearbyActivitiesCarousel(context, ref),
      ],
    );
  }

  /// ✅ Carousel similaires avec controller stable
  Widget _buildSimilarActivitiesCarousel(BuildContext context, WidgetRef ref) {
    final similarState = ref.watch(
        experienceRecommendationsProvider(activityId, 'similar'));

    return similarState.when(
      loading: () => GenericExperienceCarousel(
        key: ValueKey('similar_loading_$activityId'),
        // ✅ CORRECTION : Pas de scrollController (utilise celui par défaut)
        title: ActivityRecommendationService.getSectionTitle('similar'),
        experiences: null,
        isLoading: true,
        loadingItemCount: 8,
        openBuilder: _buildUnifiedOpenBuilder(),
      ),
      error: (error, stack) {
        print('❌ Similar activities error: $error');
        return const SizedBox.shrink();
      },
      data: (activities) {
        if (activities.isEmpty) return const SizedBox.shrink();

        final experiences = activities
            .map((activity) => ExperienceItem.activity(activity))
            .toList();

        return GenericExperienceCarousel(
          key: ValueKey('rec-similar-$activityId'),
          title: ActivityRecommendationService.getSectionTitle('similar'),
          heroPrefix: 'rec-similar-$activityId',
          experiences: experiences,
          isLoading: false,
          openBuilder: _buildUnifiedOpenBuilder(),
        );
      },
    );
  }

  /// ✅ Carousel proximité avec controller stable
  Widget _buildNearbyActivitiesCarousel(BuildContext context, WidgetRef ref) {
    final nearbyState = ref.watch(
        experienceRecommendationsProvider(activityId, 'nearby'));

    return nearbyState.when(
      loading: () => GenericExperienceCarousel(
        key: PageStorageKey('rec-nearby-$activityId'), // ✅ SOLUTION C
        title: ActivityRecommendationService.getSectionTitle('nearby'),
        heroPrefix: 'rec-nearby',
        experiences: null,
        isLoading: true,
        loadingItemCount: 8,
        showDistance: false,
        openBuilder: _buildUnifiedOpenBuilder(),
      ),
      error: (error, stack) {
        print('❌ Nearby activities error: $error');
        return const SizedBox.shrink();
      },
      data: (activities) {
        if (activities.isEmpty) return const SizedBox.shrink();

        final experiences = activities
            .map((activity) => ExperienceItem.activity(activity))
            .toList();

        return GenericExperienceCarousel(
          key: ValueKey('nearby_$activityId'),
          title: ActivityRecommendationService.getSectionTitle('nearby'),
          heroPrefix: 'rec-nearby',
          experiences: experiences,
          isLoading: false,
          showDistance: false,
          openBuilder: _buildUnifiedOpenBuilder(),
        );
      },
    );
  }


  /// ✅ NOUVEAU - OpenBuilder unifié pour Activities + Events
  Widget Function(BuildContext, VoidCallback, dynamic)? _buildUnifiedOpenBuilder() {
    return openBuilder != null
        ? (context, action, experience) {
      // Si c'est déjà un ExperienceItem, navigation directe
      if (experience is ExperienceItem) {
        return ExperienceDetailPage(
          experienceItem: experience,
          onClose: action,
        );
      }

      // Sinon, mapper SearchableActivity vers ExperienceItem
      if (experience is SearchableActivity) {
        final experienceItem = ExperienceItem.activity(experience);
        return ExperienceDetailPage(
          experienceItem: experienceItem,
          onClose: action,
        );
      }

      // Fallback legacy
      return openBuilder!(context, action, experience);
    }
        : null;
  }
}