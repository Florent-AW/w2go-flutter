// lib/core/theme/components/molecules/search_header.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../app_dimensions.dart';
import '../atoms/search_bar_with_back.dart';
import '../../../../features/search/application/state/place_search_notifier.dart';

/// En-tête de recherche avec barre de recherche et navigation
class SearchHeader extends ConsumerStatefulWidget {
  /// Contrôleur pour le champ de recherche
  final TextEditingController controller;

  /// Callback quand le texte change
  final ValueChanged<String>? onQueryChanged;

  /// Callback quand la recherche est soumise
  final ValueChanged<String>? onSubmitted;

  /// Callback pour le bouton retour
  final VoidCallback onBackPressed;

  /// Text d'indication
  final String hintText;

  const SearchHeader({
    Key? key,
    required this.controller,
    required this.onBackPressed,
    this.onQueryChanged,
    this.onSubmitted,
    this.hintText = 'Rechercher une ville...',
  }) : super(key: key);

  @override
  ConsumerState<SearchHeader> createState() => _SearchHeaderState();
}

class _SearchHeaderState extends ConsumerState<SearchHeader> {
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    // Déclencher la recherche au focus si du texte est présent
    _focusNode.addListener(() {
      if (_focusNode.hasFocus && widget.controller.text.isNotEmpty) {
        // Déclencher la recherche Place
        ref.read(placeSearchNotifierProvider.notifier)
            .searchLocation(widget.controller.text);

        // Callback pour la recherche locale
        if (widget.onQueryChanged != null) {
          widget.onQueryChanged!(widget.controller.text);
        }
      }
    });

    // Listener pour les changements de texte
    widget.controller.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    final text = widget.controller.text;

    if (text.length >= 3) {
      // Déclencher les deux recherches en parallèle
      ref.read(placeSearchNotifierProvider.notifier).searchLocation(text);

      if (widget.onQueryChanged != null) {
        widget.onQueryChanged!(text);
      }
    } else if (text.isEmpty) {
      ref.read(placeSearchNotifierProvider.notifier).reset();

      if (widget.onQueryChanged != null) {
        widget.onQueryChanged!('');
      }
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onTextChanged);
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppDimensions.space4),
      child: SafeArea(
        bottom: false,
        child: SearchBarWithBack(
          controller: widget.controller,
          focusNode: _focusNode,
          onBackPressed: widget.onBackPressed,
          hintText: widget.hintText,
          onChanged: null, // Géré par le listener
          onSubmitted: widget.onSubmitted,
          backButtonLabel: 'Retourner à l\'écran précédent',
        ),
      ),
    );
  }
}