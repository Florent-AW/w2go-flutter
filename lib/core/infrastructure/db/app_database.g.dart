// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $FavoritesTable extends Favorites
    with TableInfo<$FavoritesTable, Favorite> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FavoritesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _itemTypeMeta =
      const VerificationMeta('itemType');
  @override
  late final GeneratedColumn<String> itemType = GeneratedColumn<String>(
      'item_type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _itemIdMeta = const VerificationMeta('itemId');
  @override
  late final GeneratedColumn<String> itemId = GeneratedColumn<String>(
      'item_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _imageUrlMeta =
      const VerificationMeta('imageUrl');
  @override
  late final GeneratedColumn<String> imageUrl = GeneratedColumn<String>(
      'image_url', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _cityNameMeta =
      const VerificationMeta('cityName');
  @override
  late final GeneratedColumn<String> cityName = GeneratedColumn<String>(
      'city_name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _categoryNameMeta =
      const VerificationMeta('categoryName');
  @override
  late final GeneratedColumn<String> categoryName = GeneratedColumn<String>(
      'category_name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _eventStartMeta =
      const VerificationMeta('eventStart');
  @override
  late final GeneratedColumn<DateTime> eventStart = GeneratedColumn<DateTime>(
      'event_start', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _deviceIdMeta =
      const VerificationMeta('deviceId');
  @override
  late final GeneratedColumn<String> deviceId = GeneratedColumn<String>(
      'device_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _remoteRevMeta =
      const VerificationMeta('remoteRev');
  @override
  late final GeneratedColumn<String> remoteRev = GeneratedColumn<String>(
      'remote_rev', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        itemType,
        itemId,
        title,
        imageUrl,
        cityName,
        categoryName,
        eventStart,
        updatedAt,
        deviceId,
        remoteRev
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'favorites';
  @override
  VerificationContext validateIntegrity(Insertable<Favorite> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('item_type')) {
      context.handle(_itemTypeMeta,
          itemType.isAcceptableOrUnknown(data['item_type']!, _itemTypeMeta));
    } else if (isInserting) {
      context.missing(_itemTypeMeta);
    }
    if (data.containsKey('item_id')) {
      context.handle(_itemIdMeta,
          itemId.isAcceptableOrUnknown(data['item_id']!, _itemIdMeta));
    } else if (isInserting) {
      context.missing(_itemIdMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('image_url')) {
      context.handle(_imageUrlMeta,
          imageUrl.isAcceptableOrUnknown(data['image_url']!, _imageUrlMeta));
    }
    if (data.containsKey('city_name')) {
      context.handle(_cityNameMeta,
          cityName.isAcceptableOrUnknown(data['city_name']!, _cityNameMeta));
    }
    if (data.containsKey('category_name')) {
      context.handle(
          _categoryNameMeta,
          categoryName.isAcceptableOrUnknown(
              data['category_name']!, _categoryNameMeta));
    }
    if (data.containsKey('event_start')) {
      context.handle(
          _eventStartMeta,
          eventStart.isAcceptableOrUnknown(
              data['event_start']!, _eventStartMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('device_id')) {
      context.handle(_deviceIdMeta,
          deviceId.isAcceptableOrUnknown(data['device_id']!, _deviceIdMeta));
    }
    if (data.containsKey('remote_rev')) {
      context.handle(_remoteRevMeta,
          remoteRev.isAcceptableOrUnknown(data['remote_rev']!, _remoteRevMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {itemType, itemId};
  @override
  Favorite map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Favorite(
      itemType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}item_type'])!,
      itemId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}item_id'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      imageUrl: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}image_url']),
      cityName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}city_name']),
      categoryName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}category_name']),
      eventStart: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}event_start']),
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}updated_at'])!,
      deviceId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}device_id']),
      remoteRev: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}remote_rev']),
    );
  }

  @override
  $FavoritesTable createAlias(String alias) {
    return $FavoritesTable(attachedDatabase, alias);
  }
}

class Favorite extends DataClass implements Insertable<Favorite> {
  final String itemType;
  final String itemId;
  final String title;
  final String? imageUrl;
  final String? cityName;
  final String? categoryName;
  final DateTime? eventStart;
  final int updatedAt;
  final String? deviceId;
  final String? remoteRev;
  const Favorite(
      {required this.itemType,
      required this.itemId,
      required this.title,
      this.imageUrl,
      this.cityName,
      this.categoryName,
      this.eventStart,
      required this.updatedAt,
      this.deviceId,
      this.remoteRev});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['item_type'] = Variable<String>(itemType);
    map['item_id'] = Variable<String>(itemId);
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || imageUrl != null) {
      map['image_url'] = Variable<String>(imageUrl);
    }
    if (!nullToAbsent || cityName != null) {
      map['city_name'] = Variable<String>(cityName);
    }
    if (!nullToAbsent || categoryName != null) {
      map['category_name'] = Variable<String>(categoryName);
    }
    if (!nullToAbsent || eventStart != null) {
      map['event_start'] = Variable<DateTime>(eventStart);
    }
    map['updated_at'] = Variable<int>(updatedAt);
    if (!nullToAbsent || deviceId != null) {
      map['device_id'] = Variable<String>(deviceId);
    }
    if (!nullToAbsent || remoteRev != null) {
      map['remote_rev'] = Variable<String>(remoteRev);
    }
    return map;
  }

  FavoritesCompanion toCompanion(bool nullToAbsent) {
    return FavoritesCompanion(
      itemType: Value(itemType),
      itemId: Value(itemId),
      title: Value(title),
      imageUrl: imageUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(imageUrl),
      cityName: cityName == null && nullToAbsent
          ? const Value.absent()
          : Value(cityName),
      categoryName: categoryName == null && nullToAbsent
          ? const Value.absent()
          : Value(categoryName),
      eventStart: eventStart == null && nullToAbsent
          ? const Value.absent()
          : Value(eventStart),
      updatedAt: Value(updatedAt),
      deviceId: deviceId == null && nullToAbsent
          ? const Value.absent()
          : Value(deviceId),
      remoteRev: remoteRev == null && nullToAbsent
          ? const Value.absent()
          : Value(remoteRev),
    );
  }

  factory Favorite.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Favorite(
      itemType: serializer.fromJson<String>(json['itemType']),
      itemId: serializer.fromJson<String>(json['itemId']),
      title: serializer.fromJson<String>(json['title']),
      imageUrl: serializer.fromJson<String?>(json['imageUrl']),
      cityName: serializer.fromJson<String?>(json['cityName']),
      categoryName: serializer.fromJson<String?>(json['categoryName']),
      eventStart: serializer.fromJson<DateTime?>(json['eventStart']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
      deviceId: serializer.fromJson<String?>(json['deviceId']),
      remoteRev: serializer.fromJson<String?>(json['remoteRev']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'itemType': serializer.toJson<String>(itemType),
      'itemId': serializer.toJson<String>(itemId),
      'title': serializer.toJson<String>(title),
      'imageUrl': serializer.toJson<String?>(imageUrl),
      'cityName': serializer.toJson<String?>(cityName),
      'categoryName': serializer.toJson<String?>(categoryName),
      'eventStart': serializer.toJson<DateTime?>(eventStart),
      'updatedAt': serializer.toJson<int>(updatedAt),
      'deviceId': serializer.toJson<String?>(deviceId),
      'remoteRev': serializer.toJson<String?>(remoteRev),
    };
  }

  Favorite copyWith(
          {String? itemType,
          String? itemId,
          String? title,
          Value<String?> imageUrl = const Value.absent(),
          Value<String?> cityName = const Value.absent(),
          Value<String?> categoryName = const Value.absent(),
          Value<DateTime?> eventStart = const Value.absent(),
          int? updatedAt,
          Value<String?> deviceId = const Value.absent(),
          Value<String?> remoteRev = const Value.absent()}) =>
      Favorite(
        itemType: itemType ?? this.itemType,
        itemId: itemId ?? this.itemId,
        title: title ?? this.title,
        imageUrl: imageUrl.present ? imageUrl.value : this.imageUrl,
        cityName: cityName.present ? cityName.value : this.cityName,
        categoryName:
            categoryName.present ? categoryName.value : this.categoryName,
        eventStart: eventStart.present ? eventStart.value : this.eventStart,
        updatedAt: updatedAt ?? this.updatedAt,
        deviceId: deviceId.present ? deviceId.value : this.deviceId,
        remoteRev: remoteRev.present ? remoteRev.value : this.remoteRev,
      );
  Favorite copyWithCompanion(FavoritesCompanion data) {
    return Favorite(
      itemType: data.itemType.present ? data.itemType.value : this.itemType,
      itemId: data.itemId.present ? data.itemId.value : this.itemId,
      title: data.title.present ? data.title.value : this.title,
      imageUrl: data.imageUrl.present ? data.imageUrl.value : this.imageUrl,
      cityName: data.cityName.present ? data.cityName.value : this.cityName,
      categoryName: data.categoryName.present
          ? data.categoryName.value
          : this.categoryName,
      eventStart:
          data.eventStart.present ? data.eventStart.value : this.eventStart,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deviceId: data.deviceId.present ? data.deviceId.value : this.deviceId,
      remoteRev: data.remoteRev.present ? data.remoteRev.value : this.remoteRev,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Favorite(')
          ..write('itemType: $itemType, ')
          ..write('itemId: $itemId, ')
          ..write('title: $title, ')
          ..write('imageUrl: $imageUrl, ')
          ..write('cityName: $cityName, ')
          ..write('categoryName: $categoryName, ')
          ..write('eventStart: $eventStart, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deviceId: $deviceId, ')
          ..write('remoteRev: $remoteRev')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(itemType, itemId, title, imageUrl, cityName,
      categoryName, eventStart, updatedAt, deviceId, remoteRev);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Favorite &&
          other.itemType == this.itemType &&
          other.itemId == this.itemId &&
          other.title == this.title &&
          other.imageUrl == this.imageUrl &&
          other.cityName == this.cityName &&
          other.categoryName == this.categoryName &&
          other.eventStart == this.eventStart &&
          other.updatedAt == this.updatedAt &&
          other.deviceId == this.deviceId &&
          other.remoteRev == this.remoteRev);
}

class FavoritesCompanion extends UpdateCompanion<Favorite> {
  final Value<String> itemType;
  final Value<String> itemId;
  final Value<String> title;
  final Value<String?> imageUrl;
  final Value<String?> cityName;
  final Value<String?> categoryName;
  final Value<DateTime?> eventStart;
  final Value<int> updatedAt;
  final Value<String?> deviceId;
  final Value<String?> remoteRev;
  final Value<int> rowid;
  const FavoritesCompanion({
    this.itemType = const Value.absent(),
    this.itemId = const Value.absent(),
    this.title = const Value.absent(),
    this.imageUrl = const Value.absent(),
    this.cityName = const Value.absent(),
    this.categoryName = const Value.absent(),
    this.eventStart = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deviceId = const Value.absent(),
    this.remoteRev = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  FavoritesCompanion.insert({
    required String itemType,
    required String itemId,
    required String title,
    this.imageUrl = const Value.absent(),
    this.cityName = const Value.absent(),
    this.categoryName = const Value.absent(),
    this.eventStart = const Value.absent(),
    required int updatedAt,
    this.deviceId = const Value.absent(),
    this.remoteRev = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : itemType = Value(itemType),
        itemId = Value(itemId),
        title = Value(title),
        updatedAt = Value(updatedAt);
  static Insertable<Favorite> custom({
    Expression<String>? itemType,
    Expression<String>? itemId,
    Expression<String>? title,
    Expression<String>? imageUrl,
    Expression<String>? cityName,
    Expression<String>? categoryName,
    Expression<DateTime>? eventStart,
    Expression<int>? updatedAt,
    Expression<String>? deviceId,
    Expression<String>? remoteRev,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (itemType != null) 'item_type': itemType,
      if (itemId != null) 'item_id': itemId,
      if (title != null) 'title': title,
      if (imageUrl != null) 'image_url': imageUrl,
      if (cityName != null) 'city_name': cityName,
      if (categoryName != null) 'category_name': categoryName,
      if (eventStart != null) 'event_start': eventStart,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deviceId != null) 'device_id': deviceId,
      if (remoteRev != null) 'remote_rev': remoteRev,
      if (rowid != null) 'rowid': rowid,
    });
  }

  FavoritesCompanion copyWith(
      {Value<String>? itemType,
      Value<String>? itemId,
      Value<String>? title,
      Value<String?>? imageUrl,
      Value<String?>? cityName,
      Value<String?>? categoryName,
      Value<DateTime?>? eventStart,
      Value<int>? updatedAt,
      Value<String?>? deviceId,
      Value<String?>? remoteRev,
      Value<int>? rowid}) {
    return FavoritesCompanion(
      itemType: itemType ?? this.itemType,
      itemId: itemId ?? this.itemId,
      title: title ?? this.title,
      imageUrl: imageUrl ?? this.imageUrl,
      cityName: cityName ?? this.cityName,
      categoryName: categoryName ?? this.categoryName,
      eventStart: eventStart ?? this.eventStart,
      updatedAt: updatedAt ?? this.updatedAt,
      deviceId: deviceId ?? this.deviceId,
      remoteRev: remoteRev ?? this.remoteRev,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (itemType.present) {
      map['item_type'] = Variable<String>(itemType.value);
    }
    if (itemId.present) {
      map['item_id'] = Variable<String>(itemId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (imageUrl.present) {
      map['image_url'] = Variable<String>(imageUrl.value);
    }
    if (cityName.present) {
      map['city_name'] = Variable<String>(cityName.value);
    }
    if (categoryName.present) {
      map['category_name'] = Variable<String>(categoryName.value);
    }
    if (eventStart.present) {
      map['event_start'] = Variable<DateTime>(eventStart.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (deviceId.present) {
      map['device_id'] = Variable<String>(deviceId.value);
    }
    if (remoteRev.present) {
      map['remote_rev'] = Variable<String>(remoteRev.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FavoritesCompanion(')
          ..write('itemType: $itemType, ')
          ..write('itemId: $itemId, ')
          ..write('title: $title, ')
          ..write('imageUrl: $imageUrl, ')
          ..write('cityName: $cityName, ')
          ..write('categoryName: $categoryName, ')
          ..write('eventStart: $eventStart, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deviceId: $deviceId, ')
          ..write('remoteRev: $remoteRev, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SearchHistoryTable extends SearchHistory
    with TableInfo<$SearchHistoryTable, SearchHistoryData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SearchHistoryTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _kindMeta = const VerificationMeta('kind');
  @override
  late final GeneratedColumn<String> kind = GeneratedColumn<String>(
      'kind', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _termTitleMeta =
      const VerificationMeta('termTitle');
  @override
  late final GeneratedColumn<String> termTitle = GeneratedColumn<String>(
      'term_title', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _conceptIdMeta =
      const VerificationMeta('conceptId');
  @override
  late final GeneratedColumn<String> conceptId = GeneratedColumn<String>(
      'concept_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _conceptTypeMeta =
      const VerificationMeta('conceptType');
  @override
  late final GeneratedColumn<String> conceptType = GeneratedColumn<String>(
      'concept_type', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _sectionIdMeta =
      const VerificationMeta('sectionId');
  @override
  late final GeneratedColumn<String> sectionId = GeneratedColumn<String>(
      'section_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _filtersJsonMeta =
      const VerificationMeta('filtersJson');
  @override
  late final GeneratedColumn<String> filtersJson = GeneratedColumn<String>(
      'filters_json', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _cityIdMeta = const VerificationMeta('cityId');
  @override
  late final GeneratedColumn<String> cityId = GeneratedColumn<String>(
      'city_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _cityNameMeta =
      const VerificationMeta('cityName');
  @override
  late final GeneratedColumn<String> cityName = GeneratedColumn<String>(
      'city_name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _latMeta = const VerificationMeta('lat');
  @override
  late final GeneratedColumn<double> lat = GeneratedColumn<double>(
      'lat', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _lonMeta = const VerificationMeta('lon');
  @override
  late final GeneratedColumn<double> lon = GeneratedColumn<double>(
      'lon', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _executedAtMeta =
      const VerificationMeta('executedAt');
  @override
  late final GeneratedColumn<int> executedAt = GeneratedColumn<int>(
      'executed_at', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _deviceIdMeta =
      const VerificationMeta('deviceId');
  @override
  late final GeneratedColumn<String> deviceId = GeneratedColumn<String>(
      'device_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _remoteRevMeta =
      const VerificationMeta('remoteRev');
  @override
  late final GeneratedColumn<String> remoteRev = GeneratedColumn<String>(
      'remote_rev', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        kind,
        termTitle,
        conceptId,
        conceptType,
        sectionId,
        filtersJson,
        cityId,
        cityName,
        lat,
        lon,
        executedAt,
        deviceId,
        remoteRev
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'search_history';
  @override
  VerificationContext validateIntegrity(Insertable<SearchHistoryData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('kind')) {
      context.handle(
          _kindMeta, kind.isAcceptableOrUnknown(data['kind']!, _kindMeta));
    } else if (isInserting) {
      context.missing(_kindMeta);
    }
    if (data.containsKey('term_title')) {
      context.handle(_termTitleMeta,
          termTitle.isAcceptableOrUnknown(data['term_title']!, _termTitleMeta));
    }
    if (data.containsKey('concept_id')) {
      context.handle(_conceptIdMeta,
          conceptId.isAcceptableOrUnknown(data['concept_id']!, _conceptIdMeta));
    }
    if (data.containsKey('concept_type')) {
      context.handle(
          _conceptTypeMeta,
          conceptType.isAcceptableOrUnknown(
              data['concept_type']!, _conceptTypeMeta));
    }
    if (data.containsKey('section_id')) {
      context.handle(_sectionIdMeta,
          sectionId.isAcceptableOrUnknown(data['section_id']!, _sectionIdMeta));
    }
    if (data.containsKey('filters_json')) {
      context.handle(
          _filtersJsonMeta,
          filtersJson.isAcceptableOrUnknown(
              data['filters_json']!, _filtersJsonMeta));
    }
    if (data.containsKey('city_id')) {
      context.handle(_cityIdMeta,
          cityId.isAcceptableOrUnknown(data['city_id']!, _cityIdMeta));
    }
    if (data.containsKey('city_name')) {
      context.handle(_cityNameMeta,
          cityName.isAcceptableOrUnknown(data['city_name']!, _cityNameMeta));
    }
    if (data.containsKey('lat')) {
      context.handle(
          _latMeta, lat.isAcceptableOrUnknown(data['lat']!, _latMeta));
    }
    if (data.containsKey('lon')) {
      context.handle(
          _lonMeta, lon.isAcceptableOrUnknown(data['lon']!, _lonMeta));
    }
    if (data.containsKey('executed_at')) {
      context.handle(
          _executedAtMeta,
          executedAt.isAcceptableOrUnknown(
              data['executed_at']!, _executedAtMeta));
    } else if (isInserting) {
      context.missing(_executedAtMeta);
    }
    if (data.containsKey('device_id')) {
      context.handle(_deviceIdMeta,
          deviceId.isAcceptableOrUnknown(data['device_id']!, _deviceIdMeta));
    }
    if (data.containsKey('remote_rev')) {
      context.handle(_remoteRevMeta,
          remoteRev.isAcceptableOrUnknown(data['remote_rev']!, _remoteRevMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SearchHistoryData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SearchHistoryData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      kind: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}kind'])!,
      termTitle: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}term_title']),
      conceptId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}concept_id']),
      conceptType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}concept_type']),
      sectionId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}section_id']),
      filtersJson: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}filters_json']),
      cityId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}city_id']),
      cityName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}city_name']),
      lat: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}lat']),
      lon: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}lon']),
      executedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}executed_at'])!,
      deviceId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}device_id']),
      remoteRev: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}remote_rev']),
    );
  }

  @override
  $SearchHistoryTable createAlias(String alias) {
    return $SearchHistoryTable(attachedDatabase, alias);
  }
}

class SearchHistoryData extends DataClass
    implements Insertable<SearchHistoryData> {
  final int id;
  final String kind;
  final String? termTitle;
  final String? conceptId;
  final String? conceptType;
  final String? sectionId;
  final String? filtersJson;
  final String? cityId;
  final String? cityName;
  final double? lat;
  final double? lon;
  final int executedAt;
  final String? deviceId;
  final String? remoteRev;
  const SearchHistoryData(
      {required this.id,
      required this.kind,
      this.termTitle,
      this.conceptId,
      this.conceptType,
      this.sectionId,
      this.filtersJson,
      this.cityId,
      this.cityName,
      this.lat,
      this.lon,
      required this.executedAt,
      this.deviceId,
      this.remoteRev});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['kind'] = Variable<String>(kind);
    if (!nullToAbsent || termTitle != null) {
      map['term_title'] = Variable<String>(termTitle);
    }
    if (!nullToAbsent || conceptId != null) {
      map['concept_id'] = Variable<String>(conceptId);
    }
    if (!nullToAbsent || conceptType != null) {
      map['concept_type'] = Variable<String>(conceptType);
    }
    if (!nullToAbsent || sectionId != null) {
      map['section_id'] = Variable<String>(sectionId);
    }
    if (!nullToAbsent || filtersJson != null) {
      map['filters_json'] = Variable<String>(filtersJson);
    }
    if (!nullToAbsent || cityId != null) {
      map['city_id'] = Variable<String>(cityId);
    }
    if (!nullToAbsent || cityName != null) {
      map['city_name'] = Variable<String>(cityName);
    }
    if (!nullToAbsent || lat != null) {
      map['lat'] = Variable<double>(lat);
    }
    if (!nullToAbsent || lon != null) {
      map['lon'] = Variable<double>(lon);
    }
    map['executed_at'] = Variable<int>(executedAt);
    if (!nullToAbsent || deviceId != null) {
      map['device_id'] = Variable<String>(deviceId);
    }
    if (!nullToAbsent || remoteRev != null) {
      map['remote_rev'] = Variable<String>(remoteRev);
    }
    return map;
  }

  SearchHistoryCompanion toCompanion(bool nullToAbsent) {
    return SearchHistoryCompanion(
      id: Value(id),
      kind: Value(kind),
      termTitle: termTitle == null && nullToAbsent
          ? const Value.absent()
          : Value(termTitle),
      conceptId: conceptId == null && nullToAbsent
          ? const Value.absent()
          : Value(conceptId),
      conceptType: conceptType == null && nullToAbsent
          ? const Value.absent()
          : Value(conceptType),
      sectionId: sectionId == null && nullToAbsent
          ? const Value.absent()
          : Value(sectionId),
      filtersJson: filtersJson == null && nullToAbsent
          ? const Value.absent()
          : Value(filtersJson),
      cityId:
          cityId == null && nullToAbsent ? const Value.absent() : Value(cityId),
      cityName: cityName == null && nullToAbsent
          ? const Value.absent()
          : Value(cityName),
      lat: lat == null && nullToAbsent ? const Value.absent() : Value(lat),
      lon: lon == null && nullToAbsent ? const Value.absent() : Value(lon),
      executedAt: Value(executedAt),
      deviceId: deviceId == null && nullToAbsent
          ? const Value.absent()
          : Value(deviceId),
      remoteRev: remoteRev == null && nullToAbsent
          ? const Value.absent()
          : Value(remoteRev),
    );
  }

  factory SearchHistoryData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SearchHistoryData(
      id: serializer.fromJson<int>(json['id']),
      kind: serializer.fromJson<String>(json['kind']),
      termTitle: serializer.fromJson<String?>(json['termTitle']),
      conceptId: serializer.fromJson<String?>(json['conceptId']),
      conceptType: serializer.fromJson<String?>(json['conceptType']),
      sectionId: serializer.fromJson<String?>(json['sectionId']),
      filtersJson: serializer.fromJson<String?>(json['filtersJson']),
      cityId: serializer.fromJson<String?>(json['cityId']),
      cityName: serializer.fromJson<String?>(json['cityName']),
      lat: serializer.fromJson<double?>(json['lat']),
      lon: serializer.fromJson<double?>(json['lon']),
      executedAt: serializer.fromJson<int>(json['executedAt']),
      deviceId: serializer.fromJson<String?>(json['deviceId']),
      remoteRev: serializer.fromJson<String?>(json['remoteRev']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'kind': serializer.toJson<String>(kind),
      'termTitle': serializer.toJson<String?>(termTitle),
      'conceptId': serializer.toJson<String?>(conceptId),
      'conceptType': serializer.toJson<String?>(conceptType),
      'sectionId': serializer.toJson<String?>(sectionId),
      'filtersJson': serializer.toJson<String?>(filtersJson),
      'cityId': serializer.toJson<String?>(cityId),
      'cityName': serializer.toJson<String?>(cityName),
      'lat': serializer.toJson<double?>(lat),
      'lon': serializer.toJson<double?>(lon),
      'executedAt': serializer.toJson<int>(executedAt),
      'deviceId': serializer.toJson<String?>(deviceId),
      'remoteRev': serializer.toJson<String?>(remoteRev),
    };
  }

  SearchHistoryData copyWith(
          {int? id,
          String? kind,
          Value<String?> termTitle = const Value.absent(),
          Value<String?> conceptId = const Value.absent(),
          Value<String?> conceptType = const Value.absent(),
          Value<String?> sectionId = const Value.absent(),
          Value<String?> filtersJson = const Value.absent(),
          Value<String?> cityId = const Value.absent(),
          Value<String?> cityName = const Value.absent(),
          Value<double?> lat = const Value.absent(),
          Value<double?> lon = const Value.absent(),
          int? executedAt,
          Value<String?> deviceId = const Value.absent(),
          Value<String?> remoteRev = const Value.absent()}) =>
      SearchHistoryData(
        id: id ?? this.id,
        kind: kind ?? this.kind,
        termTitle: termTitle.present ? termTitle.value : this.termTitle,
        conceptId: conceptId.present ? conceptId.value : this.conceptId,
        conceptType: conceptType.present ? conceptType.value : this.conceptType,
        sectionId: sectionId.present ? sectionId.value : this.sectionId,
        filtersJson: filtersJson.present ? filtersJson.value : this.filtersJson,
        cityId: cityId.present ? cityId.value : this.cityId,
        cityName: cityName.present ? cityName.value : this.cityName,
        lat: lat.present ? lat.value : this.lat,
        lon: lon.present ? lon.value : this.lon,
        executedAt: executedAt ?? this.executedAt,
        deviceId: deviceId.present ? deviceId.value : this.deviceId,
        remoteRev: remoteRev.present ? remoteRev.value : this.remoteRev,
      );
  SearchHistoryData copyWithCompanion(SearchHistoryCompanion data) {
    return SearchHistoryData(
      id: data.id.present ? data.id.value : this.id,
      kind: data.kind.present ? data.kind.value : this.kind,
      termTitle: data.termTitle.present ? data.termTitle.value : this.termTitle,
      conceptId: data.conceptId.present ? data.conceptId.value : this.conceptId,
      conceptType:
          data.conceptType.present ? data.conceptType.value : this.conceptType,
      sectionId: data.sectionId.present ? data.sectionId.value : this.sectionId,
      filtersJson:
          data.filtersJson.present ? data.filtersJson.value : this.filtersJson,
      cityId: data.cityId.present ? data.cityId.value : this.cityId,
      cityName: data.cityName.present ? data.cityName.value : this.cityName,
      lat: data.lat.present ? data.lat.value : this.lat,
      lon: data.lon.present ? data.lon.value : this.lon,
      executedAt:
          data.executedAt.present ? data.executedAt.value : this.executedAt,
      deviceId: data.deviceId.present ? data.deviceId.value : this.deviceId,
      remoteRev: data.remoteRev.present ? data.remoteRev.value : this.remoteRev,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SearchHistoryData(')
          ..write('id: $id, ')
          ..write('kind: $kind, ')
          ..write('termTitle: $termTitle, ')
          ..write('conceptId: $conceptId, ')
          ..write('conceptType: $conceptType, ')
          ..write('sectionId: $sectionId, ')
          ..write('filtersJson: $filtersJson, ')
          ..write('cityId: $cityId, ')
          ..write('cityName: $cityName, ')
          ..write('lat: $lat, ')
          ..write('lon: $lon, ')
          ..write('executedAt: $executedAt, ')
          ..write('deviceId: $deviceId, ')
          ..write('remoteRev: $remoteRev')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      kind,
      termTitle,
      conceptId,
      conceptType,
      sectionId,
      filtersJson,
      cityId,
      cityName,
      lat,
      lon,
      executedAt,
      deviceId,
      remoteRev);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SearchHistoryData &&
          other.id == this.id &&
          other.kind == this.kind &&
          other.termTitle == this.termTitle &&
          other.conceptId == this.conceptId &&
          other.conceptType == this.conceptType &&
          other.sectionId == this.sectionId &&
          other.filtersJson == this.filtersJson &&
          other.cityId == this.cityId &&
          other.cityName == this.cityName &&
          other.lat == this.lat &&
          other.lon == this.lon &&
          other.executedAt == this.executedAt &&
          other.deviceId == this.deviceId &&
          other.remoteRev == this.remoteRev);
}

class SearchHistoryCompanion extends UpdateCompanion<SearchHistoryData> {
  final Value<int> id;
  final Value<String> kind;
  final Value<String?> termTitle;
  final Value<String?> conceptId;
  final Value<String?> conceptType;
  final Value<String?> sectionId;
  final Value<String?> filtersJson;
  final Value<String?> cityId;
  final Value<String?> cityName;
  final Value<double?> lat;
  final Value<double?> lon;
  final Value<int> executedAt;
  final Value<String?> deviceId;
  final Value<String?> remoteRev;
  const SearchHistoryCompanion({
    this.id = const Value.absent(),
    this.kind = const Value.absent(),
    this.termTitle = const Value.absent(),
    this.conceptId = const Value.absent(),
    this.conceptType = const Value.absent(),
    this.sectionId = const Value.absent(),
    this.filtersJson = const Value.absent(),
    this.cityId = const Value.absent(),
    this.cityName = const Value.absent(),
    this.lat = const Value.absent(),
    this.lon = const Value.absent(),
    this.executedAt = const Value.absent(),
    this.deviceId = const Value.absent(),
    this.remoteRev = const Value.absent(),
  });
  SearchHistoryCompanion.insert({
    this.id = const Value.absent(),
    required String kind,
    this.termTitle = const Value.absent(),
    this.conceptId = const Value.absent(),
    this.conceptType = const Value.absent(),
    this.sectionId = const Value.absent(),
    this.filtersJson = const Value.absent(),
    this.cityId = const Value.absent(),
    this.cityName = const Value.absent(),
    this.lat = const Value.absent(),
    this.lon = const Value.absent(),
    required int executedAt,
    this.deviceId = const Value.absent(),
    this.remoteRev = const Value.absent(),
  })  : kind = Value(kind),
        executedAt = Value(executedAt);
  static Insertable<SearchHistoryData> custom({
    Expression<int>? id,
    Expression<String>? kind,
    Expression<String>? termTitle,
    Expression<String>? conceptId,
    Expression<String>? conceptType,
    Expression<String>? sectionId,
    Expression<String>? filtersJson,
    Expression<String>? cityId,
    Expression<String>? cityName,
    Expression<double>? lat,
    Expression<double>? lon,
    Expression<int>? executedAt,
    Expression<String>? deviceId,
    Expression<String>? remoteRev,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (kind != null) 'kind': kind,
      if (termTitle != null) 'term_title': termTitle,
      if (conceptId != null) 'concept_id': conceptId,
      if (conceptType != null) 'concept_type': conceptType,
      if (sectionId != null) 'section_id': sectionId,
      if (filtersJson != null) 'filters_json': filtersJson,
      if (cityId != null) 'city_id': cityId,
      if (cityName != null) 'city_name': cityName,
      if (lat != null) 'lat': lat,
      if (lon != null) 'lon': lon,
      if (executedAt != null) 'executed_at': executedAt,
      if (deviceId != null) 'device_id': deviceId,
      if (remoteRev != null) 'remote_rev': remoteRev,
    });
  }

  SearchHistoryCompanion copyWith(
      {Value<int>? id,
      Value<String>? kind,
      Value<String?>? termTitle,
      Value<String?>? conceptId,
      Value<String?>? conceptType,
      Value<String?>? sectionId,
      Value<String?>? filtersJson,
      Value<String?>? cityId,
      Value<String?>? cityName,
      Value<double?>? lat,
      Value<double?>? lon,
      Value<int>? executedAt,
      Value<String?>? deviceId,
      Value<String?>? remoteRev}) {
    return SearchHistoryCompanion(
      id: id ?? this.id,
      kind: kind ?? this.kind,
      termTitle: termTitle ?? this.termTitle,
      conceptId: conceptId ?? this.conceptId,
      conceptType: conceptType ?? this.conceptType,
      sectionId: sectionId ?? this.sectionId,
      filtersJson: filtersJson ?? this.filtersJson,
      cityId: cityId ?? this.cityId,
      cityName: cityName ?? this.cityName,
      lat: lat ?? this.lat,
      lon: lon ?? this.lon,
      executedAt: executedAt ?? this.executedAt,
      deviceId: deviceId ?? this.deviceId,
      remoteRev: remoteRev ?? this.remoteRev,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (kind.present) {
      map['kind'] = Variable<String>(kind.value);
    }
    if (termTitle.present) {
      map['term_title'] = Variable<String>(termTitle.value);
    }
    if (conceptId.present) {
      map['concept_id'] = Variable<String>(conceptId.value);
    }
    if (conceptType.present) {
      map['concept_type'] = Variable<String>(conceptType.value);
    }
    if (sectionId.present) {
      map['section_id'] = Variable<String>(sectionId.value);
    }
    if (filtersJson.present) {
      map['filters_json'] = Variable<String>(filtersJson.value);
    }
    if (cityId.present) {
      map['city_id'] = Variable<String>(cityId.value);
    }
    if (cityName.present) {
      map['city_name'] = Variable<String>(cityName.value);
    }
    if (lat.present) {
      map['lat'] = Variable<double>(lat.value);
    }
    if (lon.present) {
      map['lon'] = Variable<double>(lon.value);
    }
    if (executedAt.present) {
      map['executed_at'] = Variable<int>(executedAt.value);
    }
    if (deviceId.present) {
      map['device_id'] = Variable<String>(deviceId.value);
    }
    if (remoteRev.present) {
      map['remote_rev'] = Variable<String>(remoteRev.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SearchHistoryCompanion(')
          ..write('id: $id, ')
          ..write('kind: $kind, ')
          ..write('termTitle: $termTitle, ')
          ..write('conceptId: $conceptId, ')
          ..write('conceptType: $conceptType, ')
          ..write('sectionId: $sectionId, ')
          ..write('filtersJson: $filtersJson, ')
          ..write('cityId: $cityId, ')
          ..write('cityName: $cityName, ')
          ..write('lat: $lat, ')
          ..write('lon: $lon, ')
          ..write('executedAt: $executedAt, ')
          ..write('deviceId: $deviceId, ')
          ..write('remoteRev: $remoteRev')
          ..write(')'))
        .toString();
  }
}

class $SettingsTable extends Settings with TableInfo<$SettingsTable, Setting> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
      'key', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _boolValueMeta =
      const VerificationMeta('boolValue');
  @override
  late final GeneratedColumn<bool> boolValue = GeneratedColumn<bool>(
      'bool_value', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("bool_value" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [key, boolValue, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'settings';
  @override
  VerificationContext validateIntegrity(Insertable<Setting> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
          _keyMeta, key.isAcceptableOrUnknown(data['key']!, _keyMeta));
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('bool_value')) {
      context.handle(_boolValueMeta,
          boolValue.isAcceptableOrUnknown(data['bool_value']!, _boolValueMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  Setting map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Setting(
      key: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}key'])!,
      boolValue: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}bool_value'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $SettingsTable createAlias(String alias) {
    return $SettingsTable(attachedDatabase, alias);
  }
}

class Setting extends DataClass implements Insertable<Setting> {
  final String key;
  final bool boolValue;
  final int updatedAt;
  const Setting(
      {required this.key, required this.boolValue, required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['bool_value'] = Variable<bool>(boolValue);
    map['updated_at'] = Variable<int>(updatedAt);
    return map;
  }

  SettingsCompanion toCompanion(bool nullToAbsent) {
    return SettingsCompanion(
      key: Value(key),
      boolValue: Value(boolValue),
      updatedAt: Value(updatedAt),
    );
  }

  factory Setting.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Setting(
      key: serializer.fromJson<String>(json['key']),
      boolValue: serializer.fromJson<bool>(json['boolValue']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'boolValue': serializer.toJson<bool>(boolValue),
      'updatedAt': serializer.toJson<int>(updatedAt),
    };
  }

  Setting copyWith({String? key, bool? boolValue, int? updatedAt}) => Setting(
        key: key ?? this.key,
        boolValue: boolValue ?? this.boolValue,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  Setting copyWithCompanion(SettingsCompanion data) {
    return Setting(
      key: data.key.present ? data.key.value : this.key,
      boolValue: data.boolValue.present ? data.boolValue.value : this.boolValue,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Setting(')
          ..write('key: $key, ')
          ..write('boolValue: $boolValue, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, boolValue, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Setting &&
          other.key == this.key &&
          other.boolValue == this.boolValue &&
          other.updatedAt == this.updatedAt);
}

class SettingsCompanion extends UpdateCompanion<Setting> {
  final Value<String> key;
  final Value<bool> boolValue;
  final Value<int> updatedAt;
  final Value<int> rowid;
  const SettingsCompanion({
    this.key = const Value.absent(),
    this.boolValue = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SettingsCompanion.insert({
    required String key,
    this.boolValue = const Value.absent(),
    required int updatedAt,
    this.rowid = const Value.absent(),
  })  : key = Value(key),
        updatedAt = Value(updatedAt);
  static Insertable<Setting> custom({
    Expression<String>? key,
    Expression<bool>? boolValue,
    Expression<int>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (boolValue != null) 'bool_value': boolValue,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SettingsCompanion copyWith(
      {Value<String>? key,
      Value<bool>? boolValue,
      Value<int>? updatedAt,
      Value<int>? rowid}) {
    return SettingsCompanion(
      key: key ?? this.key,
      boolValue: boolValue ?? this.boolValue,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (boolValue.present) {
      map['bool_value'] = Variable<bool>(boolValue.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SettingsCompanion(')
          ..write('key: $key, ')
          ..write('boolValue: $boolValue, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $FavoritesTable favorites = $FavoritesTable(this);
  late final $SearchHistoryTable searchHistory = $SearchHistoryTable(this);
  late final $SettingsTable settings = $SettingsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [favorites, searchHistory, settings];
}

typedef $$FavoritesTableCreateCompanionBuilder = FavoritesCompanion Function({
  required String itemType,
  required String itemId,
  required String title,
  Value<String?> imageUrl,
  Value<String?> cityName,
  Value<String?> categoryName,
  Value<DateTime?> eventStart,
  required int updatedAt,
  Value<String?> deviceId,
  Value<String?> remoteRev,
  Value<int> rowid,
});
typedef $$FavoritesTableUpdateCompanionBuilder = FavoritesCompanion Function({
  Value<String> itemType,
  Value<String> itemId,
  Value<String> title,
  Value<String?> imageUrl,
  Value<String?> cityName,
  Value<String?> categoryName,
  Value<DateTime?> eventStart,
  Value<int> updatedAt,
  Value<String?> deviceId,
  Value<String?> remoteRev,
  Value<int> rowid,
});

class $$FavoritesTableFilterComposer
    extends Composer<_$AppDatabase, $FavoritesTable> {
  $$FavoritesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get itemType => $composableBuilder(
      column: $table.itemType, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get itemId => $composableBuilder(
      column: $table.itemId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get imageUrl => $composableBuilder(
      column: $table.imageUrl, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get cityName => $composableBuilder(
      column: $table.cityName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get categoryName => $composableBuilder(
      column: $table.categoryName, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get eventStart => $composableBuilder(
      column: $table.eventStart, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get deviceId => $composableBuilder(
      column: $table.deviceId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get remoteRev => $composableBuilder(
      column: $table.remoteRev, builder: (column) => ColumnFilters(column));
}

class $$FavoritesTableOrderingComposer
    extends Composer<_$AppDatabase, $FavoritesTable> {
  $$FavoritesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get itemType => $composableBuilder(
      column: $table.itemType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get itemId => $composableBuilder(
      column: $table.itemId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get imageUrl => $composableBuilder(
      column: $table.imageUrl, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get cityName => $composableBuilder(
      column: $table.cityName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get categoryName => $composableBuilder(
      column: $table.categoryName,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get eventStart => $composableBuilder(
      column: $table.eventStart, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get deviceId => $composableBuilder(
      column: $table.deviceId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get remoteRev => $composableBuilder(
      column: $table.remoteRev, builder: (column) => ColumnOrderings(column));
}

class $$FavoritesTableAnnotationComposer
    extends Composer<_$AppDatabase, $FavoritesTable> {
  $$FavoritesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get itemType =>
      $composableBuilder(column: $table.itemType, builder: (column) => column);

  GeneratedColumn<String> get itemId =>
      $composableBuilder(column: $table.itemId, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get imageUrl =>
      $composableBuilder(column: $table.imageUrl, builder: (column) => column);

  GeneratedColumn<String> get cityName =>
      $composableBuilder(column: $table.cityName, builder: (column) => column);

  GeneratedColumn<String> get categoryName => $composableBuilder(
      column: $table.categoryName, builder: (column) => column);

  GeneratedColumn<DateTime> get eventStart => $composableBuilder(
      column: $table.eventStart, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<String> get deviceId =>
      $composableBuilder(column: $table.deviceId, builder: (column) => column);

  GeneratedColumn<String> get remoteRev =>
      $composableBuilder(column: $table.remoteRev, builder: (column) => column);
}

class $$FavoritesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $FavoritesTable,
    Favorite,
    $$FavoritesTableFilterComposer,
    $$FavoritesTableOrderingComposer,
    $$FavoritesTableAnnotationComposer,
    $$FavoritesTableCreateCompanionBuilder,
    $$FavoritesTableUpdateCompanionBuilder,
    (Favorite, BaseReferences<_$AppDatabase, $FavoritesTable, Favorite>),
    Favorite,
    PrefetchHooks Function()> {
  $$FavoritesTableTableManager(_$AppDatabase db, $FavoritesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FavoritesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FavoritesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FavoritesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> itemType = const Value.absent(),
            Value<String> itemId = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<String?> imageUrl = const Value.absent(),
            Value<String?> cityName = const Value.absent(),
            Value<String?> categoryName = const Value.absent(),
            Value<DateTime?> eventStart = const Value.absent(),
            Value<int> updatedAt = const Value.absent(),
            Value<String?> deviceId = const Value.absent(),
            Value<String?> remoteRev = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              FavoritesCompanion(
            itemType: itemType,
            itemId: itemId,
            title: title,
            imageUrl: imageUrl,
            cityName: cityName,
            categoryName: categoryName,
            eventStart: eventStart,
            updatedAt: updatedAt,
            deviceId: deviceId,
            remoteRev: remoteRev,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String itemType,
            required String itemId,
            required String title,
            Value<String?> imageUrl = const Value.absent(),
            Value<String?> cityName = const Value.absent(),
            Value<String?> categoryName = const Value.absent(),
            Value<DateTime?> eventStart = const Value.absent(),
            required int updatedAt,
            Value<String?> deviceId = const Value.absent(),
            Value<String?> remoteRev = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              FavoritesCompanion.insert(
            itemType: itemType,
            itemId: itemId,
            title: title,
            imageUrl: imageUrl,
            cityName: cityName,
            categoryName: categoryName,
            eventStart: eventStart,
            updatedAt: updatedAt,
            deviceId: deviceId,
            remoteRev: remoteRev,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$FavoritesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $FavoritesTable,
    Favorite,
    $$FavoritesTableFilterComposer,
    $$FavoritesTableOrderingComposer,
    $$FavoritesTableAnnotationComposer,
    $$FavoritesTableCreateCompanionBuilder,
    $$FavoritesTableUpdateCompanionBuilder,
    (Favorite, BaseReferences<_$AppDatabase, $FavoritesTable, Favorite>),
    Favorite,
    PrefetchHooks Function()>;
typedef $$SearchHistoryTableCreateCompanionBuilder = SearchHistoryCompanion
    Function({
  Value<int> id,
  required String kind,
  Value<String?> termTitle,
  Value<String?> conceptId,
  Value<String?> conceptType,
  Value<String?> sectionId,
  Value<String?> filtersJson,
  Value<String?> cityId,
  Value<String?> cityName,
  Value<double?> lat,
  Value<double?> lon,
  required int executedAt,
  Value<String?> deviceId,
  Value<String?> remoteRev,
});
typedef $$SearchHistoryTableUpdateCompanionBuilder = SearchHistoryCompanion
    Function({
  Value<int> id,
  Value<String> kind,
  Value<String?> termTitle,
  Value<String?> conceptId,
  Value<String?> conceptType,
  Value<String?> sectionId,
  Value<String?> filtersJson,
  Value<String?> cityId,
  Value<String?> cityName,
  Value<double?> lat,
  Value<double?> lon,
  Value<int> executedAt,
  Value<String?> deviceId,
  Value<String?> remoteRev,
});

class $$SearchHistoryTableFilterComposer
    extends Composer<_$AppDatabase, $SearchHistoryTable> {
  $$SearchHistoryTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get kind => $composableBuilder(
      column: $table.kind, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get termTitle => $composableBuilder(
      column: $table.termTitle, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get conceptId => $composableBuilder(
      column: $table.conceptId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get conceptType => $composableBuilder(
      column: $table.conceptType, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get sectionId => $composableBuilder(
      column: $table.sectionId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get filtersJson => $composableBuilder(
      column: $table.filtersJson, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get cityId => $composableBuilder(
      column: $table.cityId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get cityName => $composableBuilder(
      column: $table.cityName, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get lat => $composableBuilder(
      column: $table.lat, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get lon => $composableBuilder(
      column: $table.lon, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get executedAt => $composableBuilder(
      column: $table.executedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get deviceId => $composableBuilder(
      column: $table.deviceId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get remoteRev => $composableBuilder(
      column: $table.remoteRev, builder: (column) => ColumnFilters(column));
}

class $$SearchHistoryTableOrderingComposer
    extends Composer<_$AppDatabase, $SearchHistoryTable> {
  $$SearchHistoryTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get kind => $composableBuilder(
      column: $table.kind, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get termTitle => $composableBuilder(
      column: $table.termTitle, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get conceptId => $composableBuilder(
      column: $table.conceptId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get conceptType => $composableBuilder(
      column: $table.conceptType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get sectionId => $composableBuilder(
      column: $table.sectionId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get filtersJson => $composableBuilder(
      column: $table.filtersJson, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get cityId => $composableBuilder(
      column: $table.cityId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get cityName => $composableBuilder(
      column: $table.cityName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get lat => $composableBuilder(
      column: $table.lat, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get lon => $composableBuilder(
      column: $table.lon, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get executedAt => $composableBuilder(
      column: $table.executedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get deviceId => $composableBuilder(
      column: $table.deviceId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get remoteRev => $composableBuilder(
      column: $table.remoteRev, builder: (column) => ColumnOrderings(column));
}

class $$SearchHistoryTableAnnotationComposer
    extends Composer<_$AppDatabase, $SearchHistoryTable> {
  $$SearchHistoryTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumn<String> get termTitle =>
      $composableBuilder(column: $table.termTitle, builder: (column) => column);

  GeneratedColumn<String> get conceptId =>
      $composableBuilder(column: $table.conceptId, builder: (column) => column);

  GeneratedColumn<String> get conceptType => $composableBuilder(
      column: $table.conceptType, builder: (column) => column);

  GeneratedColumn<String> get sectionId =>
      $composableBuilder(column: $table.sectionId, builder: (column) => column);

  GeneratedColumn<String> get filtersJson => $composableBuilder(
      column: $table.filtersJson, builder: (column) => column);

  GeneratedColumn<String> get cityId =>
      $composableBuilder(column: $table.cityId, builder: (column) => column);

  GeneratedColumn<String> get cityName =>
      $composableBuilder(column: $table.cityName, builder: (column) => column);

  GeneratedColumn<double> get lat =>
      $composableBuilder(column: $table.lat, builder: (column) => column);

  GeneratedColumn<double> get lon =>
      $composableBuilder(column: $table.lon, builder: (column) => column);

  GeneratedColumn<int> get executedAt => $composableBuilder(
      column: $table.executedAt, builder: (column) => column);

  GeneratedColumn<String> get deviceId =>
      $composableBuilder(column: $table.deviceId, builder: (column) => column);

  GeneratedColumn<String> get remoteRev =>
      $composableBuilder(column: $table.remoteRev, builder: (column) => column);
}

class $$SearchHistoryTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SearchHistoryTable,
    SearchHistoryData,
    $$SearchHistoryTableFilterComposer,
    $$SearchHistoryTableOrderingComposer,
    $$SearchHistoryTableAnnotationComposer,
    $$SearchHistoryTableCreateCompanionBuilder,
    $$SearchHistoryTableUpdateCompanionBuilder,
    (
      SearchHistoryData,
      BaseReferences<_$AppDatabase, $SearchHistoryTable, SearchHistoryData>
    ),
    SearchHistoryData,
    PrefetchHooks Function()> {
  $$SearchHistoryTableTableManager(_$AppDatabase db, $SearchHistoryTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SearchHistoryTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SearchHistoryTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SearchHistoryTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> kind = const Value.absent(),
            Value<String?> termTitle = const Value.absent(),
            Value<String?> conceptId = const Value.absent(),
            Value<String?> conceptType = const Value.absent(),
            Value<String?> sectionId = const Value.absent(),
            Value<String?> filtersJson = const Value.absent(),
            Value<String?> cityId = const Value.absent(),
            Value<String?> cityName = const Value.absent(),
            Value<double?> lat = const Value.absent(),
            Value<double?> lon = const Value.absent(),
            Value<int> executedAt = const Value.absent(),
            Value<String?> deviceId = const Value.absent(),
            Value<String?> remoteRev = const Value.absent(),
          }) =>
              SearchHistoryCompanion(
            id: id,
            kind: kind,
            termTitle: termTitle,
            conceptId: conceptId,
            conceptType: conceptType,
            sectionId: sectionId,
            filtersJson: filtersJson,
            cityId: cityId,
            cityName: cityName,
            lat: lat,
            lon: lon,
            executedAt: executedAt,
            deviceId: deviceId,
            remoteRev: remoteRev,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String kind,
            Value<String?> termTitle = const Value.absent(),
            Value<String?> conceptId = const Value.absent(),
            Value<String?> conceptType = const Value.absent(),
            Value<String?> sectionId = const Value.absent(),
            Value<String?> filtersJson = const Value.absent(),
            Value<String?> cityId = const Value.absent(),
            Value<String?> cityName = const Value.absent(),
            Value<double?> lat = const Value.absent(),
            Value<double?> lon = const Value.absent(),
            required int executedAt,
            Value<String?> deviceId = const Value.absent(),
            Value<String?> remoteRev = const Value.absent(),
          }) =>
              SearchHistoryCompanion.insert(
            id: id,
            kind: kind,
            termTitle: termTitle,
            conceptId: conceptId,
            conceptType: conceptType,
            sectionId: sectionId,
            filtersJson: filtersJson,
            cityId: cityId,
            cityName: cityName,
            lat: lat,
            lon: lon,
            executedAt: executedAt,
            deviceId: deviceId,
            remoteRev: remoteRev,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$SearchHistoryTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $SearchHistoryTable,
    SearchHistoryData,
    $$SearchHistoryTableFilterComposer,
    $$SearchHistoryTableOrderingComposer,
    $$SearchHistoryTableAnnotationComposer,
    $$SearchHistoryTableCreateCompanionBuilder,
    $$SearchHistoryTableUpdateCompanionBuilder,
    (
      SearchHistoryData,
      BaseReferences<_$AppDatabase, $SearchHistoryTable, SearchHistoryData>
    ),
    SearchHistoryData,
    PrefetchHooks Function()>;
typedef $$SettingsTableCreateCompanionBuilder = SettingsCompanion Function({
  required String key,
  Value<bool> boolValue,
  required int updatedAt,
  Value<int> rowid,
});
typedef $$SettingsTableUpdateCompanionBuilder = SettingsCompanion Function({
  Value<String> key,
  Value<bool> boolValue,
  Value<int> updatedAt,
  Value<int> rowid,
});

class $$SettingsTableFilterComposer
    extends Composer<_$AppDatabase, $SettingsTable> {
  $$SettingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key => $composableBuilder(
      column: $table.key, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get boolValue => $composableBuilder(
      column: $table.boolValue, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$SettingsTableOrderingComposer
    extends Composer<_$AppDatabase, $SettingsTable> {
  $$SettingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key => $composableBuilder(
      column: $table.key, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get boolValue => $composableBuilder(
      column: $table.boolValue, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$SettingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SettingsTable> {
  $$SettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<bool> get boolValue =>
      $composableBuilder(column: $table.boolValue, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$SettingsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SettingsTable,
    Setting,
    $$SettingsTableFilterComposer,
    $$SettingsTableOrderingComposer,
    $$SettingsTableAnnotationComposer,
    $$SettingsTableCreateCompanionBuilder,
    $$SettingsTableUpdateCompanionBuilder,
    (Setting, BaseReferences<_$AppDatabase, $SettingsTable, Setting>),
    Setting,
    PrefetchHooks Function()> {
  $$SettingsTableTableManager(_$AppDatabase db, $SettingsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SettingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> key = const Value.absent(),
            Value<bool> boolValue = const Value.absent(),
            Value<int> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              SettingsCompanion(
            key: key,
            boolValue: boolValue,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String key,
            Value<bool> boolValue = const Value.absent(),
            required int updatedAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              SettingsCompanion.insert(
            key: key,
            boolValue: boolValue,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$SettingsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $SettingsTable,
    Setting,
    $$SettingsTableFilterComposer,
    $$SettingsTableOrderingComposer,
    $$SettingsTableAnnotationComposer,
    $$SettingsTableCreateCompanionBuilder,
    $$SettingsTableUpdateCompanionBuilder,
    (Setting, BaseReferences<_$AppDatabase, $SettingsTable, Setting>),
    Setting,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$FavoritesTableTableManager get favorites =>
      $$FavoritesTableTableManager(_db, _db.favorites);
  $$SearchHistoryTableTableManager get searchHistory =>
      $$SearchHistoryTableTableManager(_db, _db.searchHistory);
  $$SettingsTableTableManager get settings =>
      $$SettingsTableTableManager(_db, _db.settings);
}
