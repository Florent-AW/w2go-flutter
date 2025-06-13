// lib/core/domain/models/bonus_activities/value_objects/malus_vol_oiseau.dart

import 'package:freezed_annotation/freezed_annotation.dart';
part 'malus_vol_oiseau.freezed.dart';


@freezed
class MalusVolOiseau with _$MalusVolOiseau {
  const factory MalusVolOiseau({
    required int minutes,
  }) = _MalusVolOiseau;

  factory MalusVolOiseau.fromInt(int minutes) {
    if (minutes < 0) {
      throw ArgumentError('Malus minutes cannot be negative');
    }
    return MalusVolOiseau(minutes: minutes);
  }
}