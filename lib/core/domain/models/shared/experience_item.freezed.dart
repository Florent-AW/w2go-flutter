// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'experience_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ExperienceItem _$ExperienceItemFromJson(Map<String, dynamic> json) {
  switch (json['runtimeType']) {
    case 'activity':
      return ActivityExperience.fromJson(json);
    case 'event':
      return EventExperience.fromJson(json);

    default:
      throw CheckedFromJsonException(json, 'runtimeType', 'ExperienceItem',
          'Invalid union type "${json['runtimeType']}"!');
  }
}

/// @nodoc
mixin _$ExperienceItem {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(SearchableActivity activity) activity,
    required TResult Function(SearchableEvent event) event,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(SearchableActivity activity)? activity,
    TResult? Function(SearchableEvent event)? event,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(SearchableActivity activity)? activity,
    TResult Function(SearchableEvent event)? event,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ActivityExperience value) activity,
    required TResult Function(EventExperience value) event,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ActivityExperience value)? activity,
    TResult? Function(EventExperience value)? event,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ActivityExperience value)? activity,
    TResult Function(EventExperience value)? event,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Serializes this ExperienceItem to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ExperienceItemCopyWith<$Res> {
  factory $ExperienceItemCopyWith(
          ExperienceItem value, $Res Function(ExperienceItem) then) =
      _$ExperienceItemCopyWithImpl<$Res, ExperienceItem>;
}

/// @nodoc
class _$ExperienceItemCopyWithImpl<$Res, $Val extends ExperienceItem>
    implements $ExperienceItemCopyWith<$Res> {
  _$ExperienceItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ExperienceItem
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$ActivityExperienceImplCopyWith<$Res> {
  factory _$$ActivityExperienceImplCopyWith(_$ActivityExperienceImpl value,
          $Res Function(_$ActivityExperienceImpl) then) =
      __$$ActivityExperienceImplCopyWithImpl<$Res>;
  @useResult
  $Res call({SearchableActivity activity});

  $SearchableActivityCopyWith<$Res> get activity;
}

/// @nodoc
class __$$ActivityExperienceImplCopyWithImpl<$Res>
    extends _$ExperienceItemCopyWithImpl<$Res, _$ActivityExperienceImpl>
    implements _$$ActivityExperienceImplCopyWith<$Res> {
  __$$ActivityExperienceImplCopyWithImpl(_$ActivityExperienceImpl _value,
      $Res Function(_$ActivityExperienceImpl) _then)
      : super(_value, _then);

  /// Create a copy of ExperienceItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? activity = null,
  }) {
    return _then(_$ActivityExperienceImpl(
      null == activity
          ? _value.activity
          : activity // ignore: cast_nullable_to_non_nullable
              as SearchableActivity,
    ));
  }

  /// Create a copy of ExperienceItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $SearchableActivityCopyWith<$Res> get activity {
    return $SearchableActivityCopyWith<$Res>(_value.activity, (value) {
      return _then(_value.copyWith(activity: value));
    });
  }
}

/// @nodoc
@JsonSerializable()
class _$ActivityExperienceImpl extends ActivityExperience {
  const _$ActivityExperienceImpl(this.activity, {final String? $type})
      : $type = $type ?? 'activity',
        super._();

  factory _$ActivityExperienceImpl.fromJson(Map<String, dynamic> json) =>
      _$$ActivityExperienceImplFromJson(json);

