// features/terms_search/presentation/widgets/terms_suggestions_list.dart

import 'package:flutter/material.dart';
import '../../../../core/domain/models/search/term_suggestion.dart';

class TermsSuggestionsList extends StatelessWidget {
  final List<TermSuggestion> items;
  final void Function(TermSuggestion) onTap;

  const TermsSuggestionsList({super.key, required this.items, required this.onTap});

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) return const SizedBox.shrink();
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final s = items[index];
        return Card(
          child: ListTile(
            leading: CircleAvatar(
              child: Text(
                (s.term.isNotEmpty ? s.term[0] : '?').toUpperCase(),
              ),
            ),
            title: Text(s.term),
            subtitle: Text('Type: ${s.conceptType} • Popularité: ${s.popularity}'),
            trailing: Chip(label: Text(s.conceptType)),
            onTap: () => onTap(s),
          ),
        );
      },
    );
  }
}
