// lib/core/domain/services/trip_service.dart

import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/trip_designer/trip/trip_model.dart';
import '../models/shared/city_model.dart';
import '../../common/exceptions/exceptions.dart';
import '../../common/exceptions/trip_exception.dart';
import '../../common/enums/trip_enums.dart';

class TripService {
  final SupabaseClient _supabase;

  TripService(this._supabase);

  Future<Trip?> findTrip(String tripId) async {
    try {
      final response = await _supabase
          .from('trips')
          .select('*, departure_city(*)')
          .eq('id', tripId)
          .maybeSingle();

      if (response == null) return null;
      return Trip.fromJson(response);
    } catch (e) {
      throw DataException('Erreur lors de la recherche du voyage: $e');
    }
  }

  Future<Trip> saveTrip({
    required String userId,
    required String title,
    required DateTime startDate,
    required DateTime endDate,
    required TravelGroup travelGroup,
    required ActivityHours activityHours,
    required City departureCity,
    required TravelStyle travelStyle,
    required PreferredMoment preferredMoment,
    double? dailyBudget,
  }) async {
    try {
      print('TripService - Début de saveTrip');
      // Afficher les données qu'on va sauvegarder
      print('Données à sauvegarder:');
      final tripData = {
        'user_id': userId,
        'title': title,
        'start_date': startDate.toIso8601String(),
        'end_date': endDate.toIso8601String(),
        'departure_city_id': departureCity.id,
        'departure_geohash5': departureCity.geohash5,
        'travel_group': travelGroup.toJson(),
        'activity_hours': activityHours.toJson(),
        'daily_budget': dailyBudget,
        'travel_style': travelStyle.name,
        'preferred_moment': preferredMoment.name,
        'metadata': _generateMetadata(startDate),
        'status': 'planned',
        'trip_duration': endDate.difference(startDate).inDays + 1,
      };
      print('TripData: $tripData');

      // Modification ici : on ne récupère pas departure_city
      final response = await _supabase
          .from('trips')
          .insert(tripData)
          .select()
          .single();

      // On récupère la ville séparément si nécessaire
      final cityResponse = await _supabase
          .from('cities')
          .select()
          .eq('id', departureCity.id)
          .single();

      // On combine les données
      var tripResponse = response;
      tripResponse['departure_city'] = cityResponse;

      return Trip.fromJson(tripResponse);
    } catch (e, stackTrace) {
      print('Erreur dans saveTrip: $e');
      print('Stack trace: $stackTrace');
      throw TripCreationException('Erreur lors de la sauvegarde du voyage: $e');
    }
  }

  Map<String, dynamic> _generateMetadata(DateTime startDate) {
    return {
      'season': _getSeason(startDate),
      'transport_mode': 'car',  // Par défaut pour l'instant
    };
  }

  String _getSeason(DateTime date) {
    int month = date.month;
    if (month >= 3 && month <= 5) return 'spring';
    if (month >= 6 && month <= 8) return 'summer';
    if (month >= 9 && month <= 11) return 'autumn';
    return 'winter';
  }

  Future<List<Trip>> getTripsForUser(String userId) async {
    try {
      final response = await _supabase
          .from('trips')
          .select('*, departure_city(*)')
          .eq('user_id', userId);
      return response.map((json) => Trip.fromJson(json)).toList();
    } catch (e) {
      throw DataException('Erreur lors de la récupération des voyages: $e');
    }
  }

}