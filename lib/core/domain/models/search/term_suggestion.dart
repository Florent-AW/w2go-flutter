// core/domain/models/search/term_suggestion.dart

import 'package:equatable/equatable.dart';

/// Domain model representing a search term suggestion returned by Supabase RPC.
class TermSuggestion extends Equatable {
  final String term;
  final String conceptId;
  /// Raw string as received from backend (kept for display/backward-compat)
  final String conceptType;
  final int popularity;

  const TermSuggestion({
    required this.term,
    required this.conceptId,
    required this.conceptType,
    required this.popularity,
  });

  /// Safer enum access to the concept type
  TermConceptType get type => TermConceptTypeX.fromString(conceptType);

  factory TermSuggestion.fromSupabase(Map<String, dynamic> map) {
    return TermSuggestion(
      term: (map['term'] ?? '').toString(),
      conceptId: (map['concept_id'] ?? '').toString(),
      conceptType: (map['concept_type'] ?? '').toString(),
      popularity: (map['popularity'] as num? ?? 0).toInt(),
    );
  }

  @override
  List<Object?> get props => [term, conceptId, conceptType, popularity];
}

/// Enum for concept types returned by the backend
enum TermConceptType { tag, subcategory, bundle, unknown }

extension TermConceptTypeX on TermConceptType {
  static TermConceptType fromString(String value) {
    switch (value.toLowerCase()) {
      case 'tag':
        return TermConceptType.tag;
      case 'subcategory':
        return TermConceptType.subcategory;
      case 'bundle':
        return TermConceptType.bundle;
      default:
        return TermConceptType.unknown;
    }
  }

  String get asString {
    switch (this) {
      case TermConceptType.tag:
        return 'tag';
      case TermConceptType.subcategory:
        return 'subcategory';
      case TermConceptType.bundle:
        return 'bundle';
      case TermConceptType.unknown:
        return 'unknown';
    }
  }
}
