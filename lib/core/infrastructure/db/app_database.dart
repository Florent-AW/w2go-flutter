// core/infrastructure/db/app_database.dart

import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

part 'app_database.g.dart';

class Favorites extends Table {
  TextColumn get itemType => text()(); // 'activity' | 'event'
  TextColumn get itemId => text()();
  TextColumn get title => text()();
  TextColumn get imageUrl => text().nullable()();
  TextColumn get cityName => text().nullable()();
  TextColumn get categoryName => text().nullable()();
  DateTimeColumn get eventStart => dateTime().nullable()();
  IntColumn get updatedAt => integer()(); // epoch ms
  TextColumn get deviceId => text().nullable()();
  TextColumn get remoteRev => text().nullable()();

  @override
  Set<Column> get primaryKey => {itemType, itemId};

  @override
  List<Index> get indexes => [
        Index('idx_favorites_type', 'CREATE INDEX IF NOT EXISTS idx_favorites_type ON favorites (item_type)'),
        Index('idx_favorites_updated_at', 'CREATE INDEX IF NOT EXISTS idx_favorites_updated_at ON favorites (updated_at)'),
        Index('idx_favorites_type_updated_at', 'CREATE INDEX IF NOT EXISTS idx_favorites_type_updated_at ON favorites (item_type, updated_at)'),
      ];
}

class SearchHistory extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get kind => text()(); // 'terms' | 'sections'
  TextColumn get termTitle => text().nullable()();
  TextColumn get conceptId => text().nullable()();
  TextColumn get conceptType => text().nullable()();
  TextColumn get sectionId => text().nullable()();
  TextColumn get filtersJson => text().nullable()();
  TextColumn get cityId => text().nullable()();
  TextColumn get cityName => text().nullable()();
  RealColumn get lat => real().nullable()();
  RealColumn get lon => real().nullable()();
  IntColumn get executedAt => integer()(); // epoch ms
  TextColumn get deviceId => text().nullable()();
  TextColumn get remoteRev => text().nullable()();

  @override
  List<Index> get indexes => [
        Index('idx_history_kind_executed_at', 'CREATE INDEX IF NOT EXISTS idx_history_kind_executed_at ON search_history (kind, executed_at)'),
        Index('idx_history_executed_at', 'CREATE INDEX IF NOT EXISTS idx_history_executed_at ON search_history (executed_at)'),
        Index('idx_history_city_executed_at', 'CREATE INDEX IF NOT EXISTS idx_history_city_executed_at ON search_history (city_id, executed_at)'),
      ];
}

class Settings extends Table {
  TextColumn get key => text()();
  BoolColumn get boolValue => boolean().withDefault(const Constant(true))();
  IntColumn get updatedAt => integer()();

  @override
  Set<Column> get primaryKey => {key};
}

@DriftDatabase(tables: [Favorites, SearchHistory, Settings])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, 'app.db'));
    return NativeDatabase.createInBackground(file);
  });
}
