// lib/core/domain/services/shared/activity_info_factory.dart

import '../../models/shared/info_item.dart';
import '../../models/shared/activity_details_model.dart';

/// Factory pour créer les InfoItems à partir d'une ActivityDetails
///
/// Service métier pur, sans dépendances UI
/// Gère la logique de mapping et formatage des informations
class ActivityInfoFactory {
  /// Crée la liste des InfoItems pour une activité
  ///
  /// Version avec famille, réservation, durée, accessibilité
  static List<InfoItem> createInfoItems(ActivityDetails details) {
    final items = <InfoItem>[];

    // 1. Famille (kid_friendly)
    final familyItem = _createFamilyItem(details);
    if (familyItem != null) items.add(familyItem);

    // 2. Réservation (booking_required)
    final bookingItem = _createBookingItem(details);
    if (bookingItem != null) items.add(bookingItem);

    // 3. Durée (min/max_duration_minutes)
    final durationItem = _createDurationItem(details);
    if (durationItem != null) items.add(durationItem);

    // 4. Accessibilité (wheelchair_accessible)
    final accessibilityItem = _createAccessibilityItem(details);
    if (accessibilityItem != null) items.add(accessibilityItem);

    return items;
  }

  /// Crée l'InfoItem pour la famille
  static InfoItem? _createFamilyItem(ActivityDetails details) {
    if (details.kidFriendly == null) return null;

    return InfoItem(
      iconName: 'users',
      value: details.kidFriendly == true
          ? 'Adapté à toute la famille'
          : 'Non adapté aux enfants',
      type: InfoItemType.family,
    );
  }

  /// Crée l'InfoItem pour la réservation
  static InfoItem? _createBookingItem(ActivityDetails details) {
    if (details.bookingLevel == null) return null;

    final String value;

    switch (details.bookingLevel) {
      case 'none':
        value = 'Sans réservation';
        break;
      case 'recommended':
        value = 'Réservation conseillée';
        break;
      case 'required':
        value = 'Sur réservation';
        break;
      default:
        return null; // Si enum inconnu, ne pas afficher
    }

    return InfoItem(
      iconName: 'calendar-check',
      value: value,
      type: InfoItemType.booking,
    );
  }

  /// Crée l'InfoItem pour la durée (moyenne)
  static InfoItem? _createDurationItem(ActivityDetails details) {
    final minDuration = details.minDurationMinutes;
    final maxDuration = details.maxDurationMinutes;

    if (minDuration == null && maxDuration == null) return null;

    final avgDuration = _calculateAverageDuration(minDuration, maxDuration);

    return InfoItem(
      iconName: 'clock',
      value: 'Durée : ${_formatMinutes(avgDuration)}',  // ✅ Ajout "Durée : "
      type: InfoItemType.duration,
    );
  }

  /// Crée l'InfoItem pour l'accessibilité PMR
  static InfoItem? _createAccessibilityItem(ActivityDetails details) {
    if (details.wheelchairAccessible == null) return null;

    final String value;

    switch (details.wheelchairAccessible) {
      case 'full':
        value = 'PMR : Entièrement accessible';  // ✅ Ajout "PMR : "
        break;
      case 'partial':
        value = 'PMR : Partiellement accessible';  // ✅ Ajout "PMR : "
        break;
      case 'none':
        value = 'PMR : Non accessible';  // ✅ Ajout "PMR : "
        break;
      default:
        return null;
    }

    return InfoItem(
      iconName: 'wheelchair',
      value: value,
      type: InfoItemType.accessibility,
    );
  }

  /// Calcule la durée moyenne arrondie à 30min près
  static int _calculateAverageDuration(int? minDuration, int? maxDuration) {
    int avgDuration;

    if (minDuration != null && maxDuration != null) {
      avgDuration = ((minDuration + maxDuration) / 2).round();
    } else {
      avgDuration = minDuration ?? maxDuration ?? 0;
    }

    // ✅ Arrondi à 30min près
    return ((avgDuration / 30).round() * 30);
  }

  /// Formate les minutes en format lisible
  static String _formatMinutes(int minutes) {
    final hours = minutes ~/ 60;
    final mins = minutes % 60;

    if (hours > 0) {
      return mins > 0 ? '${hours}h${mins.toString().padLeft(2, '0')}' : '${hours}h';
    } else {
      return '${mins}min';
    }
  }
}