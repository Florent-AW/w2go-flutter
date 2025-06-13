// lib/core/domain/models/shared/category_view_model.dart

import 'category_model.dart';

import 'package:freezed_annotation/freezed_annotation.dart';

part 'category_view_model.freezed.dart';
part 'category_view_model.g.dart';

@freezed
class CategoryViewModel with _$CategoryViewModel {
  const factory CategoryViewModel({
    required String id,
    required String name,
    required String imageUrl,
    @Default('#FFFFFF') String color,
    String? description,
    String? icon, // Assurez-vous que ce champ existe
  }) = _CategoryViewModel;

  factory CategoryViewModel.fromJson(Map<String, dynamic> json) =>
      _$CategoryViewModelFromJson(json);

  // Pour convertir depuis Category (modèle domain)
  factory CategoryViewModel.fromCategory(Category category) {
    return CategoryViewModel(
      id: category.id,
      name: category.name,
      imageUrl: category.coverUrl ?? '',
      color: category.color ?? '#FFFFFF',
      description: category.description,
    );
  }
}