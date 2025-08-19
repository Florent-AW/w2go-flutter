// core/domain/models/search/concept_types.dart

enum ConceptType { tag, subcategory, bundle }

extension ConceptTypeX on ConceptType {
  String get asParam {
    switch (this) {
      case ConceptType.tag:
        return 'tag';
      case ConceptType.subcategory:
        return 'subcategory';
      case ConceptType.bundle:
        return 'bundle';
    }
  }

  static ConceptType fromString(String raw) {
    switch (raw.toLowerCase()) {
      case 'tag':
        return ConceptType.tag;
      case 'subcategory':
        return ConceptType.subcategory;
      case 'bundle':
        return ConceptType.bundle;
      default:
        return ConceptType.tag; // safe fallback
    }
  }
}

enum SortMode { distance, rating }

extension SortModeX on SortMode {
  String get asParam => this == SortMode.distance ? 'distance' : 'rating';
}
