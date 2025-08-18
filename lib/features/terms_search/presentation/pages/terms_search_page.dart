// features/terms_search/presentation/pages/terms_search_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/terms_search_notifier.dart';
import '../widgets/terms_search_input.dart';
import '../widgets/terms_suggestions_list.dart';
import '../../../search/application/state/city_selection_state.dart';
import '../../../../routes/route_names.dart';
import '../../../../core/domain/models/search/term_suggestion.dart';

class TermsSearchPage extends ConsumerStatefulWidget {
  const TermsSearchPage({super.key});

  @override
  ConsumerState<TermsSearchPage> createState() => _TermsSearchPageState();
}

class _TermsSearchPageState extends ConsumerState<TermsSearchPage> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapSuggestion(TermSuggestion s) async {
    await ref.read(termsSearchNotifierProvider.notifier).onSuggestionTapped(s);
    final city = ref.read(selectedCityProvider);
    if (!mounted || city == null) return;
    Navigator.of(context).pushNamed(
      RouteNames.termsResults,
      arguments: {
        'conceptId': s.conceptId,
        'conceptType': s.conceptType,
        'cityName': city.cityName,
        'radiusKm': 50.0,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(termsSearchNotifierProvider);
    final city = ref.watch(selectedCityProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Rechercher'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TermsSearchInput(controller: _controller, onChanged: ref.read(termsSearchNotifierProvider.notifier).onQueryChanged),
          const SizedBox(height: 12),
          if (state.status == TermsSearchStatus.error && state.error != null)
            Card(
              color: Theme.of(context).colorScheme.errorContainer,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Text(
                  state.error!,
                  style: TextStyle(color: Theme.of(context).colorScheme.onErrorContainer),
                ),
              ),
            ),
          if (state.status == TermsSearchStatus.loading)
            const ListTile(
              leading: SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2)),
              title: Text('Chargement…'),
            ),
          if (state.status == TermsSearchStatus.empty)
            ListTile(
              leading: const Icon(Icons.info_outline),
              title: Text('Aucune suggestion autour de ${city?.cityName ?? "votre ville"} dans 50 km.'),
            ),
          if (state.query.trim().isEmpty && state.recentTerms.isNotEmpty)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Récents'),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: state.recentTerms
                      .map((t) => ActionChip(
                            label: Text(t),
                            onPressed: () {
                              _controller.text = t;
                              ref.read(termsSearchNotifierProvider.notifier).onQueryChanged(t);
                            },
                          ))
                      .toList(),
                ),
                const SizedBox(height: 16),
              ],
            ),
          TermsSuggestionsList(items: state.items, onTap: _onTapSuggestion),
        ],
      ),
    );
  }
}
