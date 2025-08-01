// lib/features/preload/application/preload_controller.dart

// ✅ NOUVEAU SYSTÈME : AllDataPreloader
// Voir: lib/core/application/all_data_preloader.dart
//
// Avantages du nouveau système :
// - Un seul point de preload (pas de T0/T1/T2 complexe)
// - Trigger universel sur changement de ville
// - Pas de race conditions avec PaginationController
// - Architecture plus simple et maintenable