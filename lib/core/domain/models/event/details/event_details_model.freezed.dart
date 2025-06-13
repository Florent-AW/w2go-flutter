// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'event_details_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

EventDetails _$EventDetailsFromJson(Map<String, dynamic> json) {
  return _EventDetails.fromJson(json);
}

/// @nodoc
mixin _$EventDetails {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  double get latitude => throw _privateConstructorUsedError;
  double get longitude => throw _privateConstructorUsedError;
  String get categoryId => throw _privateConstructorUsedError;
  String? get categoryName => throw _privateConstructorUsedError;
  String? get subcategoryName => throw _privateConstructorUsedError;
  String? get subcategoryIcon => throw _privateConstructorUsedError;
  String? get postalCode => throw _privateConstructorUsedError;
  String? get address => throw _privateConstructorUsedError;
  String? get city => throw _privateConstructorUsedError;
  String? get googlePlaceId => throw _privateConstructorUsedError;
  Map<String, dynamic>? get currentOpeningHours =>
      throw _privateConstructorUsedError;
  String? get contactPhone => throw _privateConstructorUsedError;
  String? get contactEmail => throw _privateConstructorUsedError;
  String? get contactWebsite => throw _privateConstructorUsedError;
  String? get bookingLevel => throw _privateConstructorUsedError;
  bool? get kidFriendly => throw _privateConstructorUsedError;
  String? get wheelchairAccessible => throw _privateConstructorUsedError;
  int? get minDurationMinutes => throw _privateConstructorUsedError;
  int? get maxDurationMinutes => throw _privateConstructorUsedError;
  int? get priceLevel => throw _privateConstructorUsedError;
  double? get basePrice => throw _privateConstructorUsedError;
  List<EventImage>? get images =>
      throw _privateConstructorUsedError; // ✅ CHAMPS SPÉCIFIQUES AUX EVENTS
  DateTime get startDate => throw _privateConstructorUsedError;
  DateTime get endDate => throw _privateConstructorUsedError;
  bool get bookingRequired => throw _privateConstructorUsedError;
  bool get hasMultipleOccurrences => throw _privateConstructorUsedError;
  bool get isRecurring => throw _privateConstructorUsedError;

  /// Serializes this EventDetails to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of EventDetails
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $EventDetailsCopyWith<EventDetails> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EventDetailsCopyWith<$Res> {
  factory $EventDetailsCopyWith(
          EventDetails value, $Res Function(EventDetails) then) =
      _$EventDetailsCopyWithImpl<$Res, EventDetails>;
  @useResult
  $Res call(
      {String id,
      String name,
      String? description,
      double latitude,
      double longitude,
      String categoryId,
      String? categoryName,
      String? subcategoryName,
      String? subcategoryIcon,
      String? postalCode,
      String? address,
      String? city,
      String? googlePlaceId,
      Map<String, dynamic>? currentOpeningHours,
      String? contactPhone,
      String? contactEmail,
      String? contactWebsite,
      String? bookingLevel,
      bool? kidFriendly,
      String? wheelchairAccessible,
      int? minDurationMinutes,
      int? maxDurationMinutes,
      int? priceLevel,
      double? basePrice,
      List<EventImage>? images,
      DateTime startDate,
      DateTime endDate,
      bool bookingRequired,
      bool hasMultipleOccurrences,
      bool isRecurring});
}

/// @nodoc
class _$EventDetailsCopyWithImpl<$Res, $Val extends EventDetails>
    implements $EventDetailsCopyWith<$Res> {
  _$EventDetailsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of EventDetails
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = freezed,
    Object? latitude = null,
    Object? longitude = null,
    Object? categoryId = null,
    Object? categoryName = freezed,
    Object? subcategoryName = freezed,
    Object? subcategoryIcon = freezed,
    Object? postalCode = freezed,
    Object? address = freezed,
    Object? city = freezed,
    Object? googlePlaceId = freezed,
    Object? currentOpeningHours = freezed,
    Object? contactPhone = freezed,
    Object? contactEmail = freezed,
    Object? contactWebsite = freezed,
    Object? bookingLevel = freezed,
    Object? kidFriendly = freezed,
    Object? wheelchairAccessible = freezed,
    Object? minDurationMinutes = freezed,
    Object? maxDurationMinutes = freezed,
    Object? priceLevel = freezed,
    Object? basePrice = freezed,
    Object? images = freezed,
    Object? startDate = null,
    Object? endDate = null,
    Object? bookingRequired = null,
    Object? hasMultipleOccurrences = null,
    Object? isRecurring = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      latitude: null == latitude
          ? _value.latitude
          : latitude // ignore: cast_nullable_to_non_nullable
              as double,
      longitude: null == longitude
          ? _value.longitude
          : longitude // ignore: cast_nullable_to_non_nullable
              as double,
      categoryId: null == categoryId
          ? _value.categoryId
          : categoryId // ignore: cast_nullable_to_non_nullable
              as String,
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
      postalCode: freezed == postalCode
          ? _value.postalCode
          : postalCode // ignore: cast_nullable_to_non_nullable
              as String?,
      address: freezed == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String?,
      city: freezed == city
          ? _value.city
          : city // ignore: cast_nullable_to_non_nullable
              as String?,
      googlePlaceId: freezed == googlePlaceId
          ? _value.googlePlaceId
          : googlePlaceId // ignore: cast_nullable_to_non_nullable
              as String?,
      currentOpeningHours: freezed == currentOpeningHours
          ? _value.currentOpeningHours
          : currentOpeningHours // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      contactPhone: freezed == contactPhone
          ? _value.contactPhone
          : contactPhone // ignore: cast_nullable_to_non_nullable
              as String?,
      contactEmail: freezed == contactEmail
          ? _value.contactEmail
          : contactEmail // ignore: cast_nullable_to_non_nullable
              as String?,
      contactWebsite: freezed == contactWebsite
          ? _value.contactWebsite
          : contactWebsite // ignore: cast_nullable_to_non_nullable
              as String?,
      bookingLevel: freezed == bookingLevel
          ? _value.bookingLevel
          : bookingLevel // ignore: cast_nullable_to_non_nullable
              as String?,
      kidFriendly: freezed == kidFriendly
          ? _value.kidFriendly
          : kidFriendly // ignore: cast_nullable_to_non_nullable
              as bool?,
      wheelchairAccessible: freezed == wheelchairAccessible
          ? _value.wheelchairAccessible
          : wheelchairAccessible // ignore: cast_nullable_to_non_nullable
              as String?,
      minDurationMinutes: freezed == minDurationMinutes
          ? _value.minDurationMinutes
          : minDurationMinutes // ignore: cast_nullable_to_non_nullable
              as int?,
      maxDurationMinutes: freezed == maxDurationMinutes
          ? _value.maxDurationMinutes
          : maxDurationMinutes // ignore: cast_nullable_to_non_nullable
              as int?,
      priceLevel: freezed == priceLevel
          ? _value.priceLevel
          : priceLevel // ignore: cast_nullable_to_non_nullable
              as int?,
      basePrice: freezed == basePrice
          ? _value.basePrice
          : basePrice // ignore: cast_nullable_to_non_nullable
              as double?,
      images: freezed == images
          ? _value.images
          : images // ignore: cast_nullable_to_non_nullable
              as List<EventImage>?,
      startDate: null == startDate
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endDate: null == endDate
          ? _value.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      bookingRequired: null == bookingRequired
          ? _value.bookingRequired
          : bookingRequired // ignore: cast_nullable_to_non_nullable
              as bool,
      hasMultipleOccurrences: null == hasMultipleOccurrences
          ? _value.hasMultipleOccurrences
          : hasMultipleOccurrences // ignore: cast_nullable_to_non_nullable
              as bool,
      isRecurring: null == isRecurring
          ? _value.isRecurring
          : isRecurring // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$EventDetailsImplCopyWith<$Res>
    implements $EventDetailsCopyWith<$Res> {
  factory _$$EventDetailsImplCopyWith(
          _$EventDetailsImpl value, $Res Function(_$EventDetailsImpl) then) =
      __$$EventDetailsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      String? description,
      double latitude,
      double longitude,
      String categoryId,
      String? categoryName,
      String? subcategoryName,
      String? subcategoryIcon,
      String? postalCode,
      String? address,
      String? city,
      String? googlePlaceId,
      Map<String, dynamic>? currentOpeningHours,
      String? contactPhone,
      String? contactEmail,
      String? contactWebsite,
      String? bookingLevel,
      bool? kidFriendly,
      String? wheelchairAccessible,
      int? minDurationMinutes,
      int? maxDurationMinutes,
      int? priceLevel,
      double? basePrice,
      List<EventImage>? images,
      DateTime startDate,
      DateTime endDate,
      bool bookingRequired,
      bool hasMultipleOccurrences,
      bool isRecurring});
}

