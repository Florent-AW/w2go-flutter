// lib/core/theme/components/organisms/city_picker_content.dart

import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../app_dimensions.dart';
import '../../app_colors.dart';
import '../../app_typography.dart';
import '../molecules/search_header.dart';
import '../molecules/recent_cities_list.dart';
import '../molecules/suggested_cities_list.dart';
import '../molecules/search_results_list.dart';
import '../../../domain/models/search/recent_city.dart';
import '../../../domain/models/shared/city_model.dart';
import '../../../../features/search/application/state/place_search_notifier.dart';
import '../../../../features/search/application/state/place_details_notifier.dart';
import '../../../../features/search/application/state/place_details_state.dart';
import '../../../domain/models/location/place_suggestion.dart';
import '../../../common/utils/geohash.dart';
import '../atoms/city_list_item.dart';

/// État global de l'interface de sélection de ville
enum CityPickerViewState {
  /// Affichage initial avec historique et suggestions
  initial,

  /// Mode recherche avec résultats
  searching,
}

/// Organisme principal pour l'interface de sélection de ville
/// Combine plusieurs molécules pour former une expérience complète
class CityPickerContent extends ConsumerStatefulWidget {
  /// Callback quand une ville est sélectionnée
  final void Function(City) onCitySelected;

  /// Callback pour le bouton retour
  final VoidCallback onBackPressed;

  /// Liste des recherches récentes
  final List<RecentCity> recentCities;

  /// Liste des villes suggérées
  final List<City> suggestedCities;

  /// État initial des résultats de recherche
  final SearchResultsState initialResultsState;

  /// Ville actuellement sélectionnée
  final City? selectedCity;

  /// Callback pour effectuer une recherche
  final Future<List<City>> Function(String) onSearch;


  const CityPickerContent({
    Key? key,
    required this.onCitySelected,
    required this.onBackPressed,
    required this.recentCities,
    required this.suggestedCities,
    required this.onSearch,
    this.initialResultsState = SearchResultsState.initial,
    this.selectedCity,
  }) : super(key: key);

  @override
  ConsumerState<CityPickerContent> createState() => _CityPickerContentState();
}

class _CityPickerContentState extends ConsumerState<CityPickerContent> {
  final TextEditingController _searchController = TextEditingController();
  CityPickerViewState _viewState = CityPickerViewState.initial;
  SearchResultsState _resultsState = SearchResultsState.initial;
  List<City> _searchResults = [];
  String _searchQuery = '';
  String? _errorMessage;

  Timer? _debounceTimer;
  static const int _minSearchLength = 2;
  static const Duration _debounceDuration = Duration(milliseconds: 300);

  var combinedResults;

  @override
  void initState() {
    super.initState();
    _resultsState = widget.initialResultsState;

    // Écouter les changements dans le champ de recherche
    _searchController.addListener(_handleSearchChanged);
  }


  /// Gère le changement de texte dans la recherche
  void _handleSearchChanged() {
    final query = _searchController.text.trim();

    setState(() {
      // Si vide, revenir à l'affichage initial
      if (query.isEmpty) {
        _viewState = CityPickerViewState.initial;
        _resultsState = SearchResultsState.initial;
        _searchResults = [];
        _searchQuery = '';
      } else if (_searchQuery != query) {
        // Sinon, passer en mode recherche
        _viewState = CityPickerViewState.searching;

        // Déclencher la recherche automatique après 3 caractères
        if (query.length >= _minSearchLength) {
          // Annuler le timer précédent s'il existe
          _debounceTimer?.cancel();

          // Créer un nouveau timer de debounce
          _debounceTimer = Timer(_debounceDuration, () {
            _executeSearch();
          });
        }
      }
    });

    // Stocker la dernière requête
    _searchQuery = query;
  }
  @override
  void dispose() {
    _debounceTimer?.cancel();
    _searchController.removeListener(_handleSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  /// Exécute la recherche après un délai de saisie
  Future<void> _executeSearch() async {
    if (_searchQuery.isEmpty) return;

    setState(() {
      _resultsState = SearchResultsState.loading;
    });

    try {
      // Recherche uniquement dans la base de données locale
      final results = await widget.onSearch(_searchQuery);

      setState(() {
        _searchResults = results;
        _resultsState = results.isEmpty
            ? SearchResultsState.empty
            : SearchResultsState.results;
      });
    } catch (error) {
      setState(() {
        _resultsState = SearchResultsState.error;
        _errorMessage = error.toString();
        _searchResults = [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // En-tête avec barre de recherche
        SearchHeader(
          controller: _searchController,
          onBackPressed: widget.onBackPressed,
          onQueryChanged: (query) {
          },
          onSubmitted: (query) {
            if (query.isNotEmpty) {
              _executeSearch();
            }
          },
        ),

        // Contenu principal (scrollable)
        Expanded(
          child: SingleChildScrollView(
            child: _viewState == CityPickerViewState.initial
                ? _buildInitialContent()
                : _buildSearchResults(),
          ),
        ),
      ],
    );
  }

  /// Construit l'affichage initial avec historique et suggestions
  Widget _buildInitialContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Recherches récentes
        RecentCitiesList(
          recentCities: widget.recentCities,
          onCitySelected: widget.onCitySelected,
          selectedCity: widget.selectedCity,
        ),

        // Villes suggérées
        SuggestedCitiesList(
          suggestedCities: widget.suggestedCities,
          onCitySelected: widget.onCitySelected,
          selectedCity: widget.selectedCity,
        ),
      ],
    );
  }

  /// Construit l'affichage des résultats de recherche
  Widget _buildSearchResults() {
    // Si pas de recherche ou recherche trop courte
    if (_searchQuery.isEmpty || _searchQuery.length < 2) {
      return const SizedBox.shrink();
    }

    // Si erreur, afficher message
    if (_resultsState == SearchResultsState.error) {
      return Padding(
        padding: EdgeInsets.all(AppDimensions.space4),
        child: Text(
          'Erreur: $_errorMessage',
          style: AppTypography.body(
            isDark: Theme.of(context).brightness == Brightness.dark,
          ),
        ),
      );
    }

    // Afficher loading si aucun résultat n'est encore disponible
    if (_resultsState == SearchResultsState.loading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    // Si aucun résultat
    if (_searchResults.isEmpty) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(AppDimensions.space6),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.search_off,
                size: 48,
                color: Theme.of(context).brightness == Brightness.dark
                    ? AppColors.neutral500
                    : AppColors.neutral400,
              ),
              SizedBox(height: AppDimensions.space4),
              Text(
                'Aucune ville trouvée pour "$_searchQuery"',
                style: AppTypography.body(
                  isDark: Theme.of(context).brightness == Brightness.dark,
                  isSecondary: true,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    // Afficher résultats
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.all(AppDimensions.space4),
      itemCount: _searchResults.length,
      itemBuilder: (context, index) {
        final city = _searchResults[index];
        final isSelected = widget.selectedCity?.id == city.id;

        // Formater le texte secondaire: Code postal + Département
        String? secondaryText;
        if (city.postalCode != null && city.department != null) {
          secondaryText = "${city.postalCode} - ${city.department}";
        } else if (city.postalCode != null) {
          secondaryText = city.postalCode;
        } else if (city.department != null) {
          secondaryText = city.department;
        }

        return Padding(
          padding: EdgeInsets.only(bottom: AppDimensions.space3),
          child: CityListItem(
            city: city,
            isSelected: isSelected,
            secondaryText: secondaryText,
            onTap: () => widget.onCitySelected(city),
          ),
        );
      },
    );
  }


}
