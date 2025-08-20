// core/infrastructure/repositories/drift_settings_repository.dart

import 'package:drift/drift.dart';
import '../../infrastructure/db/app_database.dart';
import '../../domain/repositories/settings_repository.dart';

class DriftSettingsRepository implements SettingsRepository {
  final AppDatabase _db;
  DriftSettingsRepository(this._db);

  @override
  Stream<bool> watchFlag(String key, {bool defaultValue = true}) {
    final sel = _db.select(_db.settings)..where((s) => s.key.equals(key));
    return sel.watchSingleOrNull().map((row) => row?.boolValue ?? defaultValue);
  }

  @override
  Future<bool> getFlag(String key, {bool defaultValue = true}) async {
    final row = await (_db.select(_db.settings)..where((s) => s.key.equals(key))).getSingleOrNull();
    return row?.boolValue ?? defaultValue;
  }

  @override
  Future<void> setFlag(String key, bool value) async {
    final now = DateTime.now().millisecondsSinceEpoch;
    await _db.into(_db.settings).insertOnConflictUpdate(SettingsCompanion(
      key: Value(key),
      boolValue: Value(value),
      updatedAt: Value(now),
    ));
  }
}
