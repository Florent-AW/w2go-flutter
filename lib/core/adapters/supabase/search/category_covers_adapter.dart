// lib/core/adapters/supabase/search/category_covers_adapter.dart


import '../../../domain/models/shared/category_department_cover_model.dart';
import '../../../domain/ports/search/category_covers_port.dart';
import '../database_adapter.dart'; // Pour accéder à SupabaseService

class CategoryCoversAdapter implements CategoryCoversPort {

  @override
  Future<String?> getDescriptionForCategoryAndDepartment(
      String categoryId,
      String departmentCode
      ) async {
    try {
      final response = await SupabaseService.client
          .from('category_department_covers')
          .select('description')
          .eq('category_id', categoryId)
          .eq('department_code', departmentCode)
          .maybeSingle();

      return response?['description'] as String?;
    } catch (e) {
      print('Erreur lors de la récupération de la description: $e');
      return null;
    }
  }

  @override
  Future<String?> getCoverUrlForCategoryAndDepartment(
      String categoryId,
      String departmentCode
      ) async {
    try {
      final response = await SupabaseService.client
          .from('category_department_covers')
          .select('cover_url')
          .eq('category_id', categoryId)
          .eq('department_code', departmentCode)
          .maybeSingle();

      return response?['cover_url'] as String?;
    } catch (e) {
      print('Erreur lors de la récupération de la couverture: $e');
      return null;
    }
  }

  @override
  Future<List<CategoryDepartmentCover>> getAllCoversForCategory(String categoryId) async {
    try {
      final response = await SupabaseService.client
          .from('category_department_covers')
          .select()
          .eq('category_id', categoryId)
          .order('priority');

      return (response as List)
          .map((json) => CategoryDepartmentCover.fromJson(json))
          .toList();
    } catch (e) {
      print('Erreur lors de la récupération des couvertures: $e');
      return [];
    }
  }
}