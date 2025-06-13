// lib/features/shared_ui/presentation/widgets/location/location_suggestions_list.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/domain/models/location/place_suggestion.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_typography.dart';
import '../../../../search/application/state/place_search_notifier.dart';
import '../../../../search/application/state/place_search_state.dart';

class LocationSuggestionsList extends ConsumerWidget {
  final Function(PlaceSuggestion) onSuggestionSelected;
  final VoidCallback onOutsideTap;

  const LocationSuggestionsList({
    Key? key,
    required this.onSuggestionSelected,
    required this.onOutsideTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchState = ref.watch(placeSearchNotifierProvider);

    return Stack(
      children: [
        // Zone de tap pour fermer les suggestions
        Positioned.fill(
          child: GestureDetector(
            onTap: onOutsideTap,
            behavior: HitTestBehavior.opaque,
            child: Container(color: Colors.transparent),
          ),
        ),

        // Liste des suggestions
        Container(
          margin: const EdgeInsets.only(top: 4),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Material(
              color: Colors.transparent,
              child: searchState.when(
                initial: () => const SizedBox.shrink(),
                loading: () => const Center(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: CircularProgressIndicator(),
                  ),
                ),
                loaded: (suggestions) => ListView.separated(
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  itemCount: suggestions.length,
                  physics: const ClampingScrollPhysics(),
                  separatorBuilder: (context, index) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final suggestion = suggestions[index];

                    return InkWell(
                      onTap: () => onSuggestionSelected(suggestion),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        child: Row(
                          children: [
                            Icon(
                              suggestion.isFromCache
                                  ? Icons.history
                                  : Icons.location_on_outlined,
                              size: 20,
                              color: AppColors.accent,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    suggestion.primaryText,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  if (suggestion.secondaryText != null)
                                    Text(
                                      suggestion.secondaryText!,
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: 13,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                noResults: () => Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.search_off, color: Colors.grey[400]),
                        const SizedBox(height: 8),
                        Text(
                          'Aucun résultat trouvé',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ),
                ),
                error: (message) => Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.error_outline, color: Colors.red[400]),
                        const SizedBox(height: 8),
                        Text(
                          'Erreur: $message',
                          style: TextStyle(color: Colors.red[600]),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}