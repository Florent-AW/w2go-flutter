// features/terms_search/presentation/pages/terms_search_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/terms_search_notifier.dart';
import '../widgets/terms_search_input.dart';
import '../widgets/terms_suggestions_list.dart';
import '../../../search/application/state/city_selection_state.dart';
import '../../../../routes/route_names.dart';
import '../../../../core/domain/models/search/term_suggestion.dart';
import '../../../../core/domain/ports/providers/search/terms_suggestion_providers.dart';

class TermsSearchPage extends ConsumerStatefulWidget {
  const TermsSearchPage({super.key});

  @override
  ConsumerState<TermsSearchPage> createState() => _TermsSearchPageState();
}

class _TermsSearchPageState extends ConsumerState<TermsSearchPage> {
  final _controller = TextEditingController();

  Future<void> _openTermDirect(String term) async {
    final city = ref.read(selectedCityProvider);
    if (city == null) return;
    try {
      // Use suggestion port to resolve the term to a concept (limit 1)
      final port = ref.read(termsSuggestionPortProvider);
      final suggestions = await port.suggest(
        term,
        lat: city.lat,
        lon: city.lon,
        radiusKm: 50,
        lang: 'fr',
        limit: 1,
      );
      if (suggestions.isNotEmpty) {
        // Reuse existing navigation flow
        await ref.read(termsSearchNotifierProvider.notifier).onSuggestionTapped(suggestions.first);
        if (!mounted) return;
        Navigator.of(context).pushNamed(
          RouteNames.termsResults,
          arguments: {
            'conceptId': suggestions.first.conceptId,
            'conceptType': suggestions.first.conceptType,
            'title': term.isEmpty ? '' : term[0].toUpperCase() + term.substring(1),
            'radiusKm': 50.0,
          },
        );
        return;
      }
    } catch (_) {
      // Fallback to regular query flow below
    }
    // Fallback: populate the input and trigger suggestions
    final capitalized = term.isEmpty ? '' : term[0].toUpperCase() + term.substring(1);
    _controller.text = capitalized;
    ref.read(termsSearchNotifierProvider.notifier).onQueryChanged(term);
  }

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
        'title': s.term,
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
          TermsSearchInput(controller: _controller, onChanged: (v) {
            // Capitalize first letter in UI while preserving query state
            if (v.isNotEmpty) {
              final c = v[0].toUpperCase() + v.substring(1);
              if (c != _controller.text) {
                final sel = _controller.selection;
                _controller.value = TextEditingValue(text: c, selection: sel);
              }
            }
            ref.read(termsSearchNotifierProvider.notifier).onQueryChanged(v);
          }),
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
                            label: Text(t.isEmpty ? '' : t[0].toUpperCase() + t.substring(1)),
                            onPressed: () => _openTermDirect(t),
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
