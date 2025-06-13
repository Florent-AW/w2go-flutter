// lib/core/domain/services/shared/external_launcher_service.dart

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart' as url_launcher;
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart' as custom_tabs;
import 'package:map_launcher/map_launcher.dart';
import '../../../../core/theme/app_colors.dart';

class ExternalLauncherService {
  static Future<void> openMap(
      double? latitude,
      double? longitude,
      String title,
      BuildContext context,
      {String? placeId, String? address} // ✅ NOUVEAU paramètre
      ) async {
    try {
      // 1️⃣ Priorité 1 : Google Place ID (fiche complète)
      if (placeId != null && placeId.isNotEmpty) {
        final encodedTitle = Uri.encodeComponent(title);
        final googlePlaceUrl = 'https://www.google.com/maps/search/?api=1'
            '&query=$encodedTitle'
            '&query_place_id=$placeId';
        await openCustomTab(context, googlePlaceUrl);
        return;
      }

      // 2️⃣ Priorité 2 : Adresse complète (meilleure que GPS)
      if (address != null && address.isNotEmpty) {
        final encodedAddress = Uri.encodeComponent('$title, $address');
        final googleMapsUrl = 'https://www.google.com/maps/search/?api=1&query=$encodedAddress';
        await openCustomTab(context, googleMapsUrl);
        return;
      }

      // 3️⃣ Priorité 3 : Coordonnées GPS (fallback)
      final availableMaps = await MapLauncher.installedMaps;
      if (availableMaps.isNotEmpty && latitude != null && longitude != null) {
        await availableMaps.first.showDirections(
          destination: Coords(latitude, longitude),
          destinationTitle: title,
        );
      } else {
        throw 'Impossible d\'ouvrir la navigation';
      }
    } catch (e) {
      throw 'Erreur lors de l\'ouverture de la navigation : $e';
    }
  }



  static Future<void> openPhone(String phoneNumber) async {
    try {
      final Uri uri = Uri(
        scheme: 'tel',
        path: phoneNumber.replaceAll(RegExp(r'[^\d+]'), ''),
      );

      if (await url_launcher.canLaunchUrl(uri)) {
        await url_launcher.launchUrl(uri);
      } else {
        throw 'Aucune application de téléphone disponible';
      }
    } catch (e) {
      throw 'Erreur lors de l\'appel : $e';
    }
  }

  static Future<void> openCustomTab(BuildContext context, String url) async {
    try {
      final Uri uri = Uri.parse(url.startsWith('http') ? url : 'https://$url');

      await custom_tabs.launchUrl(
        uri,
        customTabsOptions: custom_tabs.CustomTabsOptions(
          colorSchemes: custom_tabs.CustomTabsColorSchemes.defaults(
            toolbarColor: AppColors.neutral900,
          ),
          shareState: custom_tabs.CustomTabsShareState.on,
          urlBarHidingEnabled: true,
          showTitle: true,
        ),
        safariVCOptions: custom_tabs.SafariViewControllerOptions(
          preferredBarTintColor: AppColors.neutral900,
          preferredControlTintColor: Colors.white,
          barCollapsingEnabled: true,
          dismissButtonStyle: custom_tabs.SafariViewControllerDismissButtonStyle.close,
        ),
      );
    } catch (e) {
      throw 'Erreur lors de l\'ouverture du site web : $e';
    }
  }
}