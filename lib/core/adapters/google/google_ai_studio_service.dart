// core/adapters/google/google_ai_studio_service.dart


import 'package:dio/dio.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../domain/services/google_services_config.dart';
import '../../common/exceptions/google_api_exception.dart';


class GoogleAIStudioService {
  final Dio _dio = Dio();
  final GoogleServicesConfig _config;

  GoogleAIStudioService(this._config);

  // lib/core/adapters/google/google_ai_studio_service.dart

  Future<Map<String, dynamic>> callMapsDirections({
    required LatLng origin,
    required LatLng destination,
    List<LatLng>? waypoints,
  }) async {
    try {
      final url = 'https://maps.googleapis.com/maps/api/directions/json';
      final params = _buildParams(
        origin: origin,
        destination: destination,
        waypoints: waypoints,
      );

      print('🔑 API Key utilisée: ${_config.aiStudioApiKey}');
      print('🚀 Appel Directions API via AI Studio');
      print('🌐 URL complète: $url');
      print('📝 Paramètres: $params');

      final response = await _dio.get(url, queryParameters: params);

      print('📥 Réponse reçue: ${response.statusCode}');
      print('📄 Contenu de la réponse: ${response.data}');

      return response.data;
    } catch (e) {
      String errorMessage = 'Erreur lors de l\'appel à l\'API Google Directions';

      if (e is DioError) {
        errorMessage += ': ${e.response?.statusCode}, ${e.response?.data}';
        print('🌐 Erreur réseau: ${e.message}');
        if (e.response != null) {
          print('📄 Données de réponse: ${e.response?.data}');
        }
      } else {
        errorMessage += ': $e';
      }

      print('❌ $errorMessage');
      throw GoogleAPIException(errorMessage);
    }
  }

  void _validateLatLng(LatLng point, String pointName) {
    if (point.latitude < -90 || point.latitude > 90) {
      throw ArgumentError(
          'Latitude invalide pour $pointName: ${point.latitude}');
    }
    if (point.longitude < -180 || point.longitude > 180) {
      throw ArgumentError(
          'Longitude invalide pour $pointName: ${point.longitude}');
    }
  }

  Map<String, String> _buildParams({
    required LatLng origin,
    required LatLng destination,
    List<LatLng>? waypoints,
  }) {
    return {
      'origin': '${origin.latitude},${origin.longitude}',  // était inversé
      'destination': '${destination.latitude},${destination.longitude}',  // était inversé
      if (waypoints != null && waypoints.isNotEmpty)
        'waypoints': 'optimize:true|${waypoints.map((w) => '${w.latitude},${w.longitude}').join('|')}',
      'key': _config.aiStudioApiKey,
    };
  }
}