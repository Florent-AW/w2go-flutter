import 'package:flutter/material.dart';
import '../../models/shared/experience_details_model.dart';
import '../../models/event/details/event_details_model.dart';
import '../../../../core/domain/models/shared/info_item.dart';
import 'activity_info_factory.dart';

/// Factory unifié pour créer les InfoItems Activities + Events
abstract class ExperienceInfoFactory {
  /// Point d'entrée unifié pour toute expérience
  static List<InfoItem> createInfoItems(ExperienceDetails details) {
    return details.when(
      activity: (activityDetails) => ActivityInfoFactory.createInfoItems(activityDetails),
      event: (eventDetails) => _createEventInfoItems(eventDetails),
    );
  }

  /// Factory spécifique aux Events
  static List<InfoItem> _createEventInfoItems(EventDetails eventDetails) {
    final items = <InfoItem>[];

    // Date de l'événement
    if (eventDetails.startDate != null) {
      final dateText = eventDetails.endDate != null
          ? '${_formatDate(eventDetails.startDate!)} - ${_formatDate(eventDetails.endDate!)}'
          : _formatDate(eventDetails.startDate!);

      items.add(InfoItem(
        iconName: 'calendar',
        value: 'Date : $dateText',
        type: InfoItemType.duration, // Réutilise type existant
      ));
    }

    // Réservation
    if (eventDetails.bookingRequired) {
      items.add(InfoItem(
        iconName: 'calendar-check',
        value: 'Réservation obligatoire',
        type: InfoItemType.booking,
      ));
    }

    // Occurrences multiples
    if (eventDetails.hasMultipleOccurrences) {
      items.add(InfoItem(
        iconName: 'repeat',
        value: 'Plusieurs séances',
        type: null,
      ));
    }

    return items;
  }

  static String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}