/// @nodoc
class __$$EventDetailsImplCopyWithImpl<$Res>
    extends _$EventDetailsCopyWithImpl<$Res, _$EventDetailsImpl>
    implements _$$EventDetailsImplCopyWith<$Res> {
  __$$EventDetailsImplCopyWithImpl(
      _$EventDetailsImpl _value, $Res Function(_$EventDetailsImpl) _then)
      : super(_value, _then);

  /// Create a copy of EventDetails
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = freezed,
    Object? latitude = null,
    Object? longitude = null,
    Object? categoryId = null,
    Object? categoryName = freezed,
    Object? subcategoryName = freezed,
    Object? subcategoryIcon = freezed,
    Object? postalCode = freezed,
    Object? address = freezed,
    Object? city = freezed,
    Object? googlePlaceId = freezed,
    Object? currentOpeningHours = freezed,
    Object? contactPhone = freezed,
    Object? contactEmail = freezed,
    Object? contactWebsite = freezed,
    Object? bookingLevel = freezed,
    Object? kidFriendly = freezed,
    Object? wheelchairAccessible = freezed,
    Object? minDurationMinutes = freezed,
    Object? maxDurationMinutes = freezed,
    Object? priceLevel = freezed,
    Object? basePrice = freezed,
    Object? images = freezed,
    Object? startDate = null,
    Object? endDate = null,
    Object? bookingRequired = null,
    Object? hasMultipleOccurrences = null,
    Object? isRecurring = null,
  }) {
    return _then(_$EventDetailsImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      latitude: null == latitude
          ? _value.latitude
          : latitude // ignore: cast_nullable_to_non_nullable
              as double,
      longitude: null == longitude
          ? _value.longitude
          : longitude // ignore: cast_nullable_to_non_nullable
              as double,
      categoryId: null == categoryId
          ? _value.categoryId
          : categoryId // ignore: cast_nullable_to_non_nullable
              as String,
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
      postalCode: freezed == postalCode
          ? _value.postalCode
          : postalCode // ignore: cast_nullable_to_non_nullable
              as String?,
      address: freezed == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String?,
      city: freezed == city
          ? _value.city
          : city // ignore: cast_nullable_to_non_nullable
              as String?,
      googlePlaceId: freezed == googlePlaceId
          ? _value.googlePlaceId
          : googlePlaceId // ignore: cast_nullable_to_non_nullable
              as String?,
      currentOpeningHours: freezed == currentOpeningHours
          ? _value._currentOpeningHours
          : currentOpeningHours // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      contactPhone: freezed == contactPhone
          ? _value.contactPhone
          : contactPhone // ignore: cast_nullable_to_non_nullable
              as String?,
      contactEmail: freezed == contactEmail
          ? _value.contactEmail
          : contactEmail // ignore: cast_nullable_to_non_nullable
              as String?,
      contactWebsite: freezed == contactWebsite
          ? _value.contactWebsite
          : contactWebsite // ignore: cast_nullable_to_non_nullable
              as String?,
      bookingLevel: freezed == bookingLevel
          ? _value.bookingLevel
          : bookingLevel // ignore: cast_nullable_to_non_nullable
              as String?,
      kidFriendly: freezed == kidFriendly
          ? _value.kidFriendly
          : kidFriendly // ignore: cast_nullable_to_non_nullable
              as bool?,
      wheelchairAccessible: freezed == wheelchairAccessible
          ? _value.wheelchairAccessible
          : wheelchairAccessible // ignore: cast_nullable_to_non_nullable
              as String?,
      minDurationMinutes: freezed == minDurationMinutes
          ? _value.minDurationMinutes
          : minDurationMinutes // ignore: cast_nullable_to_non_nullable
              as int?,
      maxDurationMinutes: freezed == maxDurationMinutes
          ? _value.maxDurationMinutes
          : maxDurationMinutes // ignore: cast_nullable_to_non_nullable
              as int?,
      priceLevel: freezed == priceLevel
          ? _value.priceLevel
          : priceLevel // ignore: cast_nullable_to_non_nullable
              as int?,
      basePrice: freezed == basePrice
          ? _value.basePrice
          : basePrice // ignore: cast_nullable_to_non_nullable
              as double?,
      images: freezed == images
          ? _value._images
          : images // ignore: cast_nullable_to_non_nullable
              as List<EventImage>?,
      startDate: null == startDate
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endDate: null == endDate
          ? _value.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      bookingRequired: null == bookingRequired
          ? _value.bookingRequired
          : bookingRequired // ignore: cast_nullable_to_non_nullable
              as bool,
      hasMultipleOccurrences: null == hasMultipleOccurrences
          ? _value.hasMultipleOccurrences
          : hasMultipleOccurrences // ignore: cast_nullable_to_non_nullable
              as bool,
      isRecurring: null == isRecurring
          ? _value.isRecurring
          : isRecurring // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$EventDetailsImpl implements _EventDetails {
  const _$EventDetailsImpl(
      {required this.id,
      required this.name,
      this.description,
      required this.latitude,
      required this.longitude,
      required this.categoryId,
      this.categoryName,
      this.subcategoryName,
      this.subcategoryIcon,
      this.postalCode,
      this.address,
      this.city,
      this.googlePlaceId,
      final Map<String, dynamic>? currentOpeningHours,
      this.contactPhone,
      this.contactEmail,
      this.contactWebsite,
      this.bookingLevel,
      this.kidFriendly,
      this.wheelchairAccessible,
      this.minDurationMinutes,
      this.maxDurationMinutes,
      this.priceLevel,
      this.basePrice,
      final List<EventImage>? images,
      required this.startDate,
      required this.endDate,
      this.bookingRequired = false,
      this.hasMultipleOccurrences = false,
      this.isRecurring = false})
      : _currentOpeningHours = currentOpeningHours,
        _images = images;

  factory _$EventDetailsImpl.fromJson(Map<String, dynamic> json) =>
      _$$EventDetailsImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String? description;
  @override
  final double latitude;
  @override
  final double longitude;
  @override
  final String categoryId;
  @override
  final String? categoryName;
  @override
  final String? subcategoryName;
  @override
  final String? subcategoryIcon;
  @override
  final String? postalCode;
  @override
  final String? address;
  @override
  final String? city;
  @override
  final String? googlePlaceId;
  final Map<String, dynamic>? _currentOpeningHours;
  @override
  Map<String, dynamic>? get currentOpeningHours {
    final value = _currentOpeningHours;
    if (value == null) return null;
    if (_currentOpeningHours is EqualUnmodifiableMapView)
      return _currentOpeningHours;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  final String? contactPhone;
  @override
  final String? contactEmail;
  @override
  final String? contactWebsite;
  @override
  final String? bookingLevel;
  @override
  final bool? kidFriendly;
  @override
  final String? wheelchairAccessible;
  @override
  final int? minDurationMinutes;
  @override
  final int? maxDurationMinutes;
  @override
  final int? priceLevel;
  @override
  final double? basePrice;
  final List<EventImage>? _images;
  @override
  List<EventImage>? get images {
    final value = _images;
    if (value == null) return null;
    if (_images is EqualUnmodifiableListView) return _images;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

// ✅ CHAMPS SPÉCIFIQUES AUX EVENTS
  @override
  final DateTime startDate;
  @override
  final DateTime endDate;
  @override
  @JsonKey()
  final bool bookingRequired;
  @override
  @JsonKey()
  final bool hasMultipleOccurrences;
  @override
  @JsonKey()
  final bool isRecurring;

  @override
  String toString() {
    return 'EventDetails(id: $id, name: $name, description: $description, latitude: $latitude, longitude: $longitude, categoryId: $categoryId, categoryName: $categoryName, subcategoryName: $subcategoryName, subcategoryIcon: $subcategoryIcon, postalCode: $postalCode, address: $address, city: $city, googlePlaceId: $googlePlaceId, currentOpeningHours: $currentOpeningHours, contactPhone: $contactPhone, contactEmail: $contactEmail, contactWebsite: $contactWebsite, bookingLevel: $bookingLevel, kidFriendly: $kidFriendly, wheelchairAccessible: $wheelchairAccessible, minDurationMinutes: $minDurationMinutes, maxDurationMinutes: $maxDurationMinutes, priceLevel: $priceLevel, basePrice: $basePrice, images: $images, startDate: $startDate, endDate: $endDate, bookingRequired: $bookingRequired, hasMultipleOccurrences: $hasMultipleOccurrences, isRecurring: $isRecurring)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EventDetailsImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.latitude, latitude) ||
                other.latitude == latitude) &&
            (identical(other.longitude, longitude) ||
                other.longitude == longitude) &&
            (identical(other.categoryId, categoryId) ||
                other.categoryId == categoryId) &&
            (identical(other.categoryName, categoryName) ||
                other.categoryName == categoryName) &&
            (identical(other.subcategoryName, subcategoryName) ||
                other.subcategoryName == subcategoryName) &&
            (identical(other.subcategoryIcon, subcategoryIcon) ||
                other.subcategoryIcon == subcategoryIcon) &&
            (identical(other.postalCode, postalCode) ||
                other.postalCode == postalCode) &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.city, city) || other.city == city) &&
            (identical(other.googlePlaceId, googlePlaceId) ||
                other.googlePlaceId == googlePlaceId) &&
            const DeepCollectionEquality()
                .equals(other._currentOpeningHours, _currentOpeningHours) &&
            (identical(other.contactPhone, contactPhone) ||
                other.contactPhone == contactPhone) &&
            (identical(other.contactEmail, contactEmail) ||
                other.contactEmail == contactEmail) &&
            (identical(other.contactWebsite, contactWebsite) ||
                other.contactWebsite == contactWebsite) &&
            (identical(other.bookingLevel, bookingLevel) ||
                other.bookingLevel == bookingLevel) &&
            (identical(other.kidFriendly, kidFriendly) ||
                other.kidFriendly == kidFriendly) &&
            (identical(other.wheelchairAccessible, wheelchairAccessible) ||
                other.wheelchairAccessible == wheelchairAccessible) &&
            (identical(other.minDurationMinutes, minDurationMinutes) ||
                other.minDurationMinutes == minDurationMinutes) &&
            (identical(other.maxDurationMinutes, maxDurationMinutes) ||
                other.maxDurationMinutes == maxDurationMinutes) &&
            (identical(other.priceLevel, priceLevel) ||
                other.priceLevel == priceLevel) &&
            (identical(other.basePrice, basePrice) ||
                other.basePrice == basePrice) &&
            const DeepCollectionEquality().equals(other._images, _images) &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate) &&
            (identical(other.endDate, endDate) || other.endDate == endDate) &&
            (identical(other.bookingRequired, bookingRequired) ||
                other.bookingRequired == bookingRequired) &&
            (identical(other.hasMultipleOccurrences, hasMultipleOccurrences) ||
                other.hasMultipleOccurrences == hasMultipleOccurrences) &&
            (identical(other.isRecurring, isRecurring) ||
                other.isRecurring == isRecurring));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        name,
        description,
        latitude,
        longitude,
        categoryId,
        categoryName,
        subcategoryName,
        subcategoryIcon,
        postalCode,
        address,
        city,
        googlePlaceId,
        const DeepCollectionEquality().hash(_currentOpeningHours),
        contactPhone,
        contactEmail,
        contactWebsite,
        bookingLevel,
        kidFriendly,
        wheelchairAccessible,
        minDurationMinutes,
        maxDurationMinutes,
        priceLevel,
        basePrice,
        const DeepCollectionEquality().hash(_images),
        startDate,
        endDate,
        bookingRequired,
        hasMultipleOccurrences,
        isRecurring
      ]);

  /// Create a copy of EventDetails
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$EventDetailsImplCopyWith<_$EventDetailsImpl> get copyWith =>
      __$$EventDetailsImplCopyWithImpl<_$EventDetailsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$EventDetailsImplToJson(
      this,
    );
  }
}

