// lib/core/domain/models/shared/experience_item.dart

import 'package:freezed_annotation/freezed_annotation.dart';
import '../activity/search/searchable_activity.dart';
import '../event/search/searchable_event.dart';

part 'experience_item.freezed.dart';

/// Abstraction commune pour Activities et Events
/// Permet d'afficher les deux types dans les mêmes carousels
@freezed
class ExperienceItem with _$ExperienceItem {

  /// Constructeur pour une activité
  const factory ExperienceItem.activity(SearchableActivity activity) = ActivityExperience;

  /// Constructeur pour un événement
  const factory ExperienceItem.event(SearchableEvent event) = EventExperience;

  const ExperienceItem._();

  /// Getters communs pour l'affichage UI
  String get id => when(
    activity: (activity) => activity.base.id,
    event: (event) => event.base.id,
  );

  String get name => when(
    activity: (activity) => activity.base.name,
    event: (event) => event.base.name,
  );

  String? get description => when(
    activity: (activity) => activity.base.description,
    event: (event) => event.base.description,
  );

  double get latitude => when(
    activity: (activity) => activity.base.latitude,
    event: (event) => event.base.latitude,
  );

  double get longitude => when(
    activity: (activity) => activity.base.longitude,
    event: (event) => event.base.longitude,
  );

  String get categoryId => when(
    activity: (activity) => activity.base.categoryId,
    event: (event) => event.base.categoryId,
  );

  String? get subcategoryId => when(
    activity: (activity) => activity.base.subcategoryId,
    event: (event) => event.base.subcategoryId,
  );

  String? get city => when(
    activity: (activity) => activity.city ?? activity.base.city,
    event: (event) => event.city ?? event.base.city,
  );

  String? get mainImageUrl => when(
    activity: (activity) => activity.mainImageUrl,
    event: (event) => event.mainImageUrl,
  );

  bool get isWow => when(
    activity: (activity) => activity.base.isWow,
    event: (event) => event.base.isWow,
  );

  double? get basePrice => when(
    activity: (activity) => activity.base.basePrice,
    event: (event) => event.base.basePrice,
  );

  double get ratingAvg => when(
    activity: (activity) => activity.base.ratingAvg,
    event: (event) => event.base.ratingAvg,
  );

  int get ratingCount => when(
    activity: (activity) => activity.base.ratingCount,
    event: (event) => event.base.ratingCount,
  );

  bool get kidFriendly => when(
    activity: (activity) => activity.base.kidFriendly,
    event: (event) => event.base.kidFriendly,
  );

  String? get categoryName => when(
    activity: (activity) => activity.categoryName,
    event: (event) => event.categoryName,
  );

  String? get subcategoryName => when(
    activity: (activity) => activity.subcategoryName,
    event: (event) => event.subcategoryName,
  );

  String? get subcategoryIcon => when(
    activity: (activity) => activity.subcategoryIcon,
    event: (event) => event.subcategoryIcon,
  );

  double? get distance => when(
    activity: (activity) => activity.distance ?? activity.approxDistanceKm,
    event: (event) => event.distance ?? event.approxDistanceKm,
  );

  /// Indique si c'est un événement (pour affichage conditionnel)
  bool get isEvent => when(
    activity: (_) => false,
    event: (_) => true,
  );

  /// Getters spécifiques aux événements (null si c'est une activité)
  DateTime? get startDate => when(
    activity: (_) => null,
    event: (event) => event.base.startDate,
  );

  DateTime? get endDate => when(
    activity: (_) => null,
    event: (event) => event.base.endDate,
  );

  bool? get bookingRequired => when(
    activity: (activity) => activity.base.bookingRequired,
    event: (event) => event.base.bookingRequired,
  );

  bool? get hasMultipleOccurrences => when(
    activity: (_) => null,
    event: (event) => event.base.hasMultipleOccurrences,
  );

  bool? get isRecurring => when(
    activity: (_) => null,
    event: (event) => event.base.isRecurring,
  );

  /// Helper pour obtenir l'objet Activity original (si c'est une activité)
  SearchableActivity? get asActivity => when(
    activity: (activity) => activity,
    event: (_) => null,
  );

  /// Helper pour obtenir l'objet Event original (si c'est un événement)
  SearchableEvent? get asEvent => when(
    activity: (_) => null,
    event: (event) => event,
  );
}