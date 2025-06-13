// lib/features/experience_detail/domain/usecases/get_experience_details_use_case.dart

import 'package:flutter/foundation.dart';
import '../../../../core/domain/models/shared/experience_item.dart';
import '../../../../core/domain/models/shared/experience_details_model.dart';
import '../../../../features/activity_detail/domain/usecases/get_activity_details_use_case.dart';
import '../../../event_detail/domain/usecases/get_event_details_use_case.dart';
import '../../../../core/common/exceptions/exceptions.dart';

/// Use case unifié responsable de récupérer les détails d'une expérience (Activity ou Event)
class GetExperienceDetailsUseCase {
  final GetActivityDetailsUseCase _activityUseCase;
  final GetEventDetailsUseCase _eventUseCase;

  const GetExperienceDetailsUseCase(
      this._activityUseCase,
      this._eventUseCase,
      );

  /// Récupère les détails d'une expérience selon son type
  Future<ExperienceDetails> execute(ExperienceItem item) async {
    try {
      if (item.isEvent) {
        final eventDetails = await _eventUseCase.execute(item.id);
        return ExperienceDetails.event(eventDetails);
      } else {
        final activityDetails = await _activityUseCase.execute(item.id);
        return ExperienceDetails.activity(activityDetails);
      }
    } catch (e, stackTrace) {
      debugPrint('Erreur lors de la récupération des détails: $e');
      debugPrint('Stack trace: $stackTrace');

      if (e is ArgumentError) {
        throw e;
      }

      throw DataException('Impossible de récupérer les détails de l\'expérience: ${e.toString()}');
    }
  }

  /// Méthode legacy pour compatibilité (à supprimer plus tard)
  Future<ExperienceDetails> executeById(String id, {required bool isEvent}) async {
    if (isEvent) {
      final eventDetails = await _eventUseCase.execute(id);
      return ExperienceDetails.event(eventDetails);
    } else {
      final activityDetails = await _activityUseCase.execute(id);
      return ExperienceDetails.activity(activityDetails);
    }
  }
}