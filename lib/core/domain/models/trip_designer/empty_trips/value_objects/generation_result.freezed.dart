// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'generation_result.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$EmptyTripGenerationResult {
  List<EmptyDailyTrip> get halfDayTrips => throw _privateConstructorUsedError;
  List<EmptyDailyTrip> get fullDayTrips => throw _privateConstructorUsedError;
  String get departureGeohash5 => throw _privateConstructorUsedError;
  List<String> get errors => throw _privateConstructorUsedError;

  /// Create a copy of EmptyTripGenerationResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $EmptyTripGenerationResultCopyWith<EmptyTripGenerationResult> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EmptyTripGenerationResultCopyWith<$Res> {
  factory $EmptyTripGenerationResultCopyWith(EmptyTripGenerationResult value,
          $Res Function(EmptyTripGenerationResult) then) =
      _$EmptyTripGenerationResultCopyWithImpl<$Res, EmptyTripGenerationResult>;
  @useResult
  $Res call(
      {List<EmptyDailyTrip> halfDayTrips,
      List<EmptyDailyTrip> fullDayTrips,
      String departureGeohash5,
      List<String> errors});
}

/// @nodoc
class _$EmptyTripGenerationResultCopyWithImpl<$Res,
        $Val extends EmptyTripGenerationResult>
    implements $EmptyTripGenerationResultCopyWith<$Res> {
  _$EmptyTripGenerationResultCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of EmptyTripGenerationResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? halfDayTrips = null,
    Object? fullDayTrips = null,
    Object? departureGeohash5 = null,
    Object? errors = null,
  }) {
    return _then(_value.copyWith(
      halfDayTrips: null == halfDayTrips
          ? _value.halfDayTrips
          : halfDayTrips // ignore: cast_nullable_to_non_nullable
              as List<EmptyDailyTrip>,
      fullDayTrips: null == fullDayTrips
          ? _value.fullDayTrips
          : fullDayTrips // ignore: cast_nullable_to_non_nullable
              as List<EmptyDailyTrip>,
      departureGeohash5: null == departureGeohash5
          ? _value.departureGeohash5
          : departureGeohash5 // ignore: cast_nullable_to_non_nullable
              as String,
      errors: null == errors
          ? _value.errors
          : errors // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$EmptyTripGenerationResultImplCopyWith<$Res>
    implements $EmptyTripGenerationResultCopyWith<$Res> {
  factory _$$EmptyTripGenerationResultImplCopyWith(
          _$EmptyTripGenerationResultImpl value,
          $Res Function(_$EmptyTripGenerationResultImpl) then) =
      __$$EmptyTripGenerationResultImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<EmptyDailyTrip> halfDayTrips,
      List<EmptyDailyTrip> fullDayTrips,
      String departureGeohash5,
      List<String> errors});
}

/// @nodoc
class __$$EmptyTripGenerationResultImplCopyWithImpl<$Res>
    extends _$EmptyTripGenerationResultCopyWithImpl<$Res,
        _$EmptyTripGenerationResultImpl>
    implements _$$EmptyTripGenerationResultImplCopyWith<$Res> {
  __$$EmptyTripGenerationResultImplCopyWithImpl(
      _$EmptyTripGenerationResultImpl _value,
      $Res Function(_$EmptyTripGenerationResultImpl) _then)
      : super(_value, _then);

  /// Create a copy of EmptyTripGenerationResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? halfDayTrips = null,
    Object? fullDayTrips = null,
    Object? departureGeohash5 = null,
    Object? errors = null,
  }) {
    return _then(_$EmptyTripGenerationResultImpl(
      halfDayTrips: null == halfDayTrips
          ? _value._halfDayTrips
          : halfDayTrips // ignore: cast_nullable_to_non_nullable
              as List<EmptyDailyTrip>,
      fullDayTrips: null == fullDayTrips
          ? _value._fullDayTrips
          : fullDayTrips // ignore: cast_nullable_to_non_nullable
              as List<EmptyDailyTrip>,
      departureGeohash5: null == departureGeohash5
          ? _value.departureGeohash5
          : departureGeohash5 // ignore: cast_nullable_to_non_nullable
              as String,
      errors: null == errors
          ? _value._errors
          : errors // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc

class _$EmptyTripGenerationResultImpl implements _EmptyTripGenerationResult {
  const _$EmptyTripGenerationResultImpl(
      {required final List<EmptyDailyTrip> halfDayTrips,
      required final List<EmptyDailyTrip> fullDayTrips,
      required this.departureGeohash5,
      required final List<String> errors})
      : _halfDayTrips = halfDayTrips,
        _fullDayTrips = fullDayTrips,
        _errors = errors;

  final List<EmptyDailyTrip> _halfDayTrips;
  @override
  List<EmptyDailyTrip> get halfDayTrips {
    if (_halfDayTrips is EqualUnmodifiableListView) return _halfDayTrips;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_halfDayTrips);
  }

  final List<EmptyDailyTrip> _fullDayTrips;
  @override
  List<EmptyDailyTrip> get fullDayTrips {
    if (_fullDayTrips is EqualUnmodifiableListView) return _fullDayTrips;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_fullDayTrips);
  }

  @override
  final String departureGeohash5;
  final List<String> _errors;
  @override
  List<String> get errors {
    if (_errors is EqualUnmodifiableListView) return _errors;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_errors);
  }

  @override
  String toString() {
    return 'EmptyTripGenerationResult(halfDayTrips: $halfDayTrips, fullDayTrips: $fullDayTrips, departureGeohash5: $departureGeohash5, errors: $errors)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EmptyTripGenerationResultImpl &&
            const DeepCollectionEquality()
                .equals(other._halfDayTrips, _halfDayTrips) &&
            const DeepCollectionEquality()
                .equals(other._fullDayTrips, _fullDayTrips) &&
            (identical(other.departureGeohash5, departureGeohash5) ||
                other.departureGeohash5 == departureGeohash5) &&
            const DeepCollectionEquality().equals(other._errors, _errors));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_halfDayTrips),
      const DeepCollectionEquality().hash(_fullDayTrips),
      departureGeohash5,
      const DeepCollectionEquality().hash(_errors));

  /// Create a copy of EmptyTripGenerationResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$EmptyTripGenerationResultImplCopyWith<_$EmptyTripGenerationResultImpl>
      get copyWith => __$$EmptyTripGenerationResultImplCopyWithImpl<
          _$EmptyTripGenerationResultImpl>(this, _$identity);
}

abstract class _EmptyTripGenerationResult implements EmptyTripGenerationResult {
  const factory _EmptyTripGenerationResult(
      {required final List<EmptyDailyTrip> halfDayTrips,
      required final List<EmptyDailyTrip> fullDayTrips,
      required final String departureGeohash5,
      required final List<String> errors}) = _$EmptyTripGenerationResultImpl;

  @override
  List<EmptyDailyTrip> get halfDayTrips;
  @override
  List<EmptyDailyTrip> get fullDayTrips;
  @override
  String get departureGeohash5;
  @override
  List<String> get errors;

  /// Create a copy of EmptyTripGenerationResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$EmptyTripGenerationResultImplCopyWith<_$EmptyTripGenerationResultImpl>
      get copyWith => throw _privateConstructorUsedError;
}
