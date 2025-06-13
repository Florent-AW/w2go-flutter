// lib/features/activity_detail/application/state/activity_detail_state.dart

import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../../core/domain/models/shared/activity_details_model.dart';

part 'activity_detail_state.freezed.dart';

@freezed
class ActivityDetailState with _$ActivityDetailState {
  /// État initial, avant toute action
  const factory ActivityDetailState.initial() = _Initial;

  /// État de chargement, lorsque la requête est en cours
  const factory ActivityDetailState.loading() = _Loading;

  /// État d'erreur, avec un message explicatif
  const factory ActivityDetailState.error(String message) = _Error;

  /// État chargé avec succès, contenant les détails de l'activité
  const factory ActivityDetailState.loaded(ActivityDetails details) = _Loaded;
}