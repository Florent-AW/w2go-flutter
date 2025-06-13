// lib/features/event_detail/domain/usecases/get_event_details_use_case.dart

import 'package:flutter/foundation.dart';
import '../../../../core/domain/models/event/details/event_details_model.dart';
import '../../../../core/domain/ports/search/event_details_port.dart';
import '../../../../core/common/exceptions/exceptions.dart';

/// Use case responsable de récupérer les détails d'un événement
class GetEventDetailsUseCase {
  final EventDetailsPort _eventDetailsPort;

  /// Constructeur qui injecte le port d'accès aux données
  const GetEventDetailsUseCase(this._eventDetailsPort);

  /// Récupère les détails d'un événement par son ID
  ///
  /// Retourne les détails de l'événement ou lance une exception en cas d'erreur
  Future<EventDetails> execute(String eventId) async {
    try {
      if (eventId.isEmpty) {
        throw ArgumentError('L\'ID de l\'événement ne peut pas être vide');
      }

      final eventDetails = await _eventDetailsPort.getEventDetails(eventId);
      return eventDetails;

    } catch (e, stackTrace) {
      debugPrint('Erreur lors de la récupération des détails d\'événement: $e');
      debugPrint('Stack trace: $stackTrace');

      // Transformer les exceptions en types d'erreurs appropriés pour la couche supérieure
      if (e is ArgumentError) {
        throw e;
      }

      throw DataException('Impossible de récupérer les détails de l\'événement: ${e.toString()}');
    }
  }
}