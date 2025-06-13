// lib/core/domain/services/empty_trips/available_time_calculation.service.dart

import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../ports/empty_trips/available_time_calculation.port.dart';
import '../../../../common/constants/trip_constants.dart';
import '../../../../common/exceptions/calculation_exception.dart';
import '../../../../common/enums/trip_enums.dart';
import '../../../models/trip_designer/empty_trips/empty_daily_trip.dart';

/// Service dédié au calcul du temps disponible pour un emptyTrip, 
/// intégrant la durée des SW, le temps de trajet principal, et les pauses repas.
class AvailableTimeCalculationService implements AvailableTimeCalculationPort {
  final SupabaseClient _supabase;

  AvailableTimeCalculationService(this._supabase);

  /// Calcule le temps disponible global pour un [emptyTripId] donné, 
  /// sur un créneau [activityHours], selon [travelStyle] et [superWowIds].
  Future<int> calculateAvailableTime({
    required String emptyTripId,
    required Map<String, dynamic> activityHours,
    required String travelStyle,
    required List<String> superWowIds,
  }) async {
    try {
      // 1) Récupérer la durée totale du emptyTrip (trajet principal)
      print('📊 Activity Hours: $activityHours'); // Debug input
      final totalDuration = await _getTotalDuration(emptyTripId);
      print('⏱ Total Duration: $totalDuration');

      // 2) Calculer la durée des SW (selon travelStyle)
      final swDuration = await calculateSuperWowDuration(
        superWowIds: superWowIds,
        travelStyle: travelStyle,
      );
      print('⭐ SW Duration: $swDuration');

      // 3) Calculer les pauses repas (mealBreaks)
      final mealBreaks = calculateMealBreaksDuration(activityHours, travelStyle);
      print('🍽 Meal Breaks: $mealBreaks');

      // 4) Calculer les heures totales (start -> end)
      final totalActivityHours = _calculateTotalActivityHours(activityHours);
      print('🕒 Total Hours: $totalActivityHours');

      // 5) Formule finale
      final timeLeft = totalActivityHours - totalDuration - swDuration - mealBreaks;
      print('✨ Time Left: $timeLeft');

      print('🕒 Calcul timeLeft => '
          'totalActivityHours=$totalActivityHours, '
          'totalDuration=$totalDuration, '
          'swDuration=$swDuration, '
          'mealBreaks=$mealBreaks, '
          'timeLeft=$timeLeft');

      return timeLeft;
    } catch (e) {
      throw CalculationException('Error calculating available time: $e');
    }
  }

  /// Calcule le temps de repas en minutes (midi + soir éventuellement).
  /// Se base sur l’intervalle [activityHours] (start, end) 
  /// et des slots de repas dans [TripConstants].
  @override
  int calculateMealBreaksDuration(Map<String, dynamic> activityHours, String travelStyle) {
    final baseDuration = TripConstants.mealDurationByStyle[travelStyle] ?? TripConstants.mealDurationByStyle['balanced']!;

    int breaks = 0;
    if (_slotIncludesLunch(activityHours)) breaks += baseDuration;
    if (_slotIncludesDinner(activityHours)) breaks += baseDuration;
    return breaks;
  }

  /// Récupère le [total_duration] depuis la table `empty_daily_trips`.
  /// Peut être `0` si non trouvé ou s'il s'agit d'un half_day minimal.
  Future<int> _getTotalDuration(String emptyTripId) async {
    final response = await _supabase
        .from('empty_daily_trips')
        .select('total_duration')
        .eq('id', emptyTripId)
        .single() as Map<String, dynamic>?;

    if (response == null) {
      print('⚠️ Aucune donnée pour emptyDailyTrip $emptyTripId. Retourne 0.');
      return 0;
    }

    final duration = (response['total_duration'] ?? 0) / 60;  // Conversion secondes -> minutes
    return (duration is int ? duration : duration.round());
  }

  /// Convertit [activityHours] (start, end) en minutes totales. 
  /// Ex: "10:00" -> 600, "18:00" -> 1080 => total 480 minutes.
  int _calculateTotalActivityHours(Map<String, dynamic> activityHours) {
    final startStr = activityHours['start'] as String;
    final endStr = activityHours['end'] as String;

    final startMins = _convertTimeStringToMinutes(startStr);
    final endMins = _convertTimeStringToMinutes(endStr);

    final total = endMins - startMins;
    if (total < 0) {
      // Si jamais l'utilisateur a inversé start/end, on peut retourner 0 ou throw
      print('⚠️ Intervalle horaire négatif ($startStr -> $endStr). Retourne 0.');
      return 0;
    }
    return total;
  }

