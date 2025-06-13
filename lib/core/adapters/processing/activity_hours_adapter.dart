// lib\core\adapters\processing\activity_hours_adapter.dart

import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/ports/activity_hours_port.dart';
import '../../common/exceptions/exceptions.dart';

// Extension pour convertir le numéro du jour en nom
extension DateTimeExtension on int {
  String toDayName() {
    switch (this) {
      case DateTime.monday: return 'monday';
      case DateTime.tuesday: return 'tuesday';
      case DateTime.wednesday: return 'wednesday';
      case DateTime.thursday: return 'thursday';
      case DateTime.friday: return 'friday';
      case DateTime.saturday: return 'saturday';
      case DateTime.sunday: return 'sunday';
      default: throw Exception('Invalid day of week');
    }
  }
}

class OpeningDays {
  final Map<String, Map<String, String>> availableDays; // jour -> {opens_at, closes_at}

  OpeningDays(this.availableDays);

  bool get hasOpenDays => availableDays.isNotEmpty;

  Map<String, String>? getHoursForDay(String day) => availableDays[day];
}

class ActivityHoursService {
  final SupabaseClient _supabase;

  const ActivityHoursService(this._supabase);

  Future<OpeningDays?> getActivityHours(
      String activityId, DateTime dateStart, DateTime dateEnd) async {
    try {
      final response = await _supabase
          .from('activity_hours')
          .select()
          .eq('activity_id', activityId)
          .eq('is_open', true)
          .lte('season_start', dateEnd.toIso8601String())
          .gte('season_end', dateStart.toIso8601String());

      if (response.isEmpty) {
        print('Aucun horaire trouvé pour l\'activité $activityId');
        return null;
      }

      final schedule = response[0]['day_of_week'];
      if (schedule == null) {
        print('Structure d\'horaires invalide pour l\'activité $activityId');
        return null;
      }

      // Résultat pour stocker les jours disponibles
      Map<String, Map<String, String>> availableDays = {};

      // Vérifier chaque jour du séjour
      for (var d = dateStart;
      d.isBefore(dateEnd.add(Duration(days: 1)));
      d = d.add(Duration(days: 1))) {

        String dayName = d.weekday.toDayName().toLowerCase();
        print('Vérification pour ${d.toString()} (${dayName})');

        // Vérifier d'abord les horaires 'all'
        if (schedule['all'] != null) {
          availableDays[dayName] = {
            'opens_at': schedule['all']['opens_at'],
            'closes_at': schedule['all']['closes_at'],
          };
          continue;
        }

        // Sinon vérifier les horaires spécifiques du jour
        if (schedule[dayName] != null) {
          availableDays[dayName] = {
            'opens_at': schedule[dayName]['opens_at'],
            'closes_at': schedule[dayName]['closes_at'],
          };
        }
      }

      // Si aucun jour d'ouverture trouvé
      if (availableDays.isEmpty) {
        print('Aucun jour d\'ouverture pendant le séjour pour l\'activité $activityId');
        return null;
      }

      print('Jours d\'ouverture trouvés: ${availableDays.keys.join(', ')}');
      return OpeningDays(availableDays);

    } catch (e) {
      print('❌ Erreur lors de la récupération des horaires: $e');
      return null;
    }
  }
}