// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'searchable_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

SearchableEvent _$SearchableEventFromJson(Map<String, dynamic> json) {
  return _SearchableEvent.fromJson(json);
}

/// @nodoc
mixin _$SearchableEvent {
  EventBase get base => throw _privateConstructorUsedError;
  String? get categoryName => throw _privateConstructorUsedError;
  String? get subcategoryName => throw _privateConstructorUsedError;
  String? get subcategoryIcon => throw _privateConstructorUsedError;
  String? get geohash4 => throw _privateConstructorUsedError;
  String? get geohash5 => throw _privateConstructorUsedError;
  double? get approxDistanceKm => throw _privateConstructorUsedError;
  double? get distance => throw _privateConstructorUsedError;
  String? get city => throw _privateConstructorUsedError;
  String? get mainImageUrl => throw _privateConstructorUsedError;
  List<String>? get momentPreferences => throw _privateConstructorUsedError;
  List<String>? get weatherPreferences => throw _privateConstructorUsedError;

  /// Serializes this SearchableEvent to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SearchableEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SearchableEventCopyWith<SearchableEvent> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SearchableEventCopyWith<$Res> {
  factory $SearchableEventCopyWith(
          SearchableEvent value, $Res Function(SearchableEvent) then) =
      _$SearchableEventCopyWithImpl<$Res, SearchableEvent>;
  @useResult
  $Res call(
      {EventBase base,
      String? categoryName,
      String? subcategoryName,
      String? subcategoryIcon,
      String? geohash4,
      String? geohash5,
      double? approxDistanceKm,
      double? distance,
      String? city,
      String? mainImageUrl,
      List<String>? momentPreferences,
      List<String>? weatherPreferences});

  $EventBaseCopyWith<$Res> get base;
}

