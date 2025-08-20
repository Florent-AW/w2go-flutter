// core/domain/ports/providers/repositories/repository_providers.dart

import 'package:riverpod/riverpod.dart';
import 'package:travel_in_perigord_app/core/domain/ports/providers/infrastructure/drift_providers.dart';
import 'package:travel_in_perigord_app/core/domain/repositories/favorites_repository.dart';
import 'package:travel_in_perigord_app/core/domain/repositories/search_history_repository.dart';
import 'package:travel_in_perigord_app/core/infrastructure/repositories/drift_favorites_repository.dart';
import 'package:travel_in_perigord_app/core/infrastructure/repositories/drift_search_history_repository.dart';

final favoritesRepositoryProvider = Provider<FavoritesRepository>((ref) {
  final db = ref.watch(driftDatabaseProvider);
  return DriftFavoritesRepository(db);
});

final searchHistoryRepositoryProvider = Provider<SearchHistoryRepository>((ref) {
  final db = ref.watch(driftDatabaseProvider);
  // pass ref if constructor supports it; otherwise, wrap via a factory or separate provider
  return DriftSearchHistoryRepository(db, ref: ref);
});
