// features/search/domain/ports/activity_details_port.dart

import '../../../../core/domain/models/shared/activity_details_model.dart';

abstract class ActivityDetailsPort {
  Future<ActivityDetails> getActivityDetails(String activityId);
}

