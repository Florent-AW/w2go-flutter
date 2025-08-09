// lib/features/shared_ui/presentation/widgets/molecules/city_picker.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_dimensions.dart';
import '../../../../../core/domain/models/shared/city_model.dart';
import '../../../../search/application/state/city_selection_state.dart';
import '../../../../search/application/state/place_details_notifier.dart';
import '../../../../preload/application/preload_providers.dart';
import '../../pages/city_picker_page.dart';

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

  /// Couleur du texte de la ville
  final Color? locationTextColor;

  /// Forcer le type de page cible ("city" ou "category")
  final String? targetPageType;


  const CityPicker({
    super.key,
    this.textStyle,
    this.iconColor = Colors.white,
    this.iconSize = 20,
    this.locationTextColor,
    this.targetPageType,
  });

  void _showCityPicker(BuildContext context, WidgetRef ref) async {
    // 1. reset éventuels de l’état « place details »
    ref.read(placeDetailsNotifierProvider.notifier).reset();

    // 2. ouvre la page de sélection
    final city = await Navigator.of(context).push(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (_) => const CityPickerPage(),
      ),
    );

    // 3. rien à faire si l’utilisateur annule
    if (city == null || city is! City) return;

    // 4. écrit la ville sélectionnée
    ref.read(selectedCityProvider.notifier).selectCity(city);

    // --- 🔥 NOUVEAU : prépare le preload AVANT la navigation ----------
    final preloadCtrl = ref.read(preloadControllerProvider.notifier);

    // a) purge + passe l’état à `loading`
    preloadCtrl.resetForCity(city);

    // b) relance le vrai preload (page « city » ou « category »)
    final pageType = targetPageType ?? 'city'; // 'city' par défaut
    preloadCtrl.startPreload(city, pageType);
    // ------------------------------------------------------------------

    // 5. navigation finale (remplacement de la route courante)
    if (pageType == 'city') {
      Navigator.of(context).pushReplacementNamed('/city');
    } else {
      Navigator.of(context).pushReplacementNamed('/category');
    }
  }

  String _formatCityName(String? cityName) {
    if (cityName == null) return 'Sélectionnez une ville';
    return cityName.length > 26 ? '${cityName.substring(0, 26)}...' : cityName;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final defaultTextStyle = Theme.of(context).textTheme.bodyMedium?.copyWith(
      color: locationTextColor ?? Colors.white, // ✅ Utiliser locationTextColor si fourni
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