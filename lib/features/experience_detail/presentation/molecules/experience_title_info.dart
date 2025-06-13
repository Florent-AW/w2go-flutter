// lib/features/experience_detail/presentation/molecules/experience_title_info.dart

import 'package:flutter/material.dart';
import '../../../../../core/domain/models/shared/experience_item.dart';
import '../../../../../core/theme/app_dimensions.dart';
import '../../../../../core/theme/app_typography.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/components/atoms/activity_distance_badge.dart';
import '../../../../../features/shared_ui/presentation/widgets/molecules/activity_category_label.dart';
import '../../../../../features/shared_ui/presentation/widgets/atoms/activity_tag.dart';

/// Composant unifié pour afficher titre + infos d'une expérience (Activity ou Event)
/// Remplace la logique manuelle dans ExperienceIntroSection
class ExperienceTitleInfo extends StatelessWidget {
  final ExperienceItem experienceItem;
  final dynamic details; // ✅ NOUVEAU : ExperienceDetails pour récupérer l'adresse
  final String? fallbackTitle;
  final String? fallbackCity;
  final String? fallbackCategoryName;
  final String? fallbackSubcategoryName;
  final String? fallbackSubcategoryIcon;

  const ExperienceTitleInfo({
    Key? key,
    required this.experienceItem,
    this.details, // ✅ NOUVEAU
    this.fallbackTitle,
    this.fallbackCity,
    this.fallbackCategoryName,
    this.fallbackSubcategoryName,
    this.fallbackSubcategoryIcon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final effectiveTitle = experienceItem.name.isNotEmpty
        ? experienceItem.name
        : (fallbackTitle ?? 'Chargement...');

    final effectiveCity = experienceItem.city ?? fallbackCity;
    final effectiveCategoryName = experienceItem.categoryName ?? fallbackCategoryName;
    final effectiveSubcategoryName = experienceItem.subcategoryName ?? fallbackSubcategoryName;
    final effectiveSubcategoryIcon = experienceItem.subcategoryIcon ?? fallbackSubcategoryIcon;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ✅ Catégorie - Réutilise molecule existante
        if (effectiveCategoryName != null)
          ActivityCategoryLabel(
            category: effectiveCategoryName,
            subcategoryIcon: effectiveSubcategoryIcon,
            subcategoryName: effectiveSubcategoryName,
          ),

        SizedBox(height: AppDimensions.spacingXs),

        // ✅ Titre - Atom Text avec style unifié
        _buildTitleAtom(effectiveTitle),

        // ✅ Localisation + Distance - Molecule réutilisable
        if (effectiveCity != null) ...[
          SizedBox(height: AppDimensions.spacingXxxs),
          _buildLocationRow(effectiveCity),

          // ✅ Distance Badge - Atom réutilisé
          SizedBox(height: AppDimensions.spacingXxs),
          Align(
            alignment: Alignment.centerLeft,
            child: ActivityDistanceBadge(
              activityId: experienceItem.id,
              fallbackDistance: experienceItem.distance,
            ),
          ),
        ],

        // ✅ Tags - Collection d'atoms
        SizedBox(height: AppDimensions.spacingM),
        _buildTagsRow(),
      ],
    );
  }

  /// ✅ ATOM: Titre unifié
  Widget _buildTitleAtom(String title) {
    return Text(
      title,
      style: AppTypography.title(isDark: false),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  /// ✅ MOLECULE: Ligne de localisation (Icon + Text) avec ville + adresse
  Widget _buildLocationRow(String city) {
    // ✅ CORRECTION : Utiliser pattern when() pour récupérer l'adresse
    String? address;
    if (details != null) {
      address = details.when(
        activity: (activityDetails) => activityDetails.address,
        event: (eventDetails) => eventDetails.address, // ✅ Correct pour Events
      );
    }

    // ✅ Combinaison ville + adresse comme dans ActivityTitleInfo original
    final locationText = [city, address]
        .where((item) => item != null && item.isNotEmpty)
        .join(', ');

// ✅ DEBUG approfondi
    print('🏠 LOCATION DEBUG DETAILLÉ:');
    print('  isEvent: ${experienceItem.isEvent}');
    print('  city: $city');
    print('  details != null: ${details != null}');
    if (details != null) {
      details.when(
        activity: (activityDetails) {
          print('  === ACTIVITY DETAILS ===');
          print('  address: ${activityDetails.address}');
          print('  name: ${activityDetails.name}');
        },
        event: (eventDetails) {
          print('  === EVENT DETAILS ===');
          print('  address: ${eventDetails.address}');
          print('  name: ${eventDetails.name}');
          print('  city: ${eventDetails.city}');
          print('  postalCode: ${eventDetails.postalCode}');
          print('  contactPhone: ${eventDetails.contactPhone}');
        },
      );
    }

    return Row(
      children: [
        Icon(
          Icons.location_on_outlined,
          size: AppDimensions.iconSizeS,
          color: AppColors.primary,
        ),
        SizedBox(width: AppDimensions.spacingXxs),
        Expanded(
          child: Text(
            locationText, // ✅ Ville + adresse combinées
            style: AppTypography.caption(
              isDark: false,
              isSecondary: true,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  /// ✅ MOLECULE: Row de tags scrollable
  Widget _buildTagsRow() {
    final tags = _buildTags();

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: tags.map((tag) =>
            Padding(
              padding: const EdgeInsets.only(right: 4),
              child: ActivityTag(label: tag), // ✅ Atom réutilisé
            )
        ).toList(),
      ),
    );
  }

  /// ✅ Factory pattern pour les tags selon le type d'expérience
  List<String> _buildTags() {
    final tags = <String>[];

    if (experienceItem.isEvent) {
      // Tags spécifiques aux Events
      tags.add('Événement');

      if (experienceItem.subcategoryName != null) {
        tags.add(experienceItem.subcategoryName!);
      }

      if (experienceItem.kidFriendly) {
        tags.add('Famille');
      }

      if (experienceItem.bookingRequired == true) {
        tags.add('Réservation');
      }

      if (experienceItem.isWow) {
        tags.add('Coup de cœur');
      }
    } else {
      // Tags pour Activities (logique existante)
      tags.addAll(['Activité en famille', 'Populaire']);

      if (experienceItem.isWow) {
        tags.add('Coup de cœur');
      }
    }

    return tags;
  }
}