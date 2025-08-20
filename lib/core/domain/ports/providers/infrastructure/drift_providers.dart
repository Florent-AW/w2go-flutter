// core/domain/ports/providers/infrastructure/drift_providers.dart

import 'package:riverpod/riverpod.dart';
import 'package:travel_in_perigord_app/core/infrastructure/db/app_database.dart';

final driftDatabaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(() => db.close());
  return db;
});