  /// Vérifie si le créneau couvre au moins [12h-13h].
  bool _slotIncludesLunch(Map<String, dynamic> activityHours) {
    final start = activityHours['start'] as String;
    final end = activityHours['end'] as String;

    final activityStart = _convertTimeStringToMinutes(start);
    final activityEnd = _convertTimeStringToMinutes(end);
    final lunchStart = TripConstants.mealTimeSlots['lunch']!.$1 * 60; // 12 * 60
    final lunchEnd = TripConstants.mealTimeSlots['lunch']!.$2 * 60;   // 13 * 60

    // On veut s'assurer que l'intervalle [activityStart, activityEnd] 
    // recouvre [lunchStart, lunchEnd].
    return activityStart <= lunchStart && activityEnd >= lunchEnd;
  }

  /// Vérifie si le créneau couvre au moins [19h-20h].
  bool _slotIncludesDinner(Map<String, dynamic> activityHours) {
    final start = activityHours['start'] as String;
    final end = activityHours['end'] as String;

    final activityStart = _convertTimeStringToMinutes(start);
    final activityEnd = _convertTimeStringToMinutes(end);
    final dinnerStart = TripConstants.mealTimeSlots['dinner']!.$1 * 60;  // 19*60
    final dinnerEnd = TripConstants.mealTimeSlots['dinner']!.$2 * 60;    // 20*60

    return activityStart <= dinnerStart && activityEnd >= dinnerEnd;
  }

  int _convertTimeStringToMinutes(String timeString) {
    final parts = timeString.split(':');
    final hour = int.parse(parts[0]);
    final minute = int.parse(parts[1]);
    return hour * 60 + minute;
  }

  /// Calcule la durée totale des SW en minutes (selon min/max)
  /// et le [travelStyle] (relax=prend max, active=min, balanced=moyenne).
  Future<int> calculateSuperWowDuration({
    required List<String> superWowIds,
    required String travelStyle,
  }) async {
    try {
      // Si la liste est vide, retourner 0
      if (superWowIds.isEmpty) return 0;

      // Utiliser in() plutôt que des eq() multiples
      final response = await _supabase
          .from('activities')
          .select('min_duration_minutes, max_duration_minutes')
          .inFilter('id', superWowIds);

      if (response == null || (response as List).isEmpty) {
        throw CalculationException('No activities found for given SuperWow IDs');
      }

      // Calculer la durée totale
      int totalDuration = 0;
      for (final activity in response) {
        final minDuration = (activity['min_duration_minutes'] as num).toInt();
        final maxDuration = (activity['max_duration_minutes'] as num).toInt();

        // Utiliser le style pour déterminer la durée
        totalDuration += TravelStyle.values
            .firstWhere((e) => e.name == travelStyle)
            .getDurationMinutes(minDuration, maxDuration);
      }

      return totalDuration;
    } catch (e) {
      throw CalculationException('Error calculating SW duration: $e');
    }
  }

  Future<Map<DateTime, int>> calculateAvailableTimeForEmptyTrip({
    required EmptyDailyTrip emptyTrip,
    required Map<String, Map<String, String?>> dailyHours,
    required String travelStyle,
  }) async {
    Map<DateTime, int> timeByDate = {};

    for (var entry in dailyHours.entries) {
      final date = DateTime.parse(entry.key);
      final hours = entry.value;

      if (hours['start'] == null || hours['end'] == null) continue;

      // Vérifier compatibilité type/durée
      final isDailyTypeCompatible = _checkDailyTypeCompatibility(hours, emptyTrip.type);
      if (!isDailyTypeCompatible) continue;

      final timeLeft = await calculateAvailableTime(
        emptyTripId: emptyTrip.id,
        activityHours: {
          'start': hours['start']!,
          'end': hours['end']!,
        },
        travelStyle: travelStyle,
        superWowIds: emptyTrip.sw2Id != null ? [emptyTrip.sw1Id, emptyTrip.sw2Id!] : [emptyTrip.sw1Id],
      );

      timeByDate[date] = timeLeft;
    }

    return timeByDate;
  }

  bool _checkDailyTypeCompatibility(Map<String, String?> hours, DailyTripType tripType) {
    final startTime = _convertTimeStringToMinutes(hours['start']!);
    final endTime = _convertTimeStringToMinutes(hours['end']!);
    final duration = endTime - startTime;

    return tripType == DailyTripType.full_day ? duration >= 360 : duration < 360; // 6h seuil
  }


}
