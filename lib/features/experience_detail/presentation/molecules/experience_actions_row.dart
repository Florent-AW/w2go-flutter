// lib/features/experience_detail/presentation/molecules/experience_actions_row.dart

import 'package:flutter/material.dart';
import '../../../../core/domain/models/shared/experience_item.dart';
import '../../../../core/domain/models/shared/experience_details_model.dart';
import '../../../../core/domain/services/shared/external_launcher_service.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/components/atoms/action_button.dart';

/// Composant unifié pour les actions d'une expérience (Activity ou Event)
/// Remplace ActionButtonsRow spécifique aux Activities
class ExperienceActionsRow extends StatelessWidget {
  final ExperienceItem experienceItem;
  final ExperienceDetails? details;

  const ExperienceActionsRow({
    Key? key,
    required this.experienceItem,
    this.details,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // ✅ Factory pattern - Extraction des données selon le type
    final actionData = _extractActionData();

    // ✅ NOUVEAU : Factory pour le bouton navigation
    final navigationConfig = _getNavigationButtonConfig(actionData);

    return Row(
      children: [
        // ✅ Bouton Navigation avec config dynamique
        Expanded(
          child: ActionButton(
            icon: navigationConfig.icon,        // ✅ Icône selon factory
            label: navigationConfig.label,      // ✅ Label selon factory
            onPressed: () => _onNavigationTap(context, actionData),
          ),
        ),

        SizedBox(width: AppDimensions.spacingS),

        // ✅ Bouton Téléphone unifié (unchanged)
        Expanded(
          child: ActionButton(
            icon: Icons.phone_outlined,
            label: 'Appeler',
            onPressed: actionData.contactPhone != null
                ? () => _onPhoneTap(context, actionData.contactPhone!)
                : null,
          ),
        ),

        SizedBox(width: AppDimensions.spacingS),

        // ✅ Bouton Site web unifié (unchanged)
        Expanded(
          child: ActionButton(
            icon: Icons.language_outlined,
            label: 'Site web',
            onPressed: actionData.contactWebsite != null
                ? () => _onWebsiteTap(context, actionData.contactWebsite!)
                : null,
          ),
        ),
      ],
    );
  }

  /// ✅ Factory pattern - Extraction des données selon Activity vs Event
  _ActionData _extractActionData() {
    if (details != null) {
      return details!.when(
        activity: (activityDetails) => _ActionData(
          latitude: activityDetails.latitude,
          longitude: activityDetails.longitude,
          name: activityDetails.name,
          googlePlaceId: activityDetails.googlePlaceId,
          address: activityDetails.address, // ✅ NOUVEAU
          contactPhone: activityDetails.contactPhone,
          contactWebsite: activityDetails.contactWebsite,
        ),
        event: (eventDetails) => _ActionData(
          latitude: eventDetails.latitude,
          longitude: eventDetails.longitude,
          name: eventDetails.name,
          googlePlaceId: eventDetails.googlePlaceId,
          address: eventDetails.address, // ✅ NOUVEAU pour Events
          contactPhone: eventDetails.contactPhone,
          contactWebsite: eventDetails.contactWebsite,
        ),
      );
    } else {
      // Fallback ExperienceItem
      return _ActionData(
        latitude: experienceItem.latitude,
        longitude: experienceItem.longitude,
        name: experienceItem.name,
        googlePlaceId: null,
        address: null, // ✅ Pas dispo dans ExperienceItem
        contactPhone: null,
        contactWebsite: null,
      );
    }
  }

  // ✅ Actions unifiées (même logique que ActionButtonsRow)
  void _onNavigationTap(BuildContext context, _ActionData data) async {
    try {
      await ExternalLauncherService.openMap(
        data.latitude,
        data.longitude,
        data.name,
        context,
        placeId: data.googlePlaceId,
        address: data.address,
      );
    } catch (e) {
      _showError(context, e.toString());
    }
  }

  Future<void> _onPhoneTap(BuildContext context, String phone) async {
    try {
      await ExternalLauncherService.openPhone(phone);
    } catch (e) {
      _showError(context, e.toString());
    }
  }

  Future<void> _onWebsiteTap(BuildContext context, String website) async {
    try {
      await ExternalLauncherService.openCustomTab(context, website);
    } catch (e) {
      _showError(context, e.toString());
    }
  }

  /// ✅ Factory pour déterminer le type de bouton navigation selon l'expérience
  ({IconData icon, String label}) _getNavigationButtonConfig(_ActionData actionData) {
    if (experienceItem.isEvent) {
      // 🎯 Events : Toujours "Itinéraire" (navigation directe)
      return (icon: Icons.navigation, label: 'Itinéraire');
    } else {
      // 🎯 Activities : "Fiche Maps" par défaut, "Itinéraire" seulement si confirmé sans googlePlaceId
      if (details != null && !actionData.hasGooglePlaceId) {
        // ✅ Détails chargés ET confirmé qu'il n'y a pas de googlePlaceId
        return (icon: Icons.navigation, label: 'Itinéraire');
      } else {
        // ✅ Par défaut pour Activities (transition + googlePlaceId présent)
        return (icon: Icons.map_outlined, label: 'Fiche Maps');
      }
    }
  }

  void _showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.error,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(8),
        duration: const Duration(seconds: 3),
      ),
    );
  }
}

/// ✅ Value Object pour les données d'action unifiées
class _ActionData {
  final double latitude;
  final double longitude;
  final String name;
  final String? googlePlaceId;
  final String? address;
  final String? contactPhone;
  final String? contactWebsite;

  const _ActionData({
    required this.latitude,
    required this.longitude,
    required this.name,
    this.googlePlaceId,
    this.address,
    this.contactPhone,
    this.contactWebsite,
  });

  bool get hasGooglePlaceId => googlePlaceId != null && googlePlaceId!.isNotEmpty;
}

