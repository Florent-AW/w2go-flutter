// lib/features/shared_ui/presentation/widgets/organisms/city_picker_modal.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_dimensions.dart';
import '../../../../../core/domain/models/shared/city_model.dart';
import '../../../../../core/common/utils/geohash.dart';
import '../../../../search/application/state/city_search_provider.dart';
import '../../../../search/application/state/city_selection_state.dart';
import '../../../../search/application/state/place_details_notifier.dart';
import '../location/location_search_bar.dart';
import '../atoms.dart';

class CityPickerModal extends ConsumerStatefulWidget {
  const CityPickerModal({Key? key}) : super(key: key);

  @override
  ConsumerState<CityPickerModal> createState() => _CityPickerModalState();
}

class _CityPickerModalState extends ConsumerState<CityPickerModal> {
  final searchController = TextEditingController();

  @override
  void dispose() {
    // Simplement libérer les ressources, pas besoin de préserver l'état ici
    // car la ville est déjà placée dans la méthode 'loaded'
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    print('------------- DANS LE MODAL -------------');
    print('Current Navigator canPop: ${Navigator.of(context).canPop()}');
    print('Root Navigator canPop: ${Navigator.of(context, rootNavigator: true).canPop()}');
    print('Current == Root: ${identical(Navigator.of(context), Navigator.of(context, rootNavigator: true))}');

    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? AppColors.neutral900
            : AppColors.neutral50,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppDimensions.radiusL),
        ),
      ),
      child: Column(
        children: [
          // Drag indicator
          SizedBox(height: AppDimensions.space2),
          DragIndicator(),
          SizedBox(height: AppDimensions.space4),

          // Search bar
          Padding(
            padding: AppDimensions.paddingHorizontalM,
            child: Row(
              children: [
                IconButton(
                  icon: Icon(LucideIcons.arrowLeft,
                    color: AppColors.primary,
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
                Expanded(
                  child: LocationSearchBar(
                    initialQuery: searchController.text,
                    onLocationButtonPressed: (_) {
                      ref.read(placeDetailsNotifierProvider.notifier)
                          .getCurrentLocation();
                    },
                    onSubmitted: (placeId) {
                      ref.read(placeDetailsNotifierProvider.notifier)
                          .getLocationDetails(placeId);
                    },
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: AppDimensions.space5),

          // Location details state handling
          Expanded(
            child: Consumer(
              builder: (context, ref, child) {
                final placeDetailsState = ref.watch(placeDetailsNotifierProvider);

                return placeDetailsState.when(
                  initial: () => _buildSearchResults(),

                  loading: () => Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircularProgressIndicator(
                          color: AppColors.primary,
                        ),
                        SizedBox(height: AppDimensions.space4),
                        AppText.body('Chargement des détails...'),
                      ],
                    ),
                  ),

                  loaded: (details) {
                    // La logique existante reste inchangée...
                    final String geohash5 = Geohash.encode(
                        details.location.latitude,
                        details.location.longitude
                    );

                    final city = City(
                      id: details.placeId,
                      cityName: details.name,
                      lat: details.location.latitude,
                      lon: details.location.longitude,
                      geohash5: geohash5,
                      createdAt: DateTime.now(),
                      updatedAt: DateTime.now(),
                    );

                    // Logs inchangés...

                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      ref.read(selectedCityProvider.notifier).state = city;
                      Navigator.of(context, rootNavigator: true).pop();
                    });

                    return const SizedBox.shrink();
                  },

                  error: (message) => Column(
                    children: [
                      // Message d'erreur avec style amélioré
                      Padding(
                        padding: AppDimensions.paddingM,
                        child: Container(
                          padding: AppDimensions.paddingM,
                          decoration: BoxDecoration(
                            color: AppColors.errorLight.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                            border: Border.all(color: AppColors.error.withOpacity(0.3)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.error_outline, color: AppColors.error),
                                  SizedBox(width: AppDimensions.space3),
                                  Expanded(
                                    child: AppText.title(
                                      'Erreur de recherche',
                                      color: AppColors.error,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: AppDimensions.space2),
                              AppText.body(
                                message,
                                color: AppColors.error,
                              ),
                              SizedBox(height: AppDimensions.space2),
                              AppText.body(
                                'Veuillez réessayer ou choisir une autre ville.',
                                color: AppColors.error,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(child: _buildSearchResults()),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResults() {
    final query = searchController.text;
    if (query.isEmpty) {
      return Padding(
        padding: AppDimensions.paddingHorizontalM,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Nouveau bouton de localisation simplifié
            LocationButton(
              onTap: () {
                ref.read(placeDetailsNotifierProvider.notifier)
                    .getCurrentLocation();
              },
            ),
          ],
        ),
      );
    }

    final citiesAsync = ref.watch(citiesSearchResultsProvider(query));

    return citiesAsync.when(
      data: (cities) => ListView.builder(
        padding: AppDimensions.paddingHorizontalM,
        itemCount: cities.take(10).length,
        itemBuilder: (context, index) {
          final city = cities[index];
          return Container(
            margin: EdgeInsets.only(bottom: AppDimensions.space2),
            decoration: BoxDecoration(
              color: Theme.of(context).brightness == Brightness.dark
                  ? AppColors.neutral800
                  : AppColors.neutral100,
              borderRadius: BorderRadius.circular(AppDimensions.radiusM),
            ),
            child: ListTile(
              title: AppText.body(
                city.cityName,
              ),
              onTap: () {
                ref.read(selectedCityProvider.notifier).state = city;
                Navigator.of(context, rootNavigator: true).pop();
              },
            ),
          );
        },
      ),
      loading: () => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              color: AppColors.primary,
            ),
            SizedBox(height: AppDimensions.space2),
            AppText.body('Recherche en cours...'),
          ],
        ),
      ),
      error: (_, __) => const SizedBox.shrink(),
    );
  }
}