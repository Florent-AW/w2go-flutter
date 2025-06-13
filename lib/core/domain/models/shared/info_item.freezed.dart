// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'info_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$InfoItem {
  String get iconName => throw _privateConstructorUsedError; // Icône
  String get value =>
      throw _privateConstructorUsedError; // Info directe (plus de title)
  String? get subtitle =>
      throw _privateConstructorUsedError; // Ligne descriptive optionnelle
  Color? get valueColor =>
      throw _privateConstructorUsedError; // Couleur spécifique
  InfoItemType? get type => throw _privateConstructorUsedError;

  /// Create a copy of InfoItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $InfoItemCopyWith<InfoItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $InfoItemCopyWith<$Res> {
  factory $InfoItemCopyWith(InfoItem value, $Res Function(InfoItem) then) =
      _$InfoItemCopyWithImpl<$Res, InfoItem>;
  @useResult
  $Res call(
      {String iconName,
      String value,
      String? subtitle,
      Color? valueColor,
      InfoItemType? type});
}

/// @nodoc
class _$InfoItemCopyWithImpl<$Res, $Val extends InfoItem>
    implements $InfoItemCopyWith<$Res> {
  _$InfoItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of InfoItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? iconName = null,
    Object? value = null,
    Object? subtitle = freezed,
    Object? valueColor = freezed,
    Object? type = freezed,
  }) {
    return _then(_value.copyWith(
      iconName: null == iconName
          ? _value.iconName
          : iconName // ignore: cast_nullable_to_non_nullable
              as String,
      value: null == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as String,
      subtitle: freezed == subtitle
          ? _value.subtitle
          : subtitle // ignore: cast_nullable_to_non_nullable
              as String?,
      valueColor: freezed == valueColor
          ? _value.valueColor
          : valueColor // ignore: cast_nullable_to_non_nullable
              as Color?,
      type: freezed == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as InfoItemType?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$InfoItemImplCopyWith<$Res>
    implements $InfoItemCopyWith<$Res> {
  factory _$$InfoItemImplCopyWith(
          _$InfoItemImpl value, $Res Function(_$InfoItemImpl) then) =
      __$$InfoItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String iconName,
      String value,
      String? subtitle,
      Color? valueColor,
      InfoItemType? type});
}

/// @nodoc
class __$$InfoItemImplCopyWithImpl<$Res>
    extends _$InfoItemCopyWithImpl<$Res, _$InfoItemImpl>
    implements _$$InfoItemImplCopyWith<$Res> {
  __$$InfoItemImplCopyWithImpl(
      _$InfoItemImpl _value, $Res Function(_$InfoItemImpl) _then)
      : super(_value, _then);

  /// Create a copy of InfoItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? iconName = null,
    Object? value = null,
    Object? subtitle = freezed,
    Object? valueColor = freezed,
    Object? type = freezed,
  }) {
    return _then(_$InfoItemImpl(
      iconName: null == iconName
          ? _value.iconName
          : iconName // ignore: cast_nullable_to_non_nullable
              as String,
      value: null == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as String,
      subtitle: freezed == subtitle
          ? _value.subtitle
          : subtitle // ignore: cast_nullable_to_non_nullable
              as String?,
      valueColor: freezed == valueColor
          ? _value.valueColor
          : valueColor // ignore: cast_nullable_to_non_nullable
              as Color?,
      type: freezed == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as InfoItemType?,
    ));
  }
}

/// @nodoc

class _$InfoItemImpl implements _InfoItem {
  const _$InfoItemImpl(
      {required this.iconName,
      required this.value,
      this.subtitle,
      this.valueColor,
      this.type});

  @override
  final String iconName;
// Icône
  @override
  final String value;
// Info directe (plus de title)
  @override
  final String? subtitle;
// Ligne descriptive optionnelle
  @override
  final Color? valueColor;
// Couleur spécifique
  @override
  final InfoItemType? type;

  @override
  String toString() {
    return 'InfoItem(iconName: $iconName, value: $value, subtitle: $subtitle, valueColor: $valueColor, type: $type)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InfoItemImpl &&
            (identical(other.iconName, iconName) ||
                other.iconName == iconName) &&
            (identical(other.value, value) || other.value == value) &&
            (identical(other.subtitle, subtitle) ||
                other.subtitle == subtitle) &&
            (identical(other.valueColor, valueColor) ||
                other.valueColor == valueColor) &&
            (identical(other.type, type) || other.type == type));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, iconName, value, subtitle, valueColor, type);

  /// Create a copy of InfoItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$InfoItemImplCopyWith<_$InfoItemImpl> get copyWith =>
      __$$InfoItemImplCopyWithImpl<_$InfoItemImpl>(this, _$identity);
}

abstract class _InfoItem implements InfoItem {
  const factory _InfoItem(
      {required final String iconName,
      required final String value,
      final String? subtitle,
      final Color? valueColor,
      final InfoItemType? type}) = _$InfoItemImpl;

  @override
  String get iconName; // Icône
  @override
  String get value; // Info directe (plus de title)
  @override
  String? get subtitle; // Ligne descriptive optionnelle
  @override
  Color? get valueColor; // Couleur spécifique
  @override
  InfoItemType? get type;

  /// Create a copy of InfoItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$InfoItemImplCopyWith<_$InfoItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
