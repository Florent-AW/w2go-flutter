// core/adapters/processing/filter_processing_adapter.dart

import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/services/travel_time_service.dart';
import '../../domain/ports/activity_hours_port.dart';
import '../../domain/models/trip_designer/processing/activity_processing_model.dart';
import '../../domain/models/trip_designer/trip/trip_model.dart';
import '../../domain/designer/filters/filter_chain.dart';
import '../../domain/designer/filters/travel_group_filter.dart';
import '../../domain/designer/filters/time_filter.dart';

class FilterProcessingAdapter {
  final ActivityHoursPort _hoursAdapter;
  final SupabaseClient _supabase;  // Ajout pour TravelTimeService

  FilterProcessingAdapter(this._hoursAdapter, this._supabase);  // Mise à jour constructeur

  Future<List<ActivityForProcessing>> getFilteredActivities(
      String tripId,
      List<ActivityForProcessing> activities,
      Trip trip
      ) async {
    final filterChain = FilterChain()
      ..addFilter(TravelGroupFilter(trip.travelGroup))
      ..addFilter(TimeFilter(
        tripStartDate: trip.startDate,
        tripEndDate: trip.endDate,
        dailyHours: trip.activityHours.daily_hours,  // Au lieu de tripActivityHours
        hoursService: _hoursAdapter,
        departureGeohash5: trip.departureGeohash5 ?? '',  // Ajout
        travelTimeService: TravelTimeService(_supabase),  // Ajout
      ));

    return await filterChain.apply(activities);
  }
}