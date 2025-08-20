// core/domain/ports/providers/repositories/settings_providers.dart

import 'package:riverpod/riverpod.dart';
import 'package:travel_in_perigord_app/core/domain/ports/providers/infrastructure/drift_providers.dart';
import 'package:travel_in_perigord_app/core/domain/repositories/settings_repository.dart';
import 'package:travel_in_perigord_app/core/infrastructure/repositories/drift_settings_repository.dart';

final settingsRepositoryProvider = Provider<SettingsRepository>((ref) {
  final db = ref.watch(driftDatabaseProvider);
  return DriftSettingsRepository(db);
});

/// Flag key constants
class SettingsKeys {
  static const String searchHistoryEnabled = 'search_history_enabled';
}
