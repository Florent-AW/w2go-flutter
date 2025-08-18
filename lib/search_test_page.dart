import 'dart:async';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// --- DTO ---
class Suggestion {
  final String term;
  final String conceptId;
  final String conceptType; // 'tag' | 'subcategory' | 'bundle' (si tu en as)
  final int popularity;

  Suggestion({
    required this.term,
    required this.conceptId,
    required this.conceptType,
    required this.popularity,
  });

  factory Suggestion.fromMap(Map<String, dynamic> m) => Suggestion(
    term: m['term'] as String,
    conceptId: m['concept_id'] as String,
    conceptType: m['concept_type'] as String,
    popularity: (m['popularity'] as num).toInt(),
  );
}

/// --- Service minimal ---
class SupabaseSearchService {
  final SupabaseClient _client = Supabase.instance.client;

  Future<List<Suggestion>> suggest({
    required String prefix,
    required double lat,
    required double lon,
    required double radiusKm,
    String lang = 'fr',
    int limit = 20,
  }) async {
    // IMPORTANT : passer lat/lon en double pour cibler la bonne surcharge SQL
    final res = await _client.rpc(
      'fn_suggest_terms',
      params: {
        'p_prefix': prefix,
        'p_lat': lat,
        'p_lon': lon,
        'p_radius_km': radiusKm,
        'p_lang': lang,
        'p_limit': limit,
      },
    );

    if (res == null) return const [];
    final list = (res as List).cast<Map<String, dynamic>>();
    return list.map(Suggestion.fromMap).toList();
  }
}

/// --- Page de test ---
class SearchTestPage extends StatefulWidget {
  const SearchTestPage({super.key});

  @override
  State<SearchTestPage> createState() => _SearchTestPageState();
}

class _SearchTestPageState extends State<SearchTestPage> {
  final _svc = SupabaseSearchService();

  final _prefixCtrl = TextEditingController(text: '');
  final _latCtrl = TextEditingController(text: '44.837789');  // Bordeaux
  final _lonCtrl = TextEditingController(text: '-0.57918');   // Bordeaux
  double _radiusKm = 50;

  Timer? _debounce;
  bool _loading = false;
  String? _error;
  List<Suggestion> _items = const [];

  @override
  void initState() {
    super.initState();
    // Option: un 1er tir pour vérifier que tout marche
    // _prefixCtrl.text = 'ba';
    // _triggerSearch();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _prefixCtrl.dispose();
    _latCtrl.dispose();
    _lonCtrl.dispose();
    super.dispose();
  }

  void _onPrefixChanged(String _) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), _triggerSearch);
  }

  Future<void> _triggerSearch() async {
    final prefix = _prefixCtrl.text.trim();
    final lat = double.tryParse(_latCtrl.text.trim()) ?? 44.837789;
    final lon = double.tryParse(_lonCtrl.text.trim()) ?? -0.57918;
    final radius = _radiusKm;

    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final list = await _svc.suggest(
        prefix: prefix,
        lat: lat,
        lon: lon,
        radiusKm: radius,
      );
      setState(() => _items = list);
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Test Recherche (MVP)'),
        actions: [
          IconButton(
            tooltip: 'Lancer',
            onPressed: _triggerSearch,
            icon: const Icon(Icons.play_arrow),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Ligne 1 : saisie + bouton clear
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _prefixCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Préfixe (ex: ba, pla, ran…)',
                    prefixIcon: Icon(Icons.search),
                  ),
                  onChanged: _onPrefixChanged,
                  textInputAction: TextInputAction.search,
                  onSubmitted: (_) => _triggerSearch(),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                tooltip: 'Effacer',
                onPressed: () {
                  _prefixCtrl.clear();
                  _onPrefixChanged('');
                },
                icon: const Icon(Icons.clear),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Ligne 2 : lat/lon
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _latCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Latitude',
                    prefixIcon: Icon(Icons.location_on_outlined),
                  ),
                  keyboardType: TextInputType.numberWithOptions(decimal: true, signed: true),
                  onSubmitted: (_) => _triggerSearch(),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: _lonCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Longitude',
                    prefixIcon: Icon(Icons.location_on_outlined),
                  ),
                  keyboardType: TextInputType.numberWithOptions(decimal: true, signed: true),
                  onSubmitted: (_) => _triggerSearch(),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Ligne 3 : rayon
          Text('Rayon : ${_radiusKm.toStringAsFixed(0)} km'),
          Slider(
            value: _radiusKm,
            min: 5,
            max: 150,
            divisions: 29,
            label: '${_radiusKm.toStringAsFixed(0)} km',
            onChanged: (v) => setState(() => _radiusKm = v),
            onChangeEnd: (_) => _triggerSearch(),
          ),

          const SizedBox(height: 8),

          if (_loading)
            const ListTile(
              leading: SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2)),
              title: Text('Chargement…'),
            ),

          if (_error != null)
            Card(
              color: theme.colorScheme.errorContainer,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Text(
                  _error!,
                  style: TextStyle(color: theme.colorScheme.onErrorContainer),
                ),
              ),
            ),

          if (!_loading && _error == null && _items.isEmpty && _prefixCtrl.text.isNotEmpty)
            const ListTile(
              leading: Icon(Icons.info_outline),
              title: Text('Aucune suggestion pour ce préfixe dans le rayon.'),
            ),

          // Résultats
          ..._items.map((s) => Card(
            child: ListTile(
              leading: CircleAvatar(
                child: Text(s.term.characters.first.toUpperCase()),
              ),
              title: Text(s.term),
              subtitle: Text('Type: ${s.conceptType} • Popularité: ${s.popularity}'),
              trailing: Chip(
                label: Text(s.conceptType),
              ),
              onTap: () {
                // Pour l’instant, juste un feedback.
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Term: ${s.term}\nConcept: ${s.conceptType}\nID: ${s.conceptId}')),
                );
                // Plus tard: pousser vers une page "Résultats d’activités" filtrée par conceptId/type.
              },
            ),
          )),
        ],
      ),
    );
  }
}
