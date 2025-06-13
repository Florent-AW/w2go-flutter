// lib/features/activity_detail/domain/usecases/get_activity_details_use_case.dart

import 'package:flutter/foundation.dart';
import '../../../../core/domain/models/shared/activity_details_model.dart';
import '../../../../core/domain/ports/search/activity_details_port.dart';
import '../../../../core/common/exceptions/exceptions.dart';

/// Use case responsable de récupérer les détails d'une activité
class GetActivityDetailsUseCase {
  final ActivityDetailsPort _activityDetailsPort;

  /// Constructeur qui injecte le port d'accès aux données
  const GetActivityDetailsUseCase(this._activityDetailsPort);

  /// Récupère les détails d'une activité par son ID
  ///
  /// Retourne les détails de l'activité ou lance une exception en cas d'erreur
  Future<ActivityDetails> execute(String activityId) async {
    try {
      if (activityId.isEmpty) {
        throw ArgumentError('L\'ID de l\'activité ne peut pas être vide');
      }

      final activityDetails = await _activityDetailsPort.getActivityDetails(activityId);
      return activityDetails;

    } catch (e, stackTrace) {
      debugPrint('Erreur lors de la récupération des détails: $e');
      debugPrint('Stack trace: $stackTrace');

      // Transformer les exceptions en types d'erreurs appropriés pour la couche supérieure
      if (e is ArgumentError) {
        throw e;
      }

      throw DataException('Impossible de récupérer les détails de l\'activité: ${e.toString()}');
    }
  }
}