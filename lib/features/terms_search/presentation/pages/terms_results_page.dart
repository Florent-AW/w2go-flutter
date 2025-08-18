// features/terms_search/presentation/pages/terms_results_page.dart

import 'package:flutter/material.dart';

class TermsResultsPage extends StatelessWidget {
  final String conceptId;
  final String conceptType;
  final String cityName;
  final double radiusKm;

  const TermsResultsPage({super.key, required this.conceptId, required this.conceptType, required this.cityName, this.radiusKm = 50});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Résultats')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.search, size: 48),
              const SizedBox(height: 12),
              Text('Concept: $conceptType'),
              Text('ID: $conceptId'),
              Text('Ville: $cityName'),
              Text('Rayon: ${radiusKm.toStringAsFixed(0)} km'),
              const SizedBox(height: 16),
              const Text('Écran placeholder. Les résultats d\'activités seront branchés ensuite.'),
            ],
          ),
        ),
      ),
    );
  }
}
