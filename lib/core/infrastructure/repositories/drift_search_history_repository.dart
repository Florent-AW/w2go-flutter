// core/infrastructure/repositories/drift_search_history_repository.dart

import 'package:drift/drift.dart';
import '../../infrastructure/db/app_database.dart';
import '../../domain/repositories/search_history_repository.dart';
import '../../domain/ports/providers/repositories/settings_providers.dart';
import 'package:riverpod/riverpod.dart';

class DriftSearchHistoryRepository implements SearchHistoryRepository {
  final AppDatabase _db;
  final Ref? ref; // optional for DI of settings

  DriftSearchHistoryRepository(this._db, {this.ref});

  @override
  Future<void> addTermsExecution({
    required String conceptId,
    required String conceptType,
    required String termTitle,
    String? cityId,
    String? cityName,
    double? lat,
    double? lon,
  }) async {
    // settings flag gate
    final enabled = ref != null
        ? await ref!.read(settingsRepositoryProvider).getFlag(SettingsKeys.searchHistoryEnabled)
        : true;
    if (!enabled) return;
    final now = DateTime.now().millisecondsSinceEpoch;
    // dedup 24h
    final dayAgo = now - 24 * 60 * 60 * 1000;
    final existingSel = _db.select(_db.searchHistory)
      ..where((h) => h.kind.equals('terms') & h.conceptId.equals(conceptId) & h.conceptType.equals(conceptType) & h.executedAt.isBiggerOrEqualValue(dayAgo));
    if (cityId == null) {
      existingSel.where((h) => h.cityId.isNull());
    } else {
      existingSel.where((h) => h.cityId.equals(cityId));
    }
    final existing = await existingSel.getSingleOrNull();
    if (existing != null) {
      await (_db.update(_db.searchHistory)..where((h) => h.id.equals(existing.id))).write(SearchHistoryCompanion(executedAt: Value(now)));
      return;
    }
    await _db.transaction(() async {
      await _db.into(_db.searchHistory).insert(SearchHistoryCompanion.insert(
        kind: 'terms',
        termTitle: Value(termTitle),
        conceptId: Value(conceptId),
        conceptType: Value(conceptType),
        cityId: Value(cityId),
        cityName: Value(cityName),
        lat: Value(lat),
        lon: Value(lon),
        executedAt: now,
        deviceId: const Value(null),
        remoteRev: const Value(null),
      ));
      await _enforceLru();
    });
  }

  @override
  Future<void> addSectionsExecution({
    required String sectionId,
    String? filtersJson,
    String? cityId,
    String? cityName,
    double? lat,
    double? lon,
  }) async {
    final enabled = ref != null
        ? await ref!.read(settingsRepositoryProvider).getFlag(SettingsKeys.searchHistoryEnabled)
        : true;
    if (!enabled) return;
    final now = DateTime.now().millisecondsSinceEpoch;
    final dayAgo = now - 24 * 60 * 60 * 1000;
    final existingSel = _db.select(_db.searchHistory)
      ..where((h) => h.kind.equals('sections') & h.sectionId.equals(sectionId) & h.executedAt.isBiggerOrEqualValue(dayAgo));
    if (cityId == null) {
      existingSel.where((h) => h.cityId.isNull());
    } else {
      existingSel.where((h) => h.cityId.equals(cityId));
    }
    if (filtersJson == null) {
      existingSel.where((h) => h.filtersJson.isNull());
    } else {
      existingSel.where((h) => h.filtersJson.equals(filtersJson));
    }
    final existing = await existingSel.getSingleOrNull();
    if (existing != null) {
      await (_db.update(_db.searchHistory)..where((h) => h.id.equals(existing.id))).write(SearchHistoryCompanion(executedAt: Value(now)));
      return;
    }
    await _db.transaction(() async {
      await _db.into(_db.searchHistory).insert(SearchHistoryCompanion.insert(
        kind: 'sections',
        sectionId: Value(sectionId),
        filtersJson: Value(filtersJson),
        cityId: Value(cityId),
        cityName: Value(cityName),
        lat: Value(lat),
        lon: Value(lon),
        executedAt: now,
        deviceId: const Value(null),
        remoteRev: const Value(null),
      ));
      await _enforceLru();
    });
  }

  Future<void> _enforceLru() async {
    final rows = await (_db.select(_db.searchHistory)
          ..orderBy([(h) => OrderingTerm.desc(h.executedAt)])
          ..limit(1000))
        .get();
    if (rows.length > 200) {
      final idsToKeep = rows.take(200).map((e) => e.id).toSet();
      await (_db.delete(_db.searchHistory)
            ..where((h) => h.id.isNotIn(idsToKeep.toList())))
          .go();
    }
  }

  @override
  Stream<List<Map<String, dynamic>>> watchRecent({String? kind, int limit = 50}) {
    final sel = _db.select(_db.searchHistory);
    if (kind != null) sel.where((h) => h.kind.equals(kind));
    sel.orderBy([(h) => OrderingTerm.desc(h.executedAt)]);
    sel.limit(limit);
    return sel.watch().map((rows) => rows.map((r) => {
          'id': r.id,
          'kind': r.kind,
          'termTitle': r.termTitle,
          'conceptId': r.conceptId,
          'conceptType': r.conceptType,
          'sectionId': r.sectionId,
          'filtersJson': r.filtersJson,
          'cityId': r.cityId,
          'cityName': r.cityName,
          'lat': r.lat,
          'lon': r.lon,
          'executedAt': r.executedAt,
        }).toList());
  }

  @override
  Future<void> clearAll() async {
    await _db.delete(_db.searchHistory).go();
  }

  @override
  Future<void> setEnabled(bool enabled) async {}

  @override
  Stream<bool> watchEnabled() {
    if (ref == null) return Stream.value(true);
    return ref!.read(settingsRepositoryProvider).watchFlag(SettingsKeys.searchHistoryEnabled);
  }
}
