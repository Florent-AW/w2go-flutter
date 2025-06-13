// lib/core/domain/ports/search/category_search_port.dart
import '../../models/shared/category_model.dart';

abstract class CategorySearchPort {
  Future<List<Category>> getAllCategories();
}