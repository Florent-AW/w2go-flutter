// lib/features/categories/presentation/controllers/cover_controller.dart

import 'package:flutter/foundation.dart';
import '../../../../../core/domain/models/shared/category_view_model.dart';

/// Contrôleur pour gérer les transitions de couverture de catégorie
/// sans provoquer de reconstruction complète du header
class CoverController extends ChangeNotifier {
  CategoryViewModel _category;
  CategoryViewModel? _previousCategory;
  bool _isAnimating = false;
  // ✅ Données préchargées pour affichage instantané
  String? _preloadTitle;
  String? _preloadCoverUrl;

  CoverController(this._category);

  CategoryViewModel get category => _category;
  CategoryViewModel? get previousCategory => _previousCategory;
  bool get isAnimating => _isAnimating;

  // ✅ CORRECTION + NOUVEAUX GETTERS : Accesseurs pour données préchargées
  String get displayTitle => _preloadTitle ?? _category.name;
  String get displayCoverUrl => _preloadCoverUrl ?? _category.imageUrl;

  void updateCategory(CategoryViewModel newCategory) {
    if (_category.id != newCategory.id) {
      _previousCategory = _category;
      _category = newCategory;
      _isAnimating = true;

      // ✅ NOUVEAU : Reset preload data quand on change sans preload
      _preloadTitle = null;
      _preloadCoverUrl = null;

      notifyListeners();

      // Réinitialiser l'animation après un délai
      Future.delayed(const Duration(milliseconds: 300), () {
        _isAnimating = false;
        notifyListeners();
      });
    }
  }

  // ✅ NOUVELLE MÉTHODE : Mise à jour avec données préchargées
  void updateCategoryWithPreload(
      CategoryViewModel newCategory, {
        required String preloadTitle,
        required String preloadCoverUrl,
      }) {
    if (_category.id != newCategory.id) {
      _previousCategory = _category;
      _category = newCategory;
      _isAnimating = true;

      // ✅ Conserver les données préchargées
      _preloadTitle = preloadTitle;
      _preloadCoverUrl = preloadCoverUrl;

      print('🎯 COVER CONTROLLER: Header instantané pour $preloadTitle');
      notifyListeners();

      // Réinitialiser l'animation après un délai
      Future.delayed(const Duration(milliseconds: 300), () {
        _isAnimating = false;
        notifyListeners();
      });
    }
  }

  // ✅ NOUVEAU HELPER : Vérifie si on a des données préchargées
  bool get hasPreloadedData => _preloadTitle != null && _preloadCoverUrl != null;
}