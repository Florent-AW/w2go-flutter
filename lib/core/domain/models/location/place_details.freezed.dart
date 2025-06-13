// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'place_details.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

PlaceDetails _$PlaceDetailsFromJson(Map<String, dynamic> json) {
  return _PlaceDetails.fromJson(json);
}

/// @nodoc
mixin _$PlaceDetails {
  String get placeId => throw _privateConstructorUsedError;
  String get formattedAddress => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  UserLocation get location => throw _privateConstructorUsedError;
  String? get country => throw _privateConstructorUsedError;
  String? get administrativeArea => throw _privateConstructorUsedError;
  String? get locality => throw _privateConstructorUsedError;
  String? get postalCode => throw _privateConstructorUsedError;
  DateTime? get lastUpdated => throw _privateConstructorUsedError;
  List<AddressComponent>? get addressComponents =>
      throw _privateConstructorUsedError;

  /// Serializes this PlaceDetails to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PlaceDetails
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PlaceDetailsCopyWith<PlaceDetails> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PlaceDetailsCopyWith<$Res> {
  factory $PlaceDetailsCopyWith(
          PlaceDetails value, $Res Function(PlaceDetails) then) =
      _$PlaceDetailsCopyWithImpl<$Res, PlaceDetails>;
  @useResult
  $Res call(
      {String placeId,
      String formattedAddress,
      String name,
      UserLocation location,
      String? country,
      String? administrativeArea,
      String? locality,
      String? postalCode,
      DateTime? lastUpdated,
      List<AddressComponent>? addressComponents});

  $UserLocationCopyWith<$Res> get location;
}

/// @nodoc
class _$PlaceDetailsCopyWithImpl<$Res, $Val extends PlaceDetails>
    implements $PlaceDetailsCopyWith<$Res> {
  _$PlaceDetailsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PlaceDetails
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? placeId = null,
    Object? formattedAddress = null,
    Object? name = null,
    Object? location = null,
    Object? country = freezed,
    Object? administrativeArea = freezed,
    Object? locality = freezed,
    Object? postalCode = freezed,
    Object? lastUpdated = freezed,
    Object? addressComponents = freezed,
  }) {
    return _then(_value.copyWith(
      placeId: null == placeId
          ? _value.placeId
          : placeId // ignore: cast_nullable_to_non_nullable
              as String,
      formattedAddress: null == formattedAddress
          ? _value.formattedAddress
          : formattedAddress // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      location: null == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as UserLocation,
      country: freezed == country
          ? _value.country
          : country // ignore: cast_nullable_to_non_nullable
              as String?,
      administrativeArea: freezed == administrativeArea
          ? _value.administrativeArea
          : administrativeArea // ignore: cast_nullable_to_non_nullable
              as String?,
      locality: freezed == locality
          ? _value.locality
          : locality // ignore: cast_nullable_to_non_nullable
              as String?,
      postalCode: freezed == postalCode
          ? _value.postalCode
          : postalCode // ignore: cast_nullable_to_non_nullable
              as String?,
      lastUpdated: freezed == lastUpdated
          ? _value.lastUpdated
          : lastUpdated // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      addressComponents: freezed == addressComponents
          ? _value.addressComponents
          : addressComponents // ignore: cast_nullable_to_non_nullable
              as List<AddressComponent>?,
    ) as $Val);
  }

  /// Create a copy of PlaceDetails
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $UserLocationCopyWith<$Res> get location {
    return $UserLocationCopyWith<$Res>(_value.location, (value) {
      return _then(_value.copyWith(location: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$PlaceDetailsImplCopyWith<$Res>
    implements $PlaceDetailsCopyWith<$Res> {
  factory _$$PlaceDetailsImplCopyWith(
          _$PlaceDetailsImpl value, $Res Function(_$PlaceDetailsImpl) then) =
      __$$PlaceDetailsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String placeId,
      String formattedAddress,
      String name,
      UserLocation location,
      String? country,
      String? administrativeArea,
      String? locality,
      String? postalCode,
      DateTime? lastUpdated,
      List<AddressComponent>? addressComponents});

  @override
  $UserLocationCopyWith<$Res> get location;
}

/// @nodoc
class __$$PlaceDetailsImplCopyWithImpl<$Res>
    extends _$PlaceDetailsCopyWithImpl<$Res, _$PlaceDetailsImpl>
    implements _$$PlaceDetailsImplCopyWith<$Res> {
  __$$PlaceDetailsImplCopyWithImpl(
      _$PlaceDetailsImpl _value, $Res Function(_$PlaceDetailsImpl) _then)
      : super(_value, _then);

  /// Create a copy of PlaceDetails
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? placeId = null,
    Object? formattedAddress = null,
    Object? name = null,
    Object? location = null,
    Object? country = freezed,
    Object? administrativeArea = freezed,
    Object? locality = freezed,
    Object? postalCode = freezed,
    Object? lastUpdated = freezed,
    Object? addressComponents = freezed,
  }) {
    return _then(_$PlaceDetailsImpl(
      placeId: null == placeId
          ? _value.placeId
          : placeId // ignore: cast_nullable_to_non_nullable
              as String,
      formattedAddress: null == formattedAddress
          ? _value.formattedAddress
          : formattedAddress // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      location: null == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as UserLocation,
      country: freezed == country
          ? _value.country
          : country // ignore: cast_nullable_to_non_nullable
              as String?,
      administrativeArea: freezed == administrativeArea
          ? _value.administrativeArea
          : administrativeArea // ignore: cast_nullable_to_non_nullable
              as String?,
      locality: freezed == locality
          ? _value.locality
          : locality // ignore: cast_nullable_to_non_nullable
              as String?,
      postalCode: freezed == postalCode
          ? _value.postalCode
          : postalCode // ignore: cast_nullable_to_non_nullable
              as String?,
      lastUpdated: freezed == lastUpdated
          ? _value.lastUpdated
          : lastUpdated // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      addressComponents: freezed == addressComponents
          ? _value._addressComponents
          : addressComponents // ignore: cast_nullable_to_non_nullable
              as List<AddressComponent>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PlaceDetailsImpl implements _PlaceDetails {
  const _$PlaceDetailsImpl(
      {required this.placeId,
      required this.formattedAddress,
      required this.name,
      required this.location,
      this.country,
      this.administrativeArea,
      this.locality,
      this.postalCode,
      this.lastUpdated,
      final List<AddressComponent>? addressComponents})
      : _addressComponents = addressComponents;

  factory _$PlaceDetailsImpl.fromJson(Map<String, dynamic> json) =>
      _$$PlaceDetailsImplFromJson(json);

  @override
  final String placeId;
  @override
  final String formattedAddress;
  @override
  final String name;
  @override
  final UserLocation location;
  @override
  final String? country;
  @override
  final String? administrativeArea;
  @override
  final String? locality;
  @override
  final String? postalCode;
  @override
  final DateTime? lastUpdated;
  final List<AddressComponent>? _addressComponents;
  @override
  List<AddressComponent>? get addressComponents {
    final value = _addressComponents;
    if (value == null) return null;
    if (_addressComponents is EqualUnmodifiableListView)
      return _addressComponents;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'PlaceDetails(placeId: $placeId, formattedAddress: $formattedAddress, name: $name, location: $location, country: $country, administrativeArea: $administrativeArea, locality: $locality, postalCode: $postalCode, lastUpdated: $lastUpdated, addressComponents: $addressComponents)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PlaceDetailsImpl &&
            (identical(other.placeId, placeId) || other.placeId == placeId) &&
            (identical(other.formattedAddress, formattedAddress) ||
                other.formattedAddress == formattedAddress) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.location, location) ||
                other.location == location) &&
            (identical(other.country, country) || other.country == country) &&
            (identical(other.administrativeArea, administrativeArea) ||
                other.administrativeArea == administrativeArea) &&
            (identical(other.locality, locality) ||
                other.locality == locality) &&
            (identical(other.postalCode, postalCode) ||
                other.postalCode == postalCode) &&
            (identical(other.lastUpdated, lastUpdated) ||
                other.lastUpdated == lastUpdated) &&
            const DeepCollectionEquality()
                .equals(other._addressComponents, _addressComponents));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      placeId,
      formattedAddress,
      name,
      location,
      country,
      administrativeArea,
      locality,
      postalCode,
      lastUpdated,
      const DeepCollectionEquality().hash(_addressComponents));

  /// Create a copy of PlaceDetails
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PlaceDetailsImplCopyWith<_$PlaceDetailsImpl> get copyWith =>
      __$$PlaceDetailsImplCopyWithImpl<_$PlaceDetailsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PlaceDetailsImplToJson(
      this,
    );
  }
}

abstract class _PlaceDetails implements PlaceDetails {
  const factory _PlaceDetails(
      {required final String placeId,
      required final String formattedAddress,
      required final String name,
      required final UserLocation location,
      final String? country,
      final String? administrativeArea,
      final String? locality,
      final String? postalCode,
      final DateTime? lastUpdated,
      final List<AddressComponent>? addressComponents}) = _$PlaceDetailsImpl;

  factory _PlaceDetails.fromJson(Map<String, dynamic> json) =
      _$PlaceDetailsImpl.fromJson;

  @override
  String get placeId;
  @override
  String get formattedAddress;
  @override
  String get name;
  @override
  UserLocation get location;
  @override
  String? get country;
  @override
  String? get administrativeArea;
  @override
  String? get locality;
  @override
  String? get postalCode;
  @override
  DateTime? get lastUpdated;
  @override
  List<AddressComponent>? get addressComponents;

  /// Create a copy of PlaceDetails
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PlaceDetailsImplCopyWith<_$PlaceDetailsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

AddressComponent _$AddressComponentFromJson(Map<String, dynamic> json) {
  return _AddressComponent.fromJson(json);
}

/// @nodoc
mixin _$AddressComponent {
  String get longName => throw _privateConstructorUsedError;
  String get shortName => throw _privateConstructorUsedError;
  List<String> get types => throw _privateConstructorUsedError;

  /// Serializes this AddressComponent to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AddressComponent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AddressComponentCopyWith<AddressComponent> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AddressComponentCopyWith<$Res> {
  factory $AddressComponentCopyWith(
          AddressComponent value, $Res Function(AddressComponent) then) =
      _$AddressComponentCopyWithImpl<$Res, AddressComponent>;
  @useResult
  $Res call({String longName, String shortName, List<String> types});
}

/// @nodoc
class _$AddressComponentCopyWithImpl<$Res, $Val extends AddressComponent>
    implements $AddressComponentCopyWith<$Res> {
  _$AddressComponentCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AddressComponent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? longName = null,
    Object? shortName = null,
    Object? types = null,
  }) {
    return _then(_value.copyWith(
      longName: null == longName
          ? _value.longName
          : longName // ignore: cast_nullable_to_non_nullable
              as String,
      shortName: null == shortName
          ? _value.shortName
          : shortName // ignore: cast_nullable_to_non_nullable
              as String,
      types: null == types
          ? _value.types
          : types // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AddressComponentImplCopyWith<$Res>
    implements $AddressComponentCopyWith<$Res> {
  factory _$$AddressComponentImplCopyWith(_$AddressComponentImpl value,
          $Res Function(_$AddressComponentImpl) then) =
      __$$AddressComponentImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String longName, String shortName, List<String> types});
}

/// @nodoc
class __$$AddressComponentImplCopyWithImpl<$Res>
    extends _$AddressComponentCopyWithImpl<$Res, _$AddressComponentImpl>
    implements _$$AddressComponentImplCopyWith<$Res> {
  __$$AddressComponentImplCopyWithImpl(_$AddressComponentImpl _value,
      $Res Function(_$AddressComponentImpl) _then)
      : super(_value, _then);

  /// Create a copy of AddressComponent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? longName = null,
    Object? shortName = null,
    Object? types = null,
  }) {
    return _then(_$AddressComponentImpl(
      longName: null == longName
          ? _value.longName
          : longName // ignore: cast_nullable_to_non_nullable
              as String,
      shortName: null == shortName
          ? _value.shortName
          : shortName // ignore: cast_nullable_to_non_nullable
              as String,
      types: null == types
          ? _value._types
          : types // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AddressComponentImpl implements _AddressComponent {
  const _$AddressComponentImpl(
      {required this.longName,
      required this.shortName,
      required final List<String> types})
      : _types = types;

  factory _$AddressComponentImpl.fromJson(Map<String, dynamic> json) =>
      _$$AddressComponentImplFromJson(json);

  @override
  final String longName;
  @override
  final String shortName;
  final List<String> _types;
  @override
  List<String> get types {
    if (_types is EqualUnmodifiableListView) return _types;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_types);
  }

  @override
  String toString() {
    return 'AddressComponent(longName: $longName, shortName: $shortName, types: $types)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AddressComponentImpl &&
            (identical(other.longName, longName) ||
                other.longName == longName) &&
            (identical(other.shortName, shortName) ||
                other.shortName == shortName) &&
            const DeepCollectionEquality().equals(other._types, _types));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, longName, shortName,
      const DeepCollectionEquality().hash(_types));

  /// Create a copy of AddressComponent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AddressComponentImplCopyWith<_$AddressComponentImpl> get copyWith =>
      __$$AddressComponentImplCopyWithImpl<_$AddressComponentImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AddressComponentImplToJson(
      this,
    );
  }
}

abstract class _AddressComponent implements AddressComponent {
  const factory _AddressComponent(
      {required final String longName,
      required final String shortName,
      required final List<String> types}) = _$AddressComponentImpl;

  factory _AddressComponent.fromJson(Map<String, dynamic> json) =
      _$AddressComponentImpl.fromJson;

  @override
  String get longName;
  @override
  String get shortName;
  @override
  List<String> get types;

  /// Create a copy of AddressComponent
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AddressComponentImplCopyWith<_$AddressComponentImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
