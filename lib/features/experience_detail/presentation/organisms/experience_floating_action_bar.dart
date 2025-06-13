// lib/features/experience_detail/presentation/organisms/experience_floating_action_bar.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/components/molecules/bottom_bar_wrapper.dart';
import '../../../../core/domain/models/shared/experience_item.dart';
import '../molecules/experience_actions_row.dart';
import '../../application/providers/experience_detail_providers.dart';

class ExperienceFloatingActionBar extends ConsumerWidget {
  final ExperienceItem experienceItem;

  const ExperienceFloatingActionBar({
    Key? key,
    required this.experienceItem,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detailState = ref.watch(experienceDetailProvider(experienceItem));

    detailState.when(
      initial: () => print('  state: INITIAL'),
      loading: () => print('  state: LOADING'),
      error: (msg) => print('  state: ERROR - $msg'),
      loaded: (details) => print('  state: LOADED - ${details != null}'),
    );

    return BottomBarWrapper(
      // ✅ CORRECTION : Pas de skeleton si on a des données ExperienceItem
      isLoading: false, // Toujours false car ExperienceActionsRow gère le fallback
      content: detailState.when(
        initial: () => _buildUnifiedActions(null),
        loading: () => _buildUnifiedActions(null),
        error: (message) => _buildErrorState(message),
        loaded: (details) => _buildUnifiedActions(details),
      ),
    );
  }

  /// ✅ NOUVEAU : Actions unifiées Activities + Events
  Widget _buildUnifiedActions(details) {
    print('🎯 Building UNIFIED ACTIONS for ${experienceItem.isEvent ? 'Event' : 'Activity'}');

    return ExperienceActionsRow(
      experienceItem: experienceItem,
      details: details, // ✅ Null si initial/loading, ExperienceDetails si loaded
    );
  }

  /// ✅ State erreur avec retry
  Widget _buildErrorState([String? message]) {
    print('🎯 Building ERROR state: $message');

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.error_outline, color: Colors.red, size: 24),
          SizedBox(height: 8),
          Text('Impossible de charger les actions'),
          if (message != null) ...[
            SizedBox(height: 4),
            Text(
              message,
              style: TextStyle(fontSize: 12, color: Colors.grey),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
          SizedBox(height: 12),
          ElevatedButton(
            onPressed: () => _retryLoading(),
            child: Text('Réessayer'),
          ),
        ],
      ),
    );
  }

  void _retryLoading() {
    // TODO: Implémenter retry logic si nécessaire
    print('🔄 Retry loading for: ${experienceItem.id}');
  }
}