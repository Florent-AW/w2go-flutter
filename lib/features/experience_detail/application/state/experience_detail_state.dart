// lib/features/experience_detail/application/state/experience_detail_state.dart

import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../../core/domain/models/shared/experience_details_model.dart';

part 'experience_detail_state.freezed.dart';

@freezed
class ExperienceDetailState with _$ExperienceDetailState {
  /// État initial, avant toute action
  const factory ExperienceDetailState.initial() = _Initial;

  /// État de chargement, lorsque la requête est en cours
  const factory ExperienceDetailState.loading() = _Loading;

  /// État d'erreur, avec un message explicatif
  const factory ExperienceDetailState.error(String message) = _Error;

  /// État chargé avec succès, contenant les détails de l'expérience
  const factory ExperienceDetailState.loaded(ExperienceDetails details) = _Loaded;
}