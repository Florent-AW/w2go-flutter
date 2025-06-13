// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'section_metadata.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

SectionMetadata _$SectionMetadataFromJson(Map<String, dynamic> json) {
  return _SectionMetadata.fromJson(json);
}

/// @nodoc
mixin _$SectionMetadata {
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  @JsonKey(name: 'section_type')
  String get sectionType => throw _privateConstructorUsedError;
  int get priority => throw _privateConstructorUsedError;
  @JsonKey(name: 'category_id')
  String? get categoryId => throw _privateConstructorUsedError;

  /// Serializes this SectionMetadata to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SectionMetadata
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SectionMetadataCopyWith<SectionMetadata> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SectionMetadataCopyWith<$Res> {
  factory $SectionMetadataCopyWith(
          SectionMetadata value, $Res Function(SectionMetadata) then) =
      _$SectionMetadataCopyWithImpl<$Res, SectionMetadata>;
  @useResult
  $Res call(
      {String id,
      String title,
      @JsonKey(name: 'section_type') String sectionType,
      int priority,
      @JsonKey(name: 'category_id') String? categoryId});
}

/// @nodoc
class _$SectionMetadataCopyWithImpl<$Res, $Val extends SectionMetadata>
    implements $SectionMetadataCopyWith<$Res> {
  _$SectionMetadataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SectionMetadata
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? sectionType = null,
    Object? priority = null,
    Object? categoryId = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      sectionType: null == sectionType
          ? _value.sectionType
          : sectionType // ignore: cast_nullable_to_non_nullable
              as String,
      priority: null == priority
          ? _value.priority
          : priority // ignore: cast_nullable_to_non_nullable
              as int,
      categoryId: freezed == categoryId
          ? _value.categoryId
          : categoryId // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SectionMetadataImplCopyWith<$Res>
    implements $SectionMetadataCopyWith<$Res> {
  factory _$$SectionMetadataImplCopyWith(_$SectionMetadataImpl value,
          $Res Function(_$SectionMetadataImpl) then) =
      __$$SectionMetadataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String title,
      @JsonKey(name: 'section_type') String sectionType,
      int priority,
      @JsonKey(name: 'category_id') String? categoryId});
}

/// @nodoc
class __$$SectionMetadataImplCopyWithImpl<$Res>
    extends _$SectionMetadataCopyWithImpl<$Res, _$SectionMetadataImpl>
    implements _$$SectionMetadataImplCopyWith<$Res> {
  __$$SectionMetadataImplCopyWithImpl(
      _$SectionMetadataImpl _value, $Res Function(_$SectionMetadataImpl) _then)
      : super(_value, _then);

  /// Create a copy of SectionMetadata
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? sectionType = null,
    Object? priority = null,
    Object? categoryId = freezed,
  }) {
    return _then(_$SectionMetadataImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      sectionType: null == sectionType
          ? _value.sectionType
          : sectionType // ignore: cast_nullable_to_non_nullable
              as String,
      priority: null == priority
          ? _value.priority
          : priority // ignore: cast_nullable_to_non_nullable
              as int,
      categoryId: freezed == categoryId
          ? _value.categoryId
          : categoryId // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SectionMetadataImpl implements _SectionMetadata {
  const _$SectionMetadataImpl(
      {required this.id,
      required this.title,
      @JsonKey(name: 'section_type') required this.sectionType,
      required this.priority,
      @JsonKey(name: 'category_id') this.categoryId});

  factory _$SectionMetadataImpl.fromJson(Map<String, dynamic> json) =>
      _$$SectionMetadataImplFromJson(json);

  @override
  final String id;
  @override
  final String title;
  @override
  @JsonKey(name: 'section_type')
  final String sectionType;
  @override
  final int priority;
  @override
  @JsonKey(name: 'category_id')
  final String? categoryId;

  @override
  String toString() {
    return 'SectionMetadata(id: $id, title: $title, sectionType: $sectionType, priority: $priority, categoryId: $categoryId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SectionMetadataImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.sectionType, sectionType) ||
                other.sectionType == sectionType) &&
            (identical(other.priority, priority) ||
                other.priority == priority) &&
            (identical(other.categoryId, categoryId) ||
                other.categoryId == categoryId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, title, sectionType, priority, categoryId);

  /// Create a copy of SectionMetadata
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SectionMetadataImplCopyWith<_$SectionMetadataImpl> get copyWith =>
      __$$SectionMetadataImplCopyWithImpl<_$SectionMetadataImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SectionMetadataImplToJson(
      this,
    );
  }
}

abstract class _SectionMetadata implements SectionMetadata {
  const factory _SectionMetadata(
          {required final String id,
          required final String title,
          @JsonKey(name: 'section_type') required final String sectionType,
          required final int priority,
          @JsonKey(name: 'category_id') final String? categoryId}) =
      _$SectionMetadataImpl;

  factory _SectionMetadata.fromJson(Map<String, dynamic> json) =
      _$SectionMetadataImpl.fromJson;

  @override
  String get id;
  @override
  String get title;
  @override
  @JsonKey(name: 'section_type')
  String get sectionType;
  @override
  int get priority;
  @override
  @JsonKey(name: 'category_id')
  String? get categoryId;

  /// Create a copy of SectionMetadata
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SectionMetadataImplCopyWith<_$SectionMetadataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
