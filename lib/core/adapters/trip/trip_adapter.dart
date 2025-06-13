// core/adapters/supabase/trip_adapter.dart

import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/ports/trip_port.dart';
import '../../domain/models/trip_designer/trip/trip_model.dart';
import '../../common/exceptions/exceptions.dart';
import '../../common/exceptions/trip_exception.dart';
import '../../domain/models/shared/city_model.dart';
import '../../domain/services/trip_service.dart';
import '../../domain/use_cases/create_trip_use_case.dart';

class TripAdapter implements TripPort {
  final SupabaseClient _supabase;
  final TripService _tripService;

  TripAdapter(SupabaseClient supabase) :
        _supabase = supabase,
        _tripService = TripService(supabase);

  @override
  Future<Trip> createTrip(CreateTripParams params, City departureCity) async {
    try {
      return await _tripService.saveTrip(
        userId: params.userId,
        title: params.title,
        startDate: params.startDate,
        endDate: params.endDate,
        travelGroup: params.travelGroup,
        activityHours: params.activityHours,
        departureCity: departureCity,
        travelStyle: params.travelStyle,
        preferredMoment: params.preferredMoment,
        dailyBudget: params.dailyBudget,
      );
    } on TripException {
      rethrow;
    } catch (e) {
      throw TripCreationException('Échec de la création du voyage: $e');
    }
  }

  @override
  Future<Trip> getTrip(String tripId) async {
    try {
      print('🔍 Tentative de récupération du voyage: $tripId');

      final response = await _supabase
          .from('trips')
          .select('''
          *,
          cities!trips_departure_city_id_fkey (*)
        ''')
          .eq('id', tripId)
          .single();

      print('📦 Réponse Supabase: $response');

      if (response == null) {
        print('❌ Aucun voyage trouvé');
        throw TripNotFoundException('Voyage non trouvé avec l\'ID: $tripId');
      }

      // Renommer la clé pour correspondre à notre modèle
      if (response['cities'] != null) {
        response['departure_city'] = response['cities'];
        response.remove('cities');
      }

      try {
        final trip = Trip.fromJson(response);
        print('✅ Voyage trouvé et parsé: ${trip.title}');
        return trip;
      } catch (e) {
        print('❌ Erreur lors du parsing du voyage: $e');
        throw TripNotFoundException('Erreur lors du parsing du voyage: $e');
      }
    }
    catch (e) {
      print('❌ Erreur dans getTrip: $e');
      throw TripNotFoundException('Erreur lors de la récupération du voyage: $e');
    }
  }

  @override
  Future<List<Trip>> getTripsForUser(String userId) async {
    try {
      return await _tripService.getTripsForUser(userId);
    } catch (e) {
      throw DataException('User trips fetch failed: $e');
    }
  }
}