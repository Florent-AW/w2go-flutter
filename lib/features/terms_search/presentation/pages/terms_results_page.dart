// features/terms_search/presentation/pages/terms_results_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/terms_results_sections_notifier.dart';
import '../../../../core/domain/models/search/concept_types.dart';
import '../../../search/application/state/city_selection_state.dart';
import '../widgets/terms_results_header.dart';
import '../widgets/terms_results_list.dart';
import '../../../../core/domain/models/search/result_section.dart';

class TermsResultsPage extends ConsumerStatefulWidget {
  const TermsResultsPage({super.key});

  @override
  ConsumerState<TermsResultsPage> createState() => _TermsResultsPageState();
}

class _TermsResultsPageState extends ConsumerState<TermsResultsPage> {
  bool _initialized = false;
  late String _conceptId;
  late ConceptType _conceptType;
  late String _title;
  double _radiusKm = 50.0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialized) return;
    final raw = (ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?);
    _conceptId = (raw?['conceptId'] ?? '').toString();
    final conceptTypeRaw = (raw?['conceptType'] ?? '').toString();
    _title = (raw?['title'] ?? '').toString();
    _radiusKm = (raw?['radiusKm'] as num?)?.toDouble() ?? 50.0;
    _conceptType = ConceptTypeX.fromString(conceptTypeRaw);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(termsResultsSectionsNotifierProvider.notifier).initialize((
        conceptId: _conceptId,
        conceptType: _conceptType,
        title: _title,
      ));
    });
    _initialized = true;
  }

  @override
  Widget build(BuildContext context) {
    final city = ref.watch(selectedCityProvider);
    final state = ref.watch(termsResultsSectionsNotifierProvider);

    final totalCount = state.sections
        .map<int>((ResultSection s) => s.items.length)
        .fold<int>(0, (sum, n) => sum + n);

    return Scaffold(
      appBar: AppBar(title: const Text('Résultats')),
      body: RefreshIndicator(
        onRefresh: () => ref.read(termsResultsSectionsNotifierProvider.notifier).refresh(),
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TermsResultsHeader(
              title: _initialized ? _title : '',
              totalCount: totalCount,
              subtitle: '${city?.cityName ?? ''} • ${_initialized ? _radiusKm.toStringAsFixed(0) : '50'} km',
            ),
            const SizedBox(height: 12),
            TermsResultsListSectioned(
              requestStatus: state.status,
              sections: state.sections,
              onRetry: () => ref.read(termsResultsSectionsNotifierProvider.notifier).refresh(),
              emptyMessage: _initialized
                  ? 'Aucune activité pour « ${_title} » autour de ${city?.cityName ?? 'votre ville'} (50 km).'
                  : 'Aucune activité.',
            ),
          ],
        ),
      ),
    );
  }
}
