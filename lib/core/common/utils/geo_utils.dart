// lib/core/common/utils/geo_utils.dart

import 'package:maps_toolkit/maps_toolkit.dart' as maps_toolkit;
import 'geohash.dart';

class GeoUtils {
  /// Calcule le geohash d'une position
  static String calculateGeohash(double latitude, double longitude, {int precision = 4}) {
    return Geohash.encode(latitude, longitude, precision: precision);
  }

  /// Calcule la distance entre deux points en kilomètres
  static double calculateDistance(
      double startLat,
      double startLng,
      double endLat,
      double endLng,
      ) {
    final start = maps_toolkit.LatLng(startLat, startLng);
    final end = maps_toolkit.LatLng(endLat, endLng);

    // SphericalUtil.computeDistanceBetween retourne la distance en mètres
    return maps_toolkit.SphericalUtil.computeDistanceBetween(start, end) / 1000;
  }
}