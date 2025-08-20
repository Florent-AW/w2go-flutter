// core/domain/repositories/favorites_repository.dart

import '../models/shared/experience_item.dart';

abstract class FavoritesRepository {
  Stream<bool> isFavorite({required String itemType, required String itemId});
  Future<void> toggleFavorite({
    required String itemType,
    required String itemId,
    required String title,
    String? imageUrl,
    String? cityName,
    String? categoryName,
    DateTime? eventStart,
  });
  Stream<List<ExperienceItem>> watchFavorites({String? itemType});
}
