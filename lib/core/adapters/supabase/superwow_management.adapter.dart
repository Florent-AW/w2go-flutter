// core/adapters/supabase/superwow_management.adapter.dart

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../domain/ports/empty_trips/superwow_management.port.dart';
import '../../domain/ports/empty_trips/route_optimization.port.dart';
import '../../domain/models/trip_designer/empty_trips/value_objects/superwow_pair.dart';
import '../../domain/models/scored_activity.dart';
import '../../domain/services/designer/empty_trips/distance_calculation.service.dart';

class SuperWowManagementAdapter implements SuperWowManagementPort {
  final SupabaseClient _supabase;
  final RouteOptimizationPort _routeOptimization;
  final DistanceCalculationService _distanceService;

  SuperWowManagementAdapter(
      this._supabase,
      this._routeOptimization,
      this._distanceService,
      );

  @override
  Future<List<ScoredActivity>> getTripSuperWows(String tripId) async {
    try {
      print('🔍 Récupération des SuperWow pour le trip $tripId');

      final response = await _supabase
          .from('trip_activities')
          .select('*, activity:activities(*)')
          .eq('trip_id', tripId)
          .eq('is_superwow', true)
          .eq('status', 'suggested');

      print('✅ ${response.length} SuperWow trouvés');

      return response.map<ScoredActivity>((data) =>
          ScoredActivity.fromJson({
            ...data['activity'],
            'total_score': data['total_score'],
            'subcategory_score': data['subcategory_score'],
            'is_superwow': data['is_superwow'],
          })
      ).toList();
    } catch (e) {
      print('❌ Erreur lors de la récupération des SuperWow: $e');
      rethrow;
    }
  }

  @override
  Future<ScoredActivity> findClosestSuperWow(
      List<ScoredActivity> superWows,
      LatLng fromPoint,
      ) async {
    try {
      print('🎯 Recherche du SuperWow le plus proche');

      ScoredActivity? closest;
      double minDistance = double.infinity;

      for (var sw in superWows) {
        final swLocation = LatLng(
            sw.activityData['latitude'],
            sw.activityData['longitude']
        );

        final distance = _distanceService.calculateDistance(fromPoint, swLocation);

        if (distance < minDistance) {
          minDistance = distance;
          closest = sw;
        }
      }

      if (closest == null) {
        throw Exception('Aucun SuperWow trouvé');
      }

      print('✅ SuperWow le plus proche trouvé: ${closest.activityData['name']}');
      return closest;
    } catch (e) {
      print('❌ Erreur lors de la recherche du SuperWow le plus proche: $e');
      rethrow;
    }
  }

  @override
  Future<List<SuperWowPair>> findTop3NearestPairs(
      String tripId,
      String baseSuperWowId,
      List<ScoredActivity> availableSuperWows,
      ) async {
    try {
      print('🔍 Recherche des 3 SuperWow les plus proches de $baseSuperWowId');

      final baseSW = availableSuperWows.firstWhere((sw) => sw.id == baseSuperWowId);
      final baseLocation = LatLng(
        baseSW.activityData['latitude'],
        baseSW.activityData['longitude'],
      );

      final pairs = <SuperWowPair>[];

      for (var sw in availableSuperWows) {
        if (sw.id == baseSuperWowId) continue;

        // Chercher d'abord en base
        final existingDistances = await _supabase
            .from('activity_distances')
            .select()
            .or('and(activity_id_1.eq.${baseSuperWowId},activity_id_2.eq.${sw.id}),'
            'and(activity_id_1.eq.${sw.id},activity_id_2.eq.${baseSuperWowId})')
            .limit(1);

        final swLocation = LatLng(
          sw.activityData['latitude'],
          sw.activityData['longitude'],
        );

        if (existingDistances.isNotEmpty) {
          print('📦 Distance en cache trouvée pour ${sw.activityData['name']}');
          final cached = existingDistances.first;

          pairs.add(SuperWowPair(
            sw1Id: baseSuperWowId,
            sw2Id: sw.id,
            sw1Location: baseLocation,
            sw2Location: swLocation,
            distanceBetween: cached['distance_meters'],
            travelTime: Duration(seconds: cached['travel_time_seconds']),
          ));
          continue;
        }

        // Sinon calculer et sauvegarder
        print('🧮 Calcul distance pour ${sw.activityData['name']}');
        final distance = _distanceService.calculateDistance(baseLocation, swLocation);
        final travelTime = _distanceService.estimateTravelTime(distance);

        // Sauvegarder avec l'ID le plus petit en premier
        final orderedIds = [baseSuperWowId, sw.id]..sort();
        await _supabase.from('activity_distances').insert({
          'activity_id_1': orderedIds[0],
          'activity_id_2': orderedIds[1],
          'distance_meters': distance.round(),
          'travel_time_seconds': travelTime,
        });

        pairs.add(SuperWowPair(
          sw1Id: baseSuperWowId,
          sw2Id: sw.id,
          sw1Location: baseLocation,
          sw2Location: swLocation,
          distanceBetween: distance.round(),
          travelTime: Duration(seconds: travelTime),
        ));
      }

      // Tri et sélection des 3 plus proches
      pairs.sort((a, b) => a.distanceBetween.compareTo(b.distanceBetween));
      final top3 = pairs.take(3).toList();

      print('✅ ${top3.length} paires de SuperWow trouvées');
      return top3;
    } catch (e) {
      print('❌ Erreur lors de la recherche des paires de SuperWow: $e');
      rethrow;
    }
  }


