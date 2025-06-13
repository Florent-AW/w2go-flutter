// lib\core\common\utils\geohash.dart

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:maps_toolkit/maps_toolkit.dart' as maps_toolkit;
import 'package:polyline_codec/polyline_codec.dart';
import 'package:dart_geohash/dart_geohash.dart';

class Geohash {
  static const List<String> _base32 = [
    '0','1','2','3','4','5','6','7','8','9',
    'b','c','d','e','f','g','h','j','k','m',
    'n','p','q','r','s','t','u','v','w','x',
    'y','z'
  ];

  /// Encode une position géographique en geohash
  /// @param lat - Latitude
  /// @param lon - Longitude
  /// @param precision - Précision du geohash (1-12)
  static String encode(double lat, double lon, {int precision = 5}) {
    // Utilisation de la bibliothèque dart_geohash pour assurer la cohérence
    // Note: la bibliothèque attend (longitude, latitude) dans cet ordre
    final geoHasher = GeoHasher();
    return geoHasher.encode(lon, lat, precision: precision);
  }

  /// Version originale conservée pour référence (décommentez si nécessaire)
  /*
  static String encodeOriginal(double lat, double lon, {int precision = 5}) {
    if (lat < -90.0 || lat > 90.0) {
      throw ArgumentError('Latitude must be between -90 and 90');
    }
    if (lon < -180.0 || lon > 180.0) {
      throw ArgumentError('Longitude must be between -180 and 180');
    }
    if (precision < 1 || precision > 12) {
      throw ArgumentError('Precision must be between 1 and 12');
    }

    var latMin = -90.0;
    var latMax = 90.0;
    var lonMin = -180.0;
    var lonMax = 180.0;

    var bits = 0;
    var bitsTotal = 0;
    var hashValue = '';

    while (hashValue.length < precision) {
      if (bitsTotal % 2 == 0) {
        var mid = (lonMin + lonMax) / 2;
        if (lon >= mid) {
          bits = (bits << 1) + 1;
          lonMin = mid;
        } else {
          bits <<= 1;
          lonMax = mid;
        }
      } else {
        var mid = (latMin + latMax) / 2;
        if (lat >= mid) {
          bits = (bits << 1) + 1;
          latMin = mid;
        } else {
          bits <<= 1;
          latMax = mid;
        }
      }

      bitsTotal++;
      if (bitsTotal == 5) {
        hashValue += _base32[bits];
        bits = 0;
        bitsTotal = 0;
      }
    }

    return hashValue;
  }
  */

  /// Convertit une polyline en liste de geohash5 traversés
  static List<String> getGeohashesFromPolyline(String encodedPolyline) {
    try {
      print('🗺️ Décodage de la polyline');

      // Décoder la polyline en liste de points avec une précision de 5
      final decodedPoints = PolylineCodec.decode(encodedPolyline, precision: 5);
      final points = decodedPoints.map((point) => LatLng(point[0].toDouble(), point[1].toDouble())).toList();

      print('📍 ${points.length} points extraits de la polyline');

      // Convertir chaque point en geohash5 et éliminer les doublons
      final geohashes = <String>{};
      final geoHasher = GeoHasher();
      for (final point in points) {
        final geohash = geoHasher.encode(point.longitude, point.latitude, precision: 5);
        geohashes.add(geohash);
      }

      print('🔍 ${geohashes.length} geohash5 uniques trouvés');
      return geohashes.toList();
    } catch (e) {
      print('❌ Erreur lors de la conversion polyline → geohash: $e');
      rethrow;
    }
  }
}