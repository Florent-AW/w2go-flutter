import 'package:freezed_annotation/freezed_annotation.dart';

part 'paginated_result.freezed.dart';

/// Résultat paginé générique pour tous les types de données
@freezed
class PaginatedResult<T> with _$PaginatedResult<T> {
  const factory PaginatedResult({
    /// Items de la page courante
    required List<T> items,
    /// Y a-t-il plus d'items à charger ?
    required bool hasMore,
    /// Nombre total d'items disponibles (optionnel)
    int? totalCount,
    /// Offset de la prochaine page
    required int nextOffset,
  }) = _PaginatedResult<T>;

  const PaginatedResult._();

  /// Combine deux résultats paginés (pour append)
  PaginatedResult<T> appendPage(PaginatedResult<T> newPage) {
    return copyWith(
      items: [...items, ...newPage.items],
      hasMore: newPage.hasMore,
      nextOffset: newPage.nextOffset,
      totalCount: newPage.totalCount ?? totalCount,
    );
  }
}