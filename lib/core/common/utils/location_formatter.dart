// lib/core/common/utils/location_formatter.dart

import '../../domain/models/location/place_details.dart';

/// Classe utilitaire pour le formatage des adresses et lieux
class LocationFormatter {
  /// Formate une adresse complète pour l'affichage
  static String formatAddress(PlaceDetails details) {
    final List<String> parts = [];

    if (details.name.isNotEmpty) {
      parts.add(details.name);
    }

    if (details.locality != null && details.locality!.isNotEmpty) {
      parts.add(details.locality!);
    }

    if (details.administrativeArea != null && details.administrativeArea!.isNotEmpty) {
      parts.add(details.administrativeArea!);
    }

    return parts.join(', ');
  }

  /// Formate une distance en mètres pour l'affichage
  static String formatDistance(double distanceInMeters) {
    if (distanceInMeters < 1000) {
      return '${distanceInMeters.round()} m';
    } else {
      final double km = distanceInMeters / 1000;
      return '${km.toStringAsFixed(1)} km';
    }
  }

  /// Extrait le nom principal d'un lieu (généralement la ville ou commune)
  static String extractMainName(PlaceDetails details) {
    return details.locality ?? details.name;
  }
}