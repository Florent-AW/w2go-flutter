// lib\core\domain\filters\time_filter.dart

import '../../models/trip_designer/processing/activity_processing_model.dart';
import '../../../domain/ports/activity_hours_port.dart';
import '../../../domain/services/travel_time_service.dart';
import 'activity_filter.dart';

class TimeFilter implements ActivityFilter {
  final ActivityHoursPort _hoursService;
  final TravelTimeService _travelTimeService;
  final DateTime tripStartDate;
  final DateTime tripEndDate;
  final Map<String, Map<String, String?>> dailyHours;
  final String departureGeohash5;

  TimeFilter({
    required this.tripStartDate,
    required this.tripEndDate,
    required this.dailyHours,
    required ActivityHoursPort hoursService,
    required TravelTimeService travelTimeService,
    required this.departureGeohash5,
  }) : _hoursService = hoursService,
        _travelTimeService = travelTimeService;

  @override
  String? get exclusionReason => null;

  @override
  Future<List<ActivityForProcessing>> apply(List<ActivityForProcessing> activities) async {
    print('⏰ Application du TimeFilter');
    print('Période du voyage: ${tripStartDate.toString()} - ${tripEndDate.toString()}');
    print('Horaires journaliers: $dailyHours');

    final filteredActivities = <ActivityForProcessing>[];

    for (var activity in activities) {
      activity.exclusionReason = null;
      print('\n🔍 Analyse de l\'activité: ${activity.name}');

      final openingDays = await _hoursService.getActivityHours(
        activity.id,
        tripStartDate,
        tripEndDate,
      );

      if (openingDays == null || !openingDays.hasOpenDays) {
        activity.exclusionReason = "Activité fermée pendant cette période";
        print('❌ ${activity.name}: Fermée pendant la période');
        continue;
      }

      // Vérifier la compatibilité pour chaque jour du voyage
      bool hasCompatibleDay = false;
      for (var entry in dailyHours.entries) {
        final date = entry.key;
        final hours = entry.value;

        // Si l'utilisateur n'a pas prévu d'activités ce jour-là
        if (hours['start'] == null || hours['end'] == null) {
          print('📅 $date: Pas d\'activités prévues');
          continue;
        }

        // Vérifier si l'activité est ouverte ce jour-là
        final activityHours = openingDays.availableDays[date];
        if (activityHours == null) {
          print('📅 $date: Activité fermée');
          continue;
        }

        // Calculer d'abord le temps disponible sans le trajet
        final activityOpenMinutes = _timeToMinutes(activityHours['opens_at']!);
        final activityCloseMinutes = _timeToMinutes(activityHours['closes_at']!);
        final tripStartMinutes = _timeToMinutes(hours['start']!);
        final tripEndMinutes = _timeToMinutes(hours['end']!);

        // Vérifier d'abord s'il y a un chevauchement basique
        if (activityCloseMinutes <= tripStartMinutes || activityOpenMinutes >= tripEndMinutes) {
          print('❌ $date: Pas de chevauchement des horaires');
          continue;
        }

        // Calculer le temps disponible
        final startTime = activityOpenMinutes > tripStartMinutes ? activityOpenMinutes : tripStartMinutes;
        final endTime = activityCloseMinutes < tripEndMinutes ? activityCloseMinutes : tripEndMinutes;
        final availableTime = endTime - startTime;

        // Si le temps est serré (moins d'une heure de marge), calculer le temps de trajet
        if (availableTime <= activity.minDurationMinutes + 60) {
          print('⚠️ Temps serré, vérification du temps de trajet');
          final travelTime = await _travelTimeService.calculateTravelTime(
            departureGeohash5,
            activity.geohash5 ?? '',
          );
          final totalTimeNeeded = activity.minDurationMinutes + travelTime;

          if (availableTime < totalTimeNeeded) {
            print('❌ $date: Temps insuffisant avec trajet (disponible: $availableTime, nécessaire: $totalTimeNeeded)');
            continue;
          }
        }

        hasCompatibleDay = true;
        print('✅ $date: Horaires compatibles');
        break; // On peut arrêter dès qu'on trouve un jour compatible
      }

      if (!hasCompatibleDay) {
        activity.exclusionReason = "Horaires incompatibles avec le planning du voyage";
        print('❌ ${activity.name}: Aucun jour compatible trouvé');
        continue;
      }

      print('✅ ${activity.name}: Compatible avec au moins un jour du séjour');
      filteredActivities.add(activity);
    }

    return filteredActivities;
  }

  int _timeToMinutes(String time) {
    final parts = time.split(':');
    return int.parse(parts[0]) * 60 + int.parse(parts[1]);
  }
}