  @override
  final SearchableActivity activity;

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'ExperienceItem.activity(activity: $activity)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ActivityExperienceImpl &&
            (identical(other.activity, activity) ||
                other.activity == activity));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, activity);

  /// Create a copy of ExperienceItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ActivityExperienceImplCopyWith<_$ActivityExperienceImpl> get copyWith =>
      __$$ActivityExperienceImplCopyWithImpl<_$ActivityExperienceImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(SearchableActivity activity) activity,
    required TResult Function(SearchableEvent event) event,
  }) {
    return activity(this.activity);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(SearchableActivity activity)? activity,
    TResult? Function(SearchableEvent event)? event,
  }) {
    return activity?.call(this.activity);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(SearchableActivity activity)? activity,
    TResult Function(SearchableEvent event)? event,
    required TResult orElse(),
  }) {
    if (activity != null) {
      return activity(this.activity);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ActivityExperience value) activity,
    required TResult Function(EventExperience value) event,
  }) {
    return activity(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ActivityExperience value)? activity,
    TResult? Function(EventExperience value)? event,
  }) {
    return activity?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ActivityExperience value)? activity,
    TResult Function(EventExperience value)? event,
    required TResult orElse(),
  }) {
    if (activity != null) {
      return activity(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$ActivityExperienceImplToJson(
      this,
    );
  }
}

abstract class ActivityExperience extends ExperienceItem {
  const factory ActivityExperience(final SearchableActivity activity) =
      _$ActivityExperienceImpl;
  const ActivityExperience._() : super._();

  factory ActivityExperience.fromJson(Map<String, dynamic> json) =
      _$ActivityExperienceImpl.fromJson;

  SearchableActivity get activity;

  /// Create a copy of ExperienceItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ActivityExperienceImplCopyWith<_$ActivityExperienceImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$EventExperienceImplCopyWith<$Res> {
  factory _$$EventExperienceImplCopyWith(_$EventExperienceImpl value,
          $Res Function(_$EventExperienceImpl) then) =
      __$$EventExperienceImplCopyWithImpl<$Res>;
  @useResult
  $Res call({SearchableEvent event});

  $SearchableEventCopyWith<$Res> get event;
}

/// @nodoc
class __$$EventExperienceImplCopyWithImpl<$Res>
    extends _$ExperienceItemCopyWithImpl<$Res, _$EventExperienceImpl>
    implements _$$EventExperienceImplCopyWith<$Res> {
  __$$EventExperienceImplCopyWithImpl(
      _$EventExperienceImpl _value, $Res Function(_$EventExperienceImpl) _then)
      : super(_value, _then);

  /// Create a copy of ExperienceItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? event = null,
  }) {
    return _then(_$EventExperienceImpl(
      null == event
          ? _value.event
          : event // ignore: cast_nullable_to_non_nullable
              as SearchableEvent,
    ));
  }

  /// Create a copy of ExperienceItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $SearchableEventCopyWith<$Res> get event {
    return $SearchableEventCopyWith<$Res>(_value.event, (value) {
      return _then(_value.copyWith(event: value));
    });
  }
}

/// @nodoc
@JsonSerializable()
class _$EventExperienceImpl extends EventExperience {
  const _$EventExperienceImpl(this.event, {final String? $type})
      : $type = $type ?? 'event',
        super._();

  factory _$EventExperienceImpl.fromJson(Map<String, dynamic> json) =>
      _$$EventExperienceImplFromJson(json);

  @override
  final SearchableEvent event;

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'ExperienceItem.event(event: $event)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EventExperienceImpl &&
            (identical(other.event, event) || other.event == event));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, event);

  /// Create a copy of ExperienceItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$EventExperienceImplCopyWith<_$EventExperienceImpl> get copyWith =>
      __$$EventExperienceImplCopyWithImpl<_$EventExperienceImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(SearchableActivity activity) activity,
    required TResult Function(SearchableEvent event) event,
  }) {
    return event(this.event);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(SearchableActivity activity)? activity,
    TResult? Function(SearchableEvent event)? event,
  }) {
    return event?.call(this.event);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(SearchableActivity activity)? activity,
    TResult Function(SearchableEvent event)? event,
    required TResult orElse(),
  }) {
    if (event != null) {
      return event(this.event);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ActivityExperience value) activity,
    required TResult Function(EventExperience value) event,
  }) {
    return event(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ActivityExperience value)? activity,
    TResult? Function(EventExperience value)? event,
  }) {
    return event?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ActivityExperience value)? activity,
    TResult Function(EventExperience value)? event,
    required TResult orElse(),
  }) {
    if (event != null) {
      return event(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$EventExperienceImplToJson(
      this,
    );
  }
}

abstract class EventExperience extends ExperienceItem {
  const factory EventExperience(final SearchableEvent event) =
      _$EventExperienceImpl;
  const EventExperience._() : super._();

  factory EventExperience.fromJson(Map<String, dynamic> json) =
      _$EventExperienceImpl.fromJson;

  SearchableEvent get event;

  /// Create a copy of ExperienceItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$EventExperienceImplCopyWith<_$EventExperienceImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