abstract class _EventDetails implements EventDetails {
  const factory _EventDetails(
      {required final String id,
      required final String name,
      final String? description,
      required final double latitude,
      required final double longitude,
      required final String categoryId,
      final String? categoryName,
      final String? subcategoryName,
      final String? subcategoryIcon,
      final String? postalCode,
      final String? address,
      final String? city,
      final String? googlePlaceId,
      final Map<String, dynamic>? currentOpeningHours,
      final String? contactPhone,
      final String? contactEmail,
      final String? contactWebsite,
      final String? bookingLevel,
      final bool? kidFriendly,
      final String? wheelchairAccessible,
      final int? minDurationMinutes,
      final int? maxDurationMinutes,
      final int? priceLevel,
      final double? basePrice,
      final List<EventImage>? images,
      required final DateTime startDate,
      required final DateTime endDate,
      final bool bookingRequired,
      final bool hasMultipleOccurrences,
      final bool isRecurring}) = _$EventDetailsImpl;

  factory _EventDetails.fromJson(Map<String, dynamic> json) =
      _$EventDetailsImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String? get description;
  @override
  double get latitude;
  @override
  double get longitude;
  @override
  String get categoryId;
  @override
  String? get categoryName;
  @override
  String? get subcategoryName;
  @override
  String? get subcategoryIcon;
  @override
  String? get postalCode;
  @override
  String? get address;
  @override
  String? get city;
  @override
  String? get googlePlaceId;
  @override
  Map<String, dynamic>? get currentOpeningHours;
  @override
  String? get contactPhone;
  @override
  String? get contactEmail;
  @override
  String? get contactWebsite;
  @override
  String? get bookingLevel;
  @override
  bool? get kidFriendly;
  @override
  String? get wheelchairAccessible;
  @override
  int? get minDurationMinutes;
  @override
  int? get maxDurationMinutes;
  @override
  int? get priceLevel;
  @override
  double? get basePrice;
  @override
  List<EventImage>? get images; // ✅ CHAMPS SPÉCIFIQUES AUX EVENTS
  @override
  DateTime get startDate;
  @override
  DateTime get endDate;
  @override
  bool get bookingRequired;
  @override
  bool get hasMultipleOccurrences;
  @override
  bool get isRecurring;

  /// Create a copy of EventDetails
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$EventDetailsImplCopyWith<_$EventDetailsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
