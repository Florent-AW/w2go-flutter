// lib/core/common/utils/distance_formatter.dart

/// Utilitaire pour formater les distances en labels catégorisés
class DistanceFormatter {
  /// Convertit une distance en mètres en label de catégorie
  ///
  /// Exemple: 4200 mètres -> "- de 5 km"
  static String formatDistanceLabel(double? distanceInMeters) {
    if (distanceInMeters == null) return "";

    // Conversion en km
    final distanceKm = distanceInMeters / 1000;

    // Détermination du label approprié
    if (distanceKm < 1) return "< 1 km";
    if (distanceKm < 5) return "< 5 km";
    if (distanceKm < 10) return "< 10 km";
    if (distanceKm < 20) return "< 20 km";
    if (distanceKm < 30) return "< 30 km";
    if (distanceKm < 50) return "< 50 km";
    if (distanceKm < 75) return "< 75 km";
    if (distanceKm < 100) return "< 100 km";
    if (distanceKm < 150) return "< 150 km";
    if (distanceKm < 200) return "< 200 km";
    if (distanceKm < 250) return "< 200 km";
    if (distanceKm < 300) return "< 300 km";

    return "> 300 km";
  }

  /// Formatage précis des distances (pour d'autres cas d'usage)
  static String formatPreciseDistance(double? meters) {
    if (meters == null) return "";

    if (meters < 1000) {
      return '${meters.round()} m';
    } else if (meters < 10000) {
      return '${(meters / 1000).toStringAsFixed(1)} km';
    } else {
      return '~${(meters / 1000).round()} km';
    }
  }
}