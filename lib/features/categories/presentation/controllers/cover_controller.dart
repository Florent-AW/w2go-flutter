import 'package:flutter/foundation.dart';
import '../../../../../core/domain/models/shared/category_view_model.dart';

/// Contrôleur pour gérer les transitions de couverture de catégorie
/// sans provoquer de reconstruction complète du header
class CoverController extends ChangeNotifier {
  CategoryViewModel _category;
  CategoryViewModel? _previousCategory;
  bool _isAnimating = false;

  CoverController(this._category);

  CategoryViewModel get category => _category;
  CategoryViewModel? get previousCategory => _previousCategory;
  bool get isAnimating => _isAnimating;

  void updateCategory(CategoryViewModel newCategory) {
    if (_category.id != newCategory.id) {
      _previousCategory = _category;
      _category = newCategory;
      _isAnimating = true;
      notifyListeners();

      // Réinitialiser l'animation après un délai
      Future.delayed(const Duration(milliseconds: 300), () {
        _isAnimating = false;
        notifyListeners();
      });
    }
  }
}