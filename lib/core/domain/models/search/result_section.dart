// core/domain/models/search/result_section.dart

import '../activity/search/searchable_activity.dart';

class ResultSection {
  final String key;
  final String title;
  final int index;
  final List<SearchableActivity> items;

  const ResultSection({
    required this.key,
    required this.title,
    required this.index,
    required this.items,
  });
}
