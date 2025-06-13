// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'recent_city.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

RecentCity _$RecentCityFromJson(Map<String, dynamic> json) {
  return _RecentCity.fromJson(json);
}

/// @nodoc
mixin _$RecentCity {
  City get city => throw _privateConstructorUsedError;
  DateTime get timestamp => throw _privateConstructorUsedError;

  /// Serializes this RecentCity to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RecentCity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RecentCityCopyWith<RecentCity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RecentCityCopyWith<$Res> {
  factory $RecentCityCopyWith(
          RecentCity value, $Res Function(RecentCity) then) =
      _$RecentCityCopyWithImpl<$Res, RecentCity>;
  @useResult
  $Res call({City city, DateTime timestamp});
}

/// @nodoc
class _$RecentCityCopyWithImpl<$Res, $Val extends RecentCity>
    implements $RecentCityCopyWith<$Res> {
  _$RecentCityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RecentCity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? city = null,
    Object? timestamp = null,
  }) {
    return _then(_value.copyWith(
      city: null == city
          ? _value.city
          : city // ignore: cast_nullable_to_non_nullable
              as City,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RecentCityImplCopyWith<$Res>
    implements $RecentCityCopyWith<$Res> {
  factory _$$RecentCityImplCopyWith(
          _$RecentCityImpl value, $Res Function(_$RecentCityImpl) then) =
      __$$RecentCityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({City city, DateTime timestamp});
}

/// @nodoc
class __$$RecentCityImplCopyWithImpl<$Res>
    extends _$RecentCityCopyWithImpl<$Res, _$RecentCityImpl>
    implements _$$RecentCityImplCopyWith<$Res> {
  __$$RecentCityImplCopyWithImpl(
      _$RecentCityImpl _value, $Res Function(_$RecentCityImpl) _then)
      : super(_value, _then);

  /// Create a copy of RecentCity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? city = null,
    Object? timestamp = null,
  }) {
    return _then(_$RecentCityImpl(
      city: null == city
          ? _value.city
          : city // ignore: cast_nullable_to_non_nullable
              as City,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$RecentCityImpl implements _RecentCity {
  const _$RecentCityImpl({required this.city, required this.timestamp});

  factory _$RecentCityImpl.fromJson(Map<String, dynamic> json) =>
      _$$RecentCityImplFromJson(json);

  @override
  final City city;
  @override
  final DateTime timestamp;

  @override
  String toString() {
    return 'RecentCity(city: $city, timestamp: $timestamp)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RecentCityImpl &&
            (identical(other.city, city) || other.city == city) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, city, timestamp);

  /// Create a copy of RecentCity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RecentCityImplCopyWith<_$RecentCityImpl> get copyWith =>
      __$$RecentCityImplCopyWithImpl<_$RecentCityImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RecentCityImplToJson(
      this,
    );
  }
}

abstract class _RecentCity implements RecentCity {
  const factory _RecentCity(
      {required final City city,
      required final DateTime timestamp}) = _$RecentCityImpl;

  factory _RecentCity.fromJson(Map<String, dynamic> json) =
      _$RecentCityImpl.fromJson;

  @override
  City get city;
  @override
  DateTime get timestamp;

  /// Create a copy of RecentCity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RecentCityImplCopyWith<_$RecentCityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
