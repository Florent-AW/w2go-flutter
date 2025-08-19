// features/terms_search/presentation/widgets/terms_results_header.dart

import 'package:flutter/material.dart';

class TermsResultsHeader extends StatelessWidget {
  final String title;
  final int totalCount;
  final String subtitle;

  const TermsResultsHeader({super.key, required this.title, required this.totalCount, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    String capitalize(String s) => s.isEmpty ? s : s[0].toUpperCase() + s.substring(1);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                capitalize(title),
                style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withOpacity(0.08),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text('$totalCount résultats', style: theme.textTheme.bodyMedium),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Text(subtitle, style: theme.textTheme.bodyMedium?.copyWith(color: theme.hintColor)),
      ],
    );
  }
}
