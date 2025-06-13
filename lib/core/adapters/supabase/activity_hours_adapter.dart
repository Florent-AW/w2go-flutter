// core/adapters/supabase/activity_hours_adapter.dart

import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/ports/activity_hours_port.dart';
import '../../domain/models/opening_days.dart';
import '../../common/exceptions/exceptions.dart';

class ActivityHoursAdapter implements ActivityHoursPort {
  final SupabaseClient _client;  // On garde _client comme nom de variable

  ActivityHoursAdapter(SupabaseClient supabase) : _client = supabase;  // On initialise _client

  @override
  Future<OpeningDays?> getActivityHours(
      String activityId,
      DateTime startDate,
      DateTime endDate,
      ) async {
    try {
      final response = await _client
          .from('activity_hours')
          .select()
          .eq('activity_id', activityId)
          .lte('season_start', endDate.toIso8601String())
          .gte('season_end', startDate.toIso8601String())
          .eq('is_open', true);

      if (response == null || response.isEmpty) {
        return null;
      }

      final schedule = response[0]; // Prendre le premier horaire valide
      final dayOfWeek = schedule['day_of_week'] as Map<String, dynamic>;
      final Map<String, Map<String, String>> availableDays = {};

      // Pour chaque jour entre startDate et endDate
      for (var date = startDate; date.isBefore(endDate.add(const Duration(days: 1))); date = date.add(const Duration(days: 1))) {
        String formattedDate = date.toIso8601String().split('T')[0];

        // Si "all" est défini, utiliser ces horaires pour tous les jours
        if (dayOfWeek['all'] != null) {
          availableDays[formattedDate] = {
            'opens_at': dayOfWeek['all']['opens_at'],
            'closes_at': dayOfWeek['all']['closes_at'],
          };
        }
        // Sinon, chercher l'horaire spécifique au jour de la semaine
        else {
          String weekday = _getWeekdayName(date.weekday).toLowerCase();
          if (dayOfWeek[weekday] != null) {
            availableDays[formattedDate] = {
              'opens_at': dayOfWeek[weekday]['opens_at'],
              'closes_at': dayOfWeek[weekday]['closes_at'],
            };
          }
        }
      }

      return OpeningDays(availableDays: availableDays);
    } catch (e) {
      print('❌ Erreur lors de la récupération des horaires: $e');
      throw DataException('Erreur lors de la récupération des horaires: $e');
    }
  }

  String _getWeekdayName(int weekday) {
    switch (weekday) {
      case 1: return 'monday';
      case 2: return 'tuesday';
      case 3: return 'wednesday';
      case 4: return 'thursday';
      case 5: return 'friday';
      case 6: return 'saturday';
      case 7: return 'sunday';
      default: throw ArgumentError('Invalid weekday number: $weekday');
    }
  }
}