  @override
  Future<List<SuperWowPair>> generateOptimizedPairs(
      String tripId,
      List<ScoredActivity> superWows,
      LatLng departurePoint,
      ) async {
    try {
      print('🔄 Génération des paires optimisées de SuperWow');
      final validPairs = <SuperWowPair>[];
      final processedPairs = <String>{};  // Pour éviter les doublons

      // 1. Trier les SW par distance au point de départ
      final sortedSuperWows = [...superWows];
      sortedSuperWows.sort((a, b) {
        final aLocation = LatLng(
            a.activityData['latitude'],
            a.activityData['longitude']
        );
        final bLocation = LatLng(
            b.activityData['latitude'],
            b.activityData['longitude']
        );

        final distA = _distanceService.calculateDistance(departurePoint, aLocation);
        final distB = _distanceService.calculateDistance(departurePoint, bLocation);
        return distA.compareTo(distB);
      });

      // 2. Pour chaque SW, trouver ses paires valides
      for (final sw1 in sortedSuperWows) {
        final sw1Preferences = sw1.activityData['moment_preferences'] as Map<String, dynamic>;
        final sw1Location = LatLng(
            sw1.activityData['latitude'],
            sw1.activityData['longitude']
        );

        // 3. Déterminer les créneaux valides pour SW2
        List<String> validMoments = [];
        if (sw1Preferences['morning'] == true) {
          validMoments = ['afternoon', 'evening'];
        } else if (sw1Preferences['afternoon'] == true) {
          validMoments = ['evening'];
        } else {
          continue; // Skip si pas de créneau valide pour SW1
        }

        // 4. Filtrer et trier les SW2 potentiels
        final potentialSW2s = superWows.where((sw2) {
          if (sw2.id == sw1.id) return false;

          final sw2Preferences = sw2.activityData['moment_preferences'] as Map<String, dynamic>;
          return validMoments.any((moment) => sw2Preferences[moment] == true);
        }).toList();

        // 5. Trier par distance à SW1
        potentialSW2s.sort((a, b) {
          final aLocation = LatLng(
              a.activityData['latitude'],
              a.activityData['longitude']
          );
          final bLocation = LatLng(
              b.activityData['latitude'],
              b.activityData['longitude']
          );

          final distA = _distanceService.calculateDistance(sw1Location, aLocation);
          final distB = _distanceService.calculateDistance(sw1Location, bLocation);
          return distA.compareTo(distB);
        });

        // 6. Prendre les 3 plus proches en évitant les doublons
        for (final sw2 in potentialSW2s.take(3)) {
          final sw2Location = LatLng(
              sw2.activityData['latitude'],
              sw2.activityData['longitude']
          );

          // Vérifier les doublons
          final pairKey = [sw1.id, sw2.id]..sort();
          final pairId = pairKey.join('-');
          if (processedPairs.contains(pairId)) continue;
          processedPairs.add(pairId);

          // Calculer distance et temps de trajet
          final distance = _distanceService.calculateDistance(sw1Location, sw2Location);
          final travelTime = _distanceService.estimateTravelTime(distance);

          validPairs.add(SuperWowPair(
            sw1Id: sw1.id,
            sw2Id: sw2.id,
            sw1Location: sw1Location,
            sw2Location: sw2Location,
            distanceBetween: distance.round(),
            travelTime: Duration(seconds: travelTime),
          ));
        }
      }

      print('✅ ${validPairs.length} paires valides générées');
      return validPairs;

    } catch (e) {
      print('❌ Erreur génération paires optimisées: $e');
      rethrow;
    }
  }

}