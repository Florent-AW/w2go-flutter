// lib/features/welcome/presentation/widgets/organisms/welcome_form.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/theme/app_dimensions.dart';
import '../../../../../core/theme/components/atoms/app_button.dart';
import '../../../../../core/theme/components/atoms/selection_button.dart';
import '../../../../../core/domain/models/shared/city_model.dart';
import '../../../../search/application/state/place_details_notifier.dart';
import '../../../../search/application/state/city_selection_state.dart';
import '../../../../shared_ui/presentation/pages/city_picker_page.dart';

class WelcomeForm extends ConsumerWidget {
  final VoidCallback onSubmit;
  final bool isLoading;

  const WelcomeForm({
    Key? key,
    required this.onSubmit,
    this.isLoading = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Utiliser des selectors pour éviter les rebuilds inutiles
    final selectedCity = ref.watch(selectedCityProvider);
    final hasCity = selectedCity != null;
    final cityName = selectedCity?.cityName ?? 'Sélectionnez une ville';

    return Container(
      width: double.infinity,
      padding: AppDimensions.paddingM,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Utiliser notre composant atomique SelectionButton
          SelectionButton(
            text: cityName,
            isSelected: hasCity,
            leadingIcon: Icons.location_on_outlined,
            onTap: () => _openCityPicker(context, ref),
          ),
        ],
      ),
    );
  }

  // Extraire la logique d'ouverture du picker en méthode privée
// Dans WelcomeForm
  Future<void> _openCityPicker(BuildContext context, WidgetRef ref) async {
    // Réinitialiser l'état du détail de lieu
    ref.read(placeDetailsNotifierProvider.notifier).reset();

    // Ouvrir la page en plein écran avec dialog style
    final city = await Navigator.of(context).push(
        MaterialPageRoute(
          fullscreenDialog: true,
          builder: (context) => const CityPickerPage(),
        )
    );

    // Vérifier si une ville a été sélectionnée
    if (city != null && city is City) {
      // Mettre à jour le provider
      ref.read(selectedCityProvider.notifier).selectCity(city);

      // Navigation vers CategoryPage
      Navigator.of(context).pushReplacementNamed('/category');
    }
  }
}