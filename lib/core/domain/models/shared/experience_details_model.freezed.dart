// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'experience_details_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$ExperienceDetails {
  Object get details => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(ActivityDetails details) activity,
    required TResult Function(EventDetails details) event,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(ActivityDetails details)? activity,
    TResult? Function(EventDetails details)? event,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(ActivityDetails details)? activity,
    TResult Function(EventDetails details)? event,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ActivityExperienceDetails value) activity,
    required TResult Function(EventExperienceDetails value) event,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ActivityExperienceDetails value)? activity,
    TResult? Function(EventExperienceDetails value)? event,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ActivityExperienceDetails value)? activity,
    TResult Function(EventExperienceDetails value)? event,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ExperienceDetailsCopyWith<$Res> {
  factory $ExperienceDetailsCopyWith(
          ExperienceDetails value, $Res Function(ExperienceDetails) then) =
      _$ExperienceDetailsCopyWithImpl<$Res, ExperienceDetails>;
}

/// @nodoc
class _$ExperienceDetailsCopyWithImpl<$Res, $Val extends ExperienceDetails>
    implements $ExperienceDetailsCopyWith<$Res> {
  _$ExperienceDetailsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ExperienceDetails
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$ActivityExperienceDetailsImplCopyWith<$Res> {
  factory _$$ActivityExperienceDetailsImplCopyWith(
          _$ActivityExperienceDetailsImpl value,
          $Res Function(_$ActivityExperienceDetailsImpl) then) =
      __$$ActivityExperienceDetailsImplCopyWithImpl<$Res>;
  @useResult
  $Res call({ActivityDetails details});

  $ActivityDetailsCopyWith<$Res> get details;
}

/// @nodoc
class __$$ActivityExperienceDetailsImplCopyWithImpl<$Res>
    extends _$ExperienceDetailsCopyWithImpl<$Res,
        _$ActivityExperienceDetailsImpl>
    implements _$$ActivityExperienceDetailsImplCopyWith<$Res> {
  __$$ActivityExperienceDetailsImplCopyWithImpl(
      _$ActivityExperienceDetailsImpl _value,
      $Res Function(_$ActivityExperienceDetailsImpl) _then)
      : super(_value, _then);

  /// Create a copy of ExperienceDetails
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? details = null,
  }) {
    return _then(_$ActivityExperienceDetailsImpl(
      null == details
          ? _value.details
          : details // ignore: cast_nullable_to_non_nullable
              as ActivityDetails,
    ));
  }

  /// Create a copy of ExperienceDetails
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ActivityDetailsCopyWith<$Res> get details {
    return $ActivityDetailsCopyWith<$Res>(_value.details, (value) {
      return _then(_value.copyWith(details: value));
    });
  }
}

/// @nodoc

class _$ActivityExperienceDetailsImpl extends ActivityExperienceDetails {
  const _$ActivityExperienceDetailsImpl(this.details) : super._();

  @override
  final ActivityDetails details;

  @override
  String toString() {
    return 'ExperienceDetails.activity(details: $details)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ActivityExperienceDetailsImpl &&
            (identical(other.details, details) || other.details == details));
  }

  @override
  int get hashCode => Object.hash(runtimeType, details);

  /// Create a copy of ExperienceDetails
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ActivityExperienceDetailsImplCopyWith<_$ActivityExperienceDetailsImpl>
      get copyWith => __$$ActivityExperienceDetailsImplCopyWithImpl<
          _$ActivityExperienceDetailsImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(ActivityDetails details) activity,
    required TResult Function(EventDetails details) event,
  }) {
    return activity(details);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(ActivityDetails details)? activity,
    TResult? Function(EventDetails details)? event,
  }) {
    return activity?.call(details);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(ActivityDetails details)? activity,
    TResult Function(EventDetails details)? event,
    required TResult orElse(),
  }) {
    if (activity != null) {
      return activity(details);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ActivityExperienceDetails value) activity,
    required TResult Function(EventExperienceDetails value) event,
  }) {
    return activity(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ActivityExperienceDetails value)? activity,
    TResult? Function(EventExperienceDetails value)? event,
  }) {
    return activity?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ActivityExperienceDetails value)? activity,
    TResult Function(EventExperienceDetails value)? event,
    required TResult orElse(),
  }) {
    if (activity != null) {
      return activity(this);
    }
    return orElse();
  }
}

