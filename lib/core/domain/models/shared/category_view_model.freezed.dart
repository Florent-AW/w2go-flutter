// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'category_view_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

CategoryViewModel _$CategoryViewModelFromJson(Map<String, dynamic> json) {
  return _CategoryViewModel.fromJson(json);
}

/// @nodoc
mixin _$CategoryViewModel {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get imageUrl => throw _privateConstructorUsedError;
  String get color => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  String? get icon => throw _privateConstructorUsedError;

  /// Serializes this CategoryViewModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CategoryViewModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CategoryViewModelCopyWith<CategoryViewModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CategoryViewModelCopyWith<$Res> {
  factory $CategoryViewModelCopyWith(
          CategoryViewModel value, $Res Function(CategoryViewModel) then) =
      _$CategoryViewModelCopyWithImpl<$Res, CategoryViewModel>;
  @useResult
  $Res call(
      {String id,
      String name,
      String imageUrl,
      String color,
      String? description,
      String? icon});
}

/// @nodoc
class _$CategoryViewModelCopyWithImpl<$Res, $Val extends CategoryViewModel>
    implements $CategoryViewModelCopyWith<$Res> {
  _$CategoryViewModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CategoryViewModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? imageUrl = null,
    Object? color = null,
    Object? description = freezed,
    Object? icon = freezed,
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
      imageUrl: null == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String,
      color: null == color
          ? _value.color
          : color // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      icon: freezed == icon
          ? _value.icon
          : icon // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CategoryViewModelImplCopyWith<$Res>
    implements $CategoryViewModelCopyWith<$Res> {
  factory _$$CategoryViewModelImplCopyWith(_$CategoryViewModelImpl value,
          $Res Function(_$CategoryViewModelImpl) then) =
      __$$CategoryViewModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      String imageUrl,
      String color,
      String? description,
      String? icon});
}

/// @nodoc
class __$$CategoryViewModelImplCopyWithImpl<$Res>
    extends _$CategoryViewModelCopyWithImpl<$Res, _$CategoryViewModelImpl>
    implements _$$CategoryViewModelImplCopyWith<$Res> {
  __$$CategoryViewModelImplCopyWithImpl(_$CategoryViewModelImpl _value,
      $Res Function(_$CategoryViewModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of CategoryViewModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? imageUrl = null,
    Object? color = null,
    Object? description = freezed,
    Object? icon = freezed,
  }) {
    return _then(_$CategoryViewModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      imageUrl: null == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String,
      color: null == color
          ? _value.color
          : color // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      icon: freezed == icon
          ? _value.icon
          : icon // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CategoryViewModelImpl implements _CategoryViewModel {
  const _$CategoryViewModelImpl(
      {required this.id,
      required this.name,
      required this.imageUrl,
      this.color = '#FFFFFF',
      this.description,
      this.icon});

  factory _$CategoryViewModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$CategoryViewModelImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String imageUrl;
  @override
  @JsonKey()
  final String color;
  @override
  final String? description;
  @override
  final String? icon;

  @override
  String toString() {
    return 'CategoryViewModel(id: $id, name: $name, imageUrl: $imageUrl, color: $color, description: $description, icon: $icon)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CategoryViewModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            (identical(other.color, color) || other.color == color) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.icon, icon) || other.icon == icon));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, name, imageUrl, color, description, icon);

  /// Create a copy of CategoryViewModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CategoryViewModelImplCopyWith<_$CategoryViewModelImpl> get copyWith =>
      __$$CategoryViewModelImplCopyWithImpl<_$CategoryViewModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CategoryViewModelImplToJson(
      this,
    );
  }
}

abstract class _CategoryViewModel implements CategoryViewModel {
  const factory _CategoryViewModel(
      {required final String id,
      required final String name,
      required final String imageUrl,
      final String color,
      final String? description,
      final String? icon}) = _$CategoryViewModelImpl;

  factory _CategoryViewModel.fromJson(Map<String, dynamic> json) =
      _$CategoryViewModelImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String get imageUrl;
  @override
  String get color;
  @override
  String? get description;
  @override
  String? get icon;

  /// Create a copy of CategoryViewModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CategoryViewModelImplCopyWith<_$CategoryViewModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