/// @nodoc
class _$SearchableEventCopyWithImpl<$Res, $Val extends SearchableEvent>
    implements $SearchableEventCopyWith<$Res> {
  _$SearchableEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SearchableEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? base = null,
    Object? categoryName = freezed,
    Object? subcategoryName = freezed,
    Object? subcategoryIcon = freezed,
    Object? geohash4 = freezed,
    Object? geohash5 = freezed,
    Object? approxDistanceKm = freezed,
    Object? distance = freezed,
    Object? city = freezed,
    Object? mainImageUrl = freezed,
    Object? momentPreferences = freezed,
    Object? weatherPreferences = freezed,
  }) {
    return _then(_value.copyWith(
      base: null == base
          ? _value.base
          : base // ignore: cast_nullable_to_non_nullable
              as EventBase,
      categoryName: freezed == categoryName
          ? _value.categoryName
          : categoryName // ignore: cast_nullable_to_non_nullable
              as String?,
      subcategoryName: freezed == subcategoryName
          ? _value.subcategoryName
          : subcategoryName // ignore: cast_nullable_to_non_nullable
              as String?,
      subcategoryIcon: freezed == subcategoryIcon
          ? _value.subcategoryIcon
          : subcategoryIcon // ignore: cast_nullable_to_non_nullable
              as String?,
      geohash4: freezed == geohash4
          ? _value.geohash4
          : geohash4 // ignore: cast_nullable_to_non_nullable
              as String?,
      geohash5: freezed == geohash5
          ? _value.geohash5
          : geohash5 // ignore: cast_nullable_to_non_nullable
              as String?,
      approxDistanceKm: freezed == approxDistanceKm
          ? _value.approxDistanceKm
          : approxDistanceKm // ignore: cast_nullable_to_non_nullable
              as double?,
      distance: freezed == distance
          ? _value.distance
          : distance // ignore: cast_nullable_to_non_nullable
              as double?,
      city: freezed == city
          ? _value.city
          : city // ignore: cast_nullable_to_non_nullable
              as String?,
      mainImageUrl: freezed == mainImageUrl
          ? _value.mainImageUrl
          : mainImageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      momentPreferences: freezed == momentPreferences
          ? _value.momentPreferences
          : momentPreferences // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      weatherPreferences: freezed == weatherPreferences
          ? _value.weatherPreferences
          : weatherPreferences // ignore: cast_nullable_to_non_nullable
              as List<String>?,
    ) as $Val);
  }

  /// Create a copy of SearchableEvent
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $EventBaseCopyWith<$Res> get base {
    return $EventBaseCopyWith<$Res>(_value.base, (value) {
      return _then(_value.copyWith(base: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$SearchableEventImplCopyWith<$Res>
    implements $SearchableEventCopyWith<$Res> {
  factory _$$SearchableEventImplCopyWith(_$SearchableEventImpl value,
          $Res Function(_$SearchableEventImpl) then) =
      __$$SearchableEventImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {EventBase base,
      String? categoryName,
      String? subcategoryName,
      String? subcategoryIcon,
      String? geohash4,
      String? geohash5,
      double? approxDistanceKm,
      double? distance,
      String? city,
      String? mainImageUrl,
      List<String>? momentPreferences,
      List<String>? weatherPreferences});

  @override
  $EventBaseCopyWith<$Res> get base;
}

/// @nodoc
class __$$SearchableEventImplCopyWithImpl<$Res>
    extends _$SearchableEventCopyWithImpl<$Res, _$SearchableEventImpl>
    implements _$$SearchableEventImplCopyWith<$Res> {
  __$$SearchableEventImplCopyWithImpl(
      _$SearchableEventImpl _value, $Res Function(_$SearchableEventImpl) _then)
      : super(_value, _then);

  /// Create a copy of SearchableEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? base = null,
    Object? categoryName = freezed,
    Object? subcategoryName = freezed,
    Object? subcategoryIcon = freezed,
    Object? geohash4 = freezed,
    Object? geohash5 = freezed,
    Object? approxDistanceKm = freezed,
    Object? distance = freezed,
    Object? city = freezed,
    Object? mainImageUrl = freezed,
    Object? momentPreferences = freezed,
    Object? weatherPreferences = freezed,
  }) {
    return _then(_$SearchableEventImpl(
      base: null == base
          ? _value.base
          : base // ignore: cast_nullable_to_non_nullable
              as EventBase,
      categoryName: freezed == categoryName
          ? _value.categoryName
          : categoryName // ignore: cast_nullable_to_non_nullable
              as String?,
      subcategoryName: freezed == subcategoryName
          ? _value.subcategoryName
          : subcategoryName // ignore: cast_nullable_to_non_nullable
              as String?,
      subcategoryIcon: freezed == subcategoryIcon
          ? _value.subcategoryIcon
          : subcategoryIcon // ignore: cast_nullable_to_non_nullable
              as String?,
      geohash4: freezed == geohash4
          ? _value.geohash4
          : geohash4 // ignore: cast_nullable_to_non_nullable
              as String?,
      geohash5: freezed == geohash5
          ? _value.geohash5
          : geohash5 // ignore: cast_nullable_to_non_nullable
              as String?,
      approxDistanceKm: freezed == approxDistanceKm
          ? _value.approxDistanceKm
          : approxDistanceKm // ignore: cast_nullable_to_non_nullable
              as double?,
      distance: freezed == distance
          ? _value.distance
          : distance // ignore: cast_nullable_to_non_nullable
              as double?,
      city: freezed == city
          ? _value.city
          : city // ignore: cast_nullable_to_non_nullable
              as String?,
      mainImageUrl: freezed == mainImageUrl
          ? _value.mainImageUrl
          : mainImageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      momentPreferences: freezed == momentPreferences
          ? _value._momentPreferences
          : momentPreferences // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      weatherPreferences: freezed == weatherPreferences
          ? _value._weatherPreferences
          : weatherPreferences // ignore: cast_nullable_to_non_nullable
              as List<String>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SearchableEventImpl implements _SearchableEvent {
  const _$SearchableEventImpl(
      {required this.base,
      this.categoryName,
      this.subcategoryName,
      this.subcategoryIcon,
      this.geohash4,
      this.geohash5,
      this.approxDistanceKm,
      this.distance,
      this.city,
      this.mainImageUrl,
      final List<String>? momentPreferences,
      final List<String>? weatherPreferences})
      : _momentPreferences = momentPreferences,
        _weatherPreferences = weatherPreferences;

  factory _$SearchableEventImpl.fromJson(Map<String, dynamic> json) =>
      _$$SearchableEventImplFromJson(json);

  @override
  final EventBase base;
  @override
  final String? categoryName;
  @override
  final String? subcategoryName;
  @override
  final String? subcategoryIcon;
  @override
  final String? geohash4;
  @override
  final String? geohash5;
  @override
  final double? approxDistanceKm;
  @override
  final double? distance;
  @override
  final String? city;
  @override
  final String? mainImageUrl;
  final List<String>? _momentPreferences;
  @override
  List<String>? get momentPreferences {
    final value = _momentPreferences;
    if (value == null) return null;
    if (_momentPreferences is EqualUnmodifiableListView)
      return _momentPreferences;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<String>? _weatherPreferences;
  @override
  List<String>? get weatherPreferences {
    final value = _weatherPreferences;
    if (value == null) return null;
    if (_weatherPreferences is EqualUnmodifiableListView)
      return _weatherPreferences;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'SearchableEvent(base: $base, categoryName: $categoryName, subcategoryName: $subcategoryName, subcategoryIcon: $subcategoryIcon, geohash4: $geohash4, geohash5: $geohash5, approxDistanceKm: $approxDistanceKm, distance: $distance, city: $city, mainImageUrl: $mainImageUrl, momentPreferences: $momentPreferences, weatherPreferences: $weatherPreferences)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SearchableEventImpl &&
            (identical(other.base, base) || other.base == base) &&
            (identical(other.categoryName, categoryName) ||
                other.categoryName == categoryName) &&
            (identical(other.subcategoryName, subcategoryName) ||
                other.subcategoryName == subcategoryName) &&
            (identical(other.subcategoryIcon, subcategoryIcon) ||
                other.subcategoryIcon == subcategoryIcon) &&
            (identical(other.geohash4, geohash4) ||
                other.geohash4 == geohash4) &&
            (identical(other.geohash5, geohash5) ||
                other.geohash5 == geohash5) &&
            (identical(other.approxDistanceKm, approxDistanceKm) ||
                other.approxDistanceKm == approxDistanceKm) &&
            (identical(other.distance, distance) ||
                other.distance == distance) &&
            (identical(other.city, city) || other.city == city) &&
            (identical(other.mainImageUrl, mainImageUrl) ||
                other.mainImageUrl == mainImageUrl) &&
            const DeepCollectionEquality()
                .equals(other._momentPreferences, _momentPreferences) &&
            const DeepCollectionEquality()
                .equals(other._weatherPreferences, _weatherPreferences));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      base,
      categoryName,
      subcategoryName,
      subcategoryIcon,
      geohash4,
      geohash5,
      approxDistanceKm,
      distance,
      city,
      mainImageUrl,
      const DeepCollectionEquality().hash(_momentPreferences),
      const DeepCollectionEquality().hash(_weatherPreferences));

  /// Create a copy of SearchableEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SearchableEventImplCopyWith<_$SearchableEventImpl> get copyWith =>
      __$$SearchableEventImplCopyWithImpl<_$SearchableEventImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SearchableEventImplToJson(
      this,
    );
  }
}

abstract class _SearchableEvent implements SearchableEvent {
  const factory _SearchableEvent(
      {required final EventBase base,
      final String? categoryName,
      final String? subcategoryName,
      final String? subcategoryIcon,
      final String? geohash4,
      final String? geohash5,
      final double? approxDistanceKm,
      final double? distance,
      final String? city,
      final String? mainImageUrl,
      final List<String>? momentPreferences,
      final List<String>? weatherPreferences}) = _$SearchableEventImpl;

  factory _SearchableEvent.fromJson(Map<String, dynamic> json) =
      _$SearchableEventImpl.fromJson;

  @override
  EventBase get base;
  @override
  String? get categoryName;
  @override
  String? get subcategoryName;
  @override
  String? get subcategoryIcon;
  @override
  String? get geohash4;
  @override
  String? get geohash5;
  @override
  double? get approxDistanceKm;
  @override
  double? get distance;
  @override
  String? get city;
  @override
  String? get mainImageUrl;
  @override
  List<String>? get momentPreferences;
  @override
  List<String>? get weatherPreferences;

  /// Create a copy of SearchableEvent
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SearchableEventImplCopyWith<_$SearchableEventImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
