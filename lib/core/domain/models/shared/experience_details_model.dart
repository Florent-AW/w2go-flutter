// lib/core/domain/models/shared/experience_details_model.dart

import 'package:freezed_annotation/freezed_annotation.dart';
import 'activity_details_model.dart';
import '../event/details/event_details_model.dart';

part 'experience_details_model.freezed.dart';

/// Union type pour Details Activities + Events
@freezed
class ExperienceDetails with _$ExperienceDetails {
  const factory ExperienceDetails.activity(ActivityDetails details) = ActivityExperienceDetails;
  const factory ExperienceDetails.event(EventDetails details) = EventExperienceDetails;

  const ExperienceDetails._();

  /// Getters unifiés pour l'UI
  String get id => when(
    activity: (details) => details.id,
    event: (details) => details.id,
  );

  String get name => when(
    activity: (details) => details.name,
    event: (details) => details.name,
  );

  String? get description => when(
    activity: (details) => details.description,
    event: (details) => details.description,
  );

  double get latitude => when(
    activity: (details) => details.latitude,
    event: (details) => details.latitude,
  );

  double get longitude => when(
    activity: (details) => details.longitude,
    event: (details) => details.longitude,
  );

  String? get city => when(
    activity: (details) => details.city,
    event: (details) => details.city,
  );

  String? get categoryName => when(
    activity: (details) => details.categoryName,
    event: (details) => details.categoryName,
  );

  String? get subcategoryName => when(
    activity: (details) => details.subcategoryName,
    event: (details) => details.subcategoryName,
  );

  String? get subcategoryIcon => when(
    activity: (details) => details.subcategoryIcon,
    event: (details) => details.subcategoryIcon,
  );

  List<String> get imageUrls => when(
    activity: (details) => details.images?.map((img) => img.mobileUrl ?? '').where((url) => url.isNotEmpty).toList() ?? [],
    event: (details) => details.images?.map((img) => img.mobileUrl ?? '').where((url) => url.isNotEmpty).toList() ?? [],
  );

  /// Spécifique Events
  DateTime? get startDate => when(
    activity: (_) => null,
    event: (details) => details.startDate,
  );

  DateTime? get endDate => when(
    activity: (_) => null,
    event: (details) => details.endDate,
  );

  bool get isEvent => when(
    activity: (_) => false,
    event: (_) => true,
  );

  /// Helpers pour accès type-safe
  ActivityDetails? get asActivity => when(
    activity: (details) => details,
    event: (_) => null,
  );

  EventDetails? get asEvent => when(
    activity: (_) => null,
    event: (details) => details,
  );
}