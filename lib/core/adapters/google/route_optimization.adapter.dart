 // lib/core/adapters/google/route_optimization.adapter.dart

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../domain/ports/empty_trips/route_optimization.port.dart';
import '../../domain/services/google_services_config.dart';
import '../../common/exceptions/route_optimization_exceptions.dart';
import '../../common/utils/geohash.dart';
import 'google_ai_studio_service.dart';

 class RouteOptimizationAdapter implements RouteOptimizationPort {
   final SupabaseClient _supabase;
   final GoogleServicesConfig _config;
   final GoogleAIStudioService? _googleService;

   RouteOptimizationAdapter(this._supabase, this._config, this._googleService);

   @override
   Future<Map<String, dynamic>> getOptimizedRoute(
       LatLng origin,
       LatLng destination,
       List<LatLng> waypoints,
       ) async {
     try {
       print('🗺️ Récupération du trajet pour ${_formatLatLng(origin)} → ${_formatLatLng(destination)}');
       print('🗺️ Détails de la requête d\'optimisation:');
       print('📍 Origine: ${_formatLatLng(origin)}');
       print('🎯 Destination: ${_formatLatLng(destination)}');
       if (waypoints.isNotEmpty) {
         print('🚩 Waypoints:');
         waypoints.forEach((wp) => print('  - ${_formatLatLng(wp)}'));
       }

       _checkGoogleService();

       final response = await _googleService!.callMapsDirections(
         origin: origin,
         destination: destination,
         waypoints: waypoints,
       );

       print('📥 Réponse API:');
       print('  - Status: ${response['status']}');
       print('  - Routes trouvées: ${response['routes']?.length ?? 0}');

       if (response['status'] != 'OK') {
         print('❌ Détails de l\'erreur:');
         print('  - Status: ${response['status']}');
         print('  - Message d\'erreur: ${response['error_message'] ?? 'Non spécifié'}');
         throw RouteNotFoundException('Aucun itinéraire trouvé: ${response['status']}');
       }

       _checkRouteResponse(response);

       final route = response['routes'][0];
       final legs = route['legs'] as List;

       // Calculer les totaux
       int totalDistance = 0;
       int totalDuration = 0;

       for (var leg in legs) {
         totalDistance += leg['distance']['value'] as int;
         totalDuration += leg['duration']['value'] as int;
       }

       print('📊 Distance totale: ${totalDistance}m, Durée totale: ${totalDuration}s');

       return {
         'status': 'OK',
         'polyline': route['overview_polyline']['points'],
         'traversed_geohashes': Geohash.getGeohashesFromPolyline(route['overview_polyline']['points']),
         'distance': totalDistance,
         'duration': totalDuration,
         'waypoint_order': route['waypoint_order'] ?? [],
       };
     } catch (e) {
       print('❌ Erreur optimisation route: $e');
       rethrow;
     }
   }

   @override
   Future<Duration> getTravelTime(
       LatLng origin,
       LatLng destination,
       {DateTime? departureTime}
       ) async {
     try {
       print('🚗 Calcul du temps de trajet entre ${_formatLatLng(origin)} → ${_formatLatLng(destination)}');

       _checkGoogleService();

       final response = await _googleService!.callMapsDirections(
         origin: origin,
         destination: destination,
       );

       _checkRouteResponse(response);

       final duration = response['routes'][0]['legs'][0]['duration']['value'];
       print('⏱️ Durée calculée: ${(duration / 60).round()} minutes');

       return Duration(seconds: duration);
     } catch (e) {
       print('❌ Erreur calcul temps de trajet: $e');
       throw TravelTimeCalculationException('Erreur lors du calcul du temps de trajet: $e');
     }
   }

   @override
   Future<Map<String, dynamic>> evaluateDetour(
       LatLng origin,
       LatLng destination,
       LatLng detourPoint,
       Duration maxDetourTime,
       ) async {
     try {
       print('📍 Évaluation détour via ${_formatLatLng(detourPoint)}');

       _checkGoogleService();

       // Route directe
       final directRoute = await getOptimizedRoute(origin, destination, []);
       final directDuration = directRoute['duration'] as int;

       // Route avec détour
       final detourRoute = await getOptimizedRoute(origin, destination, [detourPoint]);
       final detourDuration = detourRoute['duration'] as int;

       final additionalTime = detourDuration - directDuration;
       final isFeasible = Duration(seconds: additionalTime) <= maxDetourTime;

       return {
         'status': 'OK',
         'additionalTime': additionalTime,
         'feasible': isFeasible,
         'detourRoute': detourRoute,
       };
     } catch (e) {
       print('❌ Erreur évaluation détour: $e');
       throw RouteNotFoundException('Erreur lors de l\'évaluation du détour: $e');
     }
   }

   // Méthodes utilitaires privées
   void _checkGoogleService() {
     if (_googleService == null) {
       throw GoogleAPIException('Service Google AI Studio non initialisé');
     }
   }

   void _checkRouteResponse(Map<String, dynamic> response) {
     if (response['status'] != 'OK') {
       throw RouteNotFoundException('Aucun itinéraire trouvé: ${response['status']}');
     }
   }

   String _formatLatLng(LatLng point) {
     return '${point.latitude.toStringAsFixed(6)},${point.longitude.toStringAsFixed(6)}';
   }

   int _calculateTotalDistance(List legs) {
     return legs.fold(0, (sum, leg) => sum + (leg['distance']['value'] as int));
   }

   int _calculateTotalDuration(List legs) {
     return legs.fold(0, (sum, leg) => sum + (leg['duration']['value'] as int));
   }
 }