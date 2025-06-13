// lib/features/shared_ui/presentation/widgets/location/location_search_bar.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../atoms.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_dimensions.dart';
import '../../../../../core/theme/app_typography.dart';
import '../../../../search/application/state/place_search_notifier.dart';
import '../../../../search/application/state/place_search_state.dart';
import '../../../../search/application/services/city_selection_service.dart';
import 'location_suggestions_list.dart';

/// Barre de recherche de localisation avec suggestions
///
/// Composant moléculaire qui combine un champ de recherche et une liste de suggestions
class LocationSearchBar extends ConsumerStatefulWidget {
  final String? initialQuery;
  final Function(BuildContext)? onLocationButtonPressed;
  final Function(String)? onSubmitted;

  const LocationSearchBar({
    Key? key,
    this.initialQuery,
    this.onLocationButtonPressed,
    this.onSubmitted,
  }) : super(key: key);

  @override
  ConsumerState<LocationSearchBar> createState() => _LocationSearchBarState();
}

class _LocationSearchBarState extends ConsumerState<LocationSearchBar> {
  late TextEditingController _textController;
  final FocusNode _focusNode = FocusNode();
  bool _showSuggestions = false;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(text: widget.initialQuery);

    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        setState(() {
          _showSuggestions = true;
        });

        // Déclenche la recherche si un texte est déjà présent
        if (_textController.text.isNotEmpty) {
          ref.read(placeSearchNotifierProvider.notifier)
              .searchLocation(_textController.text);
        }
      }
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Utilisation du composant atomique SearchInput
        SearchInput(
          controller: _textController,
          focusNode: _focusNode,
          hintText: 'Rechercher une ville',
          showClearButton: _textController.text.isNotEmpty,
          onClearPressed: () {
            _textController.clear();
            ref.read(placeSearchNotifierProvider.notifier).reset();
          },
          onChanged: (value) {
            ref.read(placeSearchNotifierProvider.notifier)
                .searchLocation(value);
          },
          onSubmitted: (value) {
            if (widget.onSubmitted != null && value.isNotEmpty) {
              // Trouver l'ID de lieu à partir de l'état
              final searchState = ref.read(placeSearchNotifierProvider);
              searchState.whenOrNull(
                loaded: (suggestions) {
                  if (suggestions.isNotEmpty) {
                    widget.onSubmitted!(suggestions.first.placeId);
                  }
                },
              );
            }
          },
        ),

        // Espace entre le champ et les suggestions
        SizedBox(height: AppDimensions.space2),

        // Liste des suggestions
        if (_showSuggestions)
          LocationSuggestionsList(
            onSuggestionSelected: (suggestion) async {
              _textController.text = suggestion.primaryText;
              setState(() {
                _showSuggestions = false;
              });
              _focusNode.unfocus();

              // Utiliser le service de sélection de ville
              final cityService = ref.read(citySelectionServiceProvider);
              final success = await cityService.selectCityByPlaceId(suggestion.placeId);

              if (success && widget.onSubmitted != null) {
                widget.onSubmitted!(suggestion.placeId);
              }
            },
            onOutsideTap: () {
              setState(() {
                _showSuggestions = false;
              });
              _focusNode.unfocus();
            },
          ),
      ],
    );
  }
}