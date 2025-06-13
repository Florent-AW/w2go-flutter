// lib/features/shared_ui/presentation/widgets/index.dart

/// Fichier d'exportation pour faciliter l'import des widgets partagés
///
/// Permet d'importer tous les widgets ou une catégorie spécifique en une seule ligne:
/// ```dart
/// import 'package:lyra/shared/widgets/index.dart'; // Tout importer
/// // ou
/// import 'package:lyra/shared/widgets/atoms.dart'; // Importer seulement les atomes
/// ```

// Exportation par catégorie
export 'atoms.dart';
export 'molecules.dart';
export 'organisms.dart';
export 'templates.dart';

// Exportation directe des widgets individuels pour simplifier l'accès
// Atomes
export '../../../../core/theme/components/atoms/app_button.dart';
export '../../../../core/theme/components/atoms/app_text.dart';
export '../../../../core/theme/components/molecules/city_selector.dart';
export '../../../../core/theme/components/molecules/location_button.dart';
export '../../../../core/theme/components/atoms/drag_indicator.dart';
export '../../../../core/theme/animations/ripple_animation.dart';
export '../../../../core/theme/components/molecules/search_input.dart';


// Molécules
export 'molecules/filter_chip.dart';

// Organismes
export '../../../../features/welcome/presentation/widgets/organisms/welcome_form.dart';

// Templates