abstract class ActivityExperienceDetails extends ExperienceDetails {
  const factory ActivityExperienceDetails(final ActivityDetails details) =
      _$ActivityExperienceDetailsImpl;
  const ActivityExperienceDetails._() : super._();

  @override
  ActivityDetails get details;

  /// Create a copy of ExperienceDetails
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ActivityExperienceDetailsImplCopyWith<_$ActivityExperienceDetailsImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$EventExperienceDetailsImplCopyWith<$Res> {
  factory _$$EventExperienceDetailsImplCopyWith(
          _$EventExperienceDetailsImpl value,
          $Res Function(_$EventExperienceDetailsImpl) then) =
      __$$EventExperienceDetailsImplCopyWithImpl<$Res>;
  @useResult
  $Res call({EventDetails details});

  $EventDetailsCopyWith<$Res> get details;
}

/// @nodoc
class __$$EventExperienceDetailsImplCopyWithImpl<$Res>
    extends _$ExperienceDetailsCopyWithImpl<$Res, _$EventExperienceDetailsImpl>
    implements _$$EventExperienceDetailsImplCopyWith<$Res> {
  __$$EventExperienceDetailsImplCopyWithImpl(
      _$EventExperienceDetailsImpl _value,
      $Res Function(_$EventExperienceDetailsImpl) _then)
      : super(_value, _then);

  /// Create a copy of ExperienceDetails
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? details = null,
  }) {
    return _then(_$EventExperienceDetailsImpl(
      null == details
          ? _value.details
          : details // ignore: cast_nullable_to_non_nullable
              as EventDetails,
    ));
  }

  /// Create a copy of ExperienceDetails
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $EventDetailsCopyWith<$Res> get details {
    return $EventDetailsCopyWith<$Res>(_value.details, (value) {
      return _then(_value.copyWith(details: value));
    });
  }
}

/// @nodoc

class _$EventExperienceDetailsImpl extends EventExperienceDetails {
  const _$EventExperienceDetailsImpl(this.details) : super._();

  @override
  final EventDetails details;

  @override
  String toString() {
    return 'ExperienceDetails.event(details: $details)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EventExperienceDetailsImpl &&
            (identical(other.details, details) || other.details == details));
  }

  @override
  int get hashCode => Object.hash(runtimeType, details);

  /// Create a copy of ExperienceDetails
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$EventExperienceDetailsImplCopyWith<_$EventExperienceDetailsImpl>
      get copyWith => __$$EventExperienceDetailsImplCopyWithImpl<
          _$EventExperienceDetailsImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(ActivityDetails details) activity,
    required TResult Function(EventDetails details) event,
  }) {
    return event(details);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(ActivityDetails details)? activity,
    TResult? Function(EventDetails details)? event,
  }) {
    return event?.call(details);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(ActivityDetails details)? activity,
    TResult Function(EventDetails details)? event,
    required TResult orElse(),
  }) {
    if (event != null) {
      return event(details);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ActivityExperienceDetails value) activity,
    required TResult Function(EventExperienceDetails value) event,
  }) {
    return event(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ActivityExperienceDetails value)? activity,
    TResult? Function(EventExperienceDetails value)? event,
  }) {
    return event?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ActivityExperienceDetails value)? activity,
    TResult Function(EventExperienceDetails value)? event,
    required TResult orElse(),
  }) {
    if (event != null) {
      return event(this);
    }
    return orElse();
  }
}

abstract class EventExperienceDetails extends ExperienceDetails {
  const factory EventExperienceDetails(final EventDetails details) =
      _$EventExperienceDetailsImpl;
  const EventExperienceDetails._() : super._();

  @override
  EventDetails get details;

  /// Create a copy of ExperienceDetails
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$EventExperienceDetailsImplCopyWith<_$EventExperienceDetailsImpl>
      get copyWith => throw _privateConstructorUsedError;
}
