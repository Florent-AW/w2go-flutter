// lib/core/domain/ports/empty_trips/neighbor_geohashes.port.dart

abstract class NeighborGeohashesPort {
  Future<void> generateAndSaveNeighbors({
    required String emptyTripId,
    required List<String> traversedGeohashes,
  });

  Future<Map<String, Map<String, dynamic>>> getNeighborGeohashes(String emptyTripId);
}