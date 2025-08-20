// lib/features/favorites/presentation/templates/favorites_template.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../application/favorites_sections_provider.dart';
import '../organisms/favorites_list_sectioned.dart';
import '../widgets/favorites_header.dart';
import 'package:travel_in_perigord_app/core/theme/app_dimensions.dart';
import 'package:travel_in_perigord_app/routes/route_names.dart';

class FavoritesTemplate extends ConsumerWidget {
  const FavoritesTemplate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sectionsAsync = ref.watch(favoritesSectionsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Favoris'),
        // ✅ Pas de back en mode onglet/HomeShell
        automaticallyImplyLeading: false,
        elevation: 0,
      ),
      body: ListView(
        padding: AppDimensions.pagePaddingSmall,
        children: [
          const FavoritesHeader(),
          const SizedBox(height: 12),
          sectionsAsync.when(
            data: (sections) {
              if (sections.isEmpty) {
                return const _FavoritesEmptyState();
              }
              return FavoritesListSectioned(sections: sections);
            },
            loading: () => const _FavoritesLoading(),
            error: (e, _) => _FavoritesError(message: e.toString()),
          ),
        ],
      ),
    );
  }
}

class _FavoritesLoading extends StatelessWidget {
  const _FavoritesLoading();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
        6,
        (index) => Container(
          margin: const EdgeInsets.only(bottom: 12),
          height: 200,
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.04),
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}

class _FavoritesEmptyState extends StatelessWidget {
  const _FavoritesEmptyState();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Column(
        children: [
          const Icon(Icons.favorite_border, size: 48, color: Colors.grey),
          const SizedBox(height: 12),
          Text(
            'Aucun favori pour le moment.',
            style: Theme.of(context).textTheme.titleMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Ajoutez des activités ou événements à vos favoris pour les retrouver ici.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          OutlinedButton.icon(
            onPressed: () => Navigator.of(context).pushNamed(RouteNames.termsSearch),
            icon: const Icon(Icons.explore),
            label: const Text('Explorer'),
          ),
        ],
      ),
    );
  }
}

class _FavoritesError extends StatelessWidget {
  final String message;
  const _FavoritesError({required this.message});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.errorContainer,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Icon(Icons.error_outline, color: Theme.of(context).colorScheme.onErrorContainer),
            const SizedBox(width: 12),
            Expanded(
              child: Text('Erreur: $message', style: TextStyle(color: Theme.of(context).colorScheme.onErrorContainer)),
            ),
          ],
        ),
      ),
    );
  }
}
