// lib/features/search/application/state/selected_subcategory_state.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/domain/models/shared/subcategory_model.dart';

class SelectedSubcategoryState extends StateNotifier<Subcategory?> {
  SelectedSubcategoryState() : super(null);

  void selectSubcategory(Subcategory? subcategory) {
    state = subcategory;
  }

  void reset() {
    state = null;
  }
}

final selectedSubcategoryProvider = StateNotifierProvider<SelectedSubcategoryState, Subcategory?>((ref) {
  return SelectedSubcategoryState();
});