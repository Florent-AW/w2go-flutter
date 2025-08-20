// core/infrastructure/repositories/drift_favorites_repository.dart

import 'package:drift/drift.dart';
import '../../infrastructure/db/app_database.dart';
import '../../domain/repositories/favorites_repository.dart';
import '../../domain/models/shared/experience_item.dart';
import '../../domain/models/activity/base/activity_base.dart';
import '../../domain/models/activity/search/searchable_activity.dart';
import '../../domain/models/event/base/event_base.dart';
import '../../domain/models/event/search/searchable_event.dart';

class DriftFavoritesRepository implements FavoritesRepository {
  final AppDatabase _db;
  DriftFavoritesRepository(this._db);

  @override
  Stream<bool> isFavorite({required String itemType, required String itemId}) {
    final query = (_db.select(_db.favorites)..where((f) => f.itemType.equals(itemType) & f.itemId.equals(itemId)))
        .watchSingleOrNull();
    return query.map((row) => row != null);
  }

  @override
  Future<void> toggleFavorite({
    required String itemType,
    required String itemId,
    required String title,
    String? imageUrl,
    String? cityName,
    String? categoryName,
    DateTime? eventStart,
  }) async {
    await _db.transaction(() async {
      final existing = await (_db.select(_db.favorites)
            ..where((f) => f.itemType.equals(itemType) & f.itemId.equals(itemId)))
          .getSingleOrNull();
      if (existing != null) {
        await (_db.delete(_db.favorites)
              ..where((f) => f.itemType.equals(itemType) & f.itemId.equals(itemId)))
            .go();
        return;
      }
      await _db.into(_db.favorites).insertOnConflictUpdate(FavoritesCompanion.insert(
        itemType: itemType,
        itemId: itemId,
        title: title,
        imageUrl: Value(imageUrl),
        cityName: Value(cityName),
        categoryName: Value(categoryName),
        eventStart: Value(eventStart),
        updatedAt: DateTime.now().millisecondsSinceEpoch,
        deviceId: const Value(null),
        remoteRev: const Value(null),
      ));
    });
  }

  @override
  Stream<List<ExperienceItem>> watchFavorites({String? itemType}) {
    final sel = _db.select(_db.favorites);
    if (itemType != null) {
      sel.where((f) => f.itemType.equals(itemType));
    }
    sel.orderBy([(f) => OrderingTerm.desc(f.updatedAt)]);
    return sel.watch().map((rows) => rows.map((r) {
          if (r.itemType == 'event') {
            final eventBase = EventBase(
              id: r.itemId,
              name: r.title,
              description: null,
              latitude: 0.0,
              longitude: 0.0,
              categoryId: '',
              subcategoryId: null,
              city: r.cityName,
              imageUrl: r.imageUrl,
              startDate: r.eventStart ?? DateTime.fromMillisecondsSinceEpoch(0),
              endDate: r.eventStart ?? DateTime.fromMillisecondsSinceEpoch(0),
            );
            final event = SearchableEvent(base: eventBase, categoryName: r.categoryName, city: r.cityName, mainImageUrl: r.imageUrl);
            return ExperienceItem.event(event);
          } else {
            final activityBase = ActivityBase(
              id: r.itemId,
              name: r.title,
              description: null,
              latitude: 0.0,
              longitude: 0.0,
              categoryId: '',
              subcategoryId: null,
              city: r.cityName,
              imageUrl: r.imageUrl,
            );
            final activity = SearchableActivity(base: activityBase, categoryName: r.categoryName, city: r.cityName, mainImageUrl: r.imageUrl);
            return ExperienceItem.activity(activity);
          }
        }).toList());
  }
}
