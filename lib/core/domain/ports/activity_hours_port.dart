// core/domain/ports/activity_hours_port.dart

import '../models/opening_days.dart';

abstract class ActivityHoursPort {
  /// Récupère les horaires d'une activité pour une période donnée
  Future<OpeningDays?> getActivityHours(
      String activityId,
      DateTime startDate,
      DateTime endDate,
      );
}