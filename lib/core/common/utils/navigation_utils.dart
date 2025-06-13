// lib/core/common/utils/navigation_utils.dart

import 'package:flutter/material.dart';
import 'package:animations/animations.dart';
import '../../../routes/route_names.dart';
import '../../../routes/app_router.dart';
import '../../domain/models/activity/search/searchable_activity.dart';
import '../../domain/models/shared/experience_item.dart';
import '../../../features/experience_detail/presentation/pages/experience_detail_page.dart';

/// ✅ NavigationUtils hybride : Hero classique + OpenContainer progressif
class NavigationUtils {

  /// ✅ NAVIGATION CLASSIQUE (qui marche) - À garder pour l'instant
  static void navigateToActivityDetail(
      BuildContext context, {
        required SearchableActivity activity,
        required String heroTag,
      }) {

    print('🚀 NAVIGATION CLASSIQUE: heroTag = "$heroTag" pour ${activity.base.name}');

    final experienceItem = ExperienceItem.activity(activity);

    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: true,
        transitionDuration: const Duration(milliseconds: 350), // ✅ 450→350ms
        reverseTransitionDuration: const Duration(milliseconds: 300), // ✅ 400→300ms

        pageBuilder: (_, __, ___) => ExperienceDetailPage(
          experienceItem: experienceItem,
          onClose: () {
            print('🔙 NAVIGATION: Fermeture detail page');
            Navigator.pop(context);
          },
          heroTag: heroTag, // ✅ Garde le heroTag pour l'instant
        ),

        // ✅ Transition simple sans conflit
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation.drive(
              CurveTween(curve: const Interval(0.0, 1.0, curve: Curves.easeInOut)),
            ),
            child: child,
          );
        },

        settings: RouteSettings(name: '${RouteNames.activityDetails}/${activity.base.id}'),
      ),
    );
  }

  /// ✅ OPENCONTAINER (pour migration future) - Pas utilisé pour l'instant
  static Widget buildOpenContainer({
    required Widget closedChild,
    required ExperienceItem experienceItem,
    double closedElevation = 0,
    double openElevation = 0,
  }) {
    return OpenContainer(
      closedElevation: closedElevation,
      openElevation: openElevation,
      transitionDuration: const Duration(milliseconds: 450),
      transitionType: ContainerTransitionType.fadeThrough,
      closedBuilder: (context, action) => closedChild,
      openBuilder: (context, action) => ExperienceDetailPage(
        experienceItem: experienceItem,
        onClose: () => Navigator.of(context).pop(),
        heroTag: 'open-container-${experienceItem.id}', // heroTag pour OpenContainer
      ),
      onClosed: (returnValue) {
        print('🔙 OPENCONTAINER: Container fermé');
      },
    );
  }

  /// ✅ LEGACY : Méthode de compatibilité
  static void navigateToActivityDetailLegacy(
      BuildContext context, {
        required String activityId,
        required String imageUrl,
        required String title,
        String? categoryName,
        String? subcategoryName,
        String? subcategoryIcon,
        String? city,
        String? heroContext,
      }) {
    Navigator.of(context).pushNamed(
      '${RouteNames.activityDetails}/$activityId',
      arguments: {
        'imageUrl': imageUrl,
        'title': title,
        'categoryName': categoryName,
        'subcategoryName': subcategoryName,
        'subcategoryIcon': subcategoryIcon,
        'city': city,
        'heroContext': heroContext,
      },
    );
  }
}