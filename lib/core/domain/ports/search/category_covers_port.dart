// lib/core/domain/ports/search/category_covers_port.dart
import '../../models/shared/category_department_cover_model.dart';

abstract class CategoryCoversPort {
  /// Récupère l'URL de couverture spécifique au département pour une catégorie
  Future<String?> getCoverUrlForCategoryAndDepartment(
      String categoryId,
      String departmentCode
      );

  /// Récupère toutes les couvertures par département pour une catégorie
  Future<List<CategoryDepartmentCover>> getAllCoversForCategory(String categoryId);

  Future<String?> getDescriptionForCategoryAndDepartment(
      String categoryId,
      String departmentCode
      );

}