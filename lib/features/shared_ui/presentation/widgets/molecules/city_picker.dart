// lib/features/shared_ui/presentation/widgets/molecules/city_picker.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_dimensions.dart';
import '../../../../search/application/state/city_selection_state.dart';
import '../../../../search/application/state/place_details_notifier.dart';
import '../organisms/city_picker_modal.dart';

/// Sélecteur de ville réutilisable
/// Affiche la ville actuellement sélectionnée et permet d'ouvrir
/// une modal pour changer de ville
class CityPicker extends ConsumerWidget {
  /// Style visuel du texte
  final TextStyle? textStyle;

  /// Couleur de l'icône
  final Color iconColor;

  /// Taille de l'icône
  final double iconSize;

  const CityPicker({
    super.key,
    this.textStyle,
    this.iconColor = Colors.white,
    this.iconSize = 20,
  });

  void _showCityPicker(BuildContext context, WidgetRef ref) {
    // Réinitialiser l'état du détail de lieu avant d'ouvrir le modal
    ref.read(placeDetailsNotifierProvider.notifier).reset();

    // Ouvrir directement le modal
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const CityPickerModal(),
    );
  }

  String _formatCityName(String? cityName) {
    if (cityName == null) return 'Sélectionnez une ville';
    return cityName.length > 26 ? '${cityName.substring(0, 26)}...' : cityName;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final defaultTextStyle = Theme.of(context).textTheme.bodyMedium?.copyWith(
      color: Colors.white,
      shadows: [],
    );

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _showCityPicker(context, ref),
        borderRadius: BorderRadius.circular(AppDimensions.radiusS),
        splashColor: Colors.white.withOpacity(0.1),
        highlightColor: Colors.white.withOpacity(0.1),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppDimensions.spacingXxs,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                _formatCityName(ref.watch(selectedCityProvider)?.cityName),
                style: textStyle ?? defaultTextStyle,
              ),
              Icon(
                Icons.arrow_drop_down,
                color: iconColor,
                size: iconSize,
              ),
            ],
          ),
        ),
      ),
    );
  }
}