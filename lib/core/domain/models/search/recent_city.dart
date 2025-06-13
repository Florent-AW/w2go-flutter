// lib/core/domain/models/search/recent_city.dart

import 'package:freezed_annotation/freezed_annotation.dart';
import '../shared/city_model.dart';

part 'recent_city.freezed.dart';
part 'recent_city.g.dart';

@freezed
class RecentCity with _$RecentCity {
  const factory RecentCity({
    required City city,
    required DateTime timestamp,
  }) = _RecentCity;

  factory RecentCity.fromJson(Map<String, dynamic> json) => _$RecentCityFromJson(json);

  /// Crée une entrée d'historique pour une ville avec le timestamp actuel
  factory RecentCity.now(City city) => RecentCity(
    city: city,
    timestamp: DateTime.now(),
  );
}