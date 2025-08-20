// features/history/presentation/pages/search_history_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travel_in_perigord_app/core/domain/ports/providers/repositories/repository_providers.dart';
import 'package:travel_in_perigord_app/core/domain/ports/providers/repositories/settings_providers.dart';

class SearchHistoryPage extends ConsumerWidget {
  const SearchHistoryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final enabledStream = ref.watch(settingsRepositoryProvider).watchFlag(SettingsKeys.searchHistoryEnabled);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Historique des recherches'),
        actions: [
          IconButton(
            onPressed: () async {
              await ref.read(searchHistoryRepositoryProvider).clearAll();
            },
            icon: const Icon(Icons.delete_outline),
            tooltip: 'Effacer l\'historique',
          )
        ],
      ),
      body: StreamBuilder<bool>(
        stream: enabledStream,
        initialData: true,
        builder: (context, snapshot) {
          final enabled = snapshot.data ?? true;
          if (!enabled) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.history_toggle_off, size: 48),
                  SizedBox(height: 12),
                  Text('Historique désactivé'),
                ],
              ),
            );
          }
          return StreamBuilder<List<Map<String, dynamic>>>(
            stream: ref.read(searchHistoryRepositoryProvider).watchRecent(limit: 200),
            initialData: const [],
            builder: (context, snap) {
              final items = snap.data ?? const [];
              if (items.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.search_off, size: 48),
                      SizedBox(height: 12),
                      Text('Aucune recherche récente'),
                    ],
                  ),
                );
              }
              return ListView.separated(
                padding: const EdgeInsets.all(16),
                itemBuilder: (context, index) {
                  final it = items[index];
                  final title = it['termTitle'] ?? it['sectionId'] ?? 'Recherche';
                  final city = it['cityName'];
                  final when = DateTime.fromMillisecondsSinceEpoch(it['executedAt'] as int);
                  return Dismissible(
                    key: ValueKey('h_${it['id']}'),
                    background: Container(color: Colors.redAccent),
                    onDismissed: (_) async {
                      // For MVP: full clear not per-row delete; can extend later with per-id delete
                      await ref.read(searchHistoryRepositoryProvider).clearAll();
                    },
                    child: ListTile(
                      title: Text(title.toString()),
                      subtitle: Text('${city ?? ''} • ${when.toLocal()}'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {
                        // TODO: relaunch search with stored context
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Recherche relancée')),
                        );
                      },
                    ),
                  );
                },
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemCount: items.length,
              );
            },
          );
        },
      ),
    );
  }
}
