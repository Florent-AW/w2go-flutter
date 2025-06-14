// test/unit/rating_utils_test.dart

import 'package:flutter_test/flutter_test.dart';

/// Fonction utilitaire pour calculer la moyenne des notes
double computeAverageRating(List<double> ratings) {
  if (ratings.isEmpty) return 0.0;
  final sum = ratings.reduce((a, b) => a + b);
  return sum / ratings.length;
}

/// Fonction pour formater l'affichage des notes
String formatRating(double rating) {
  if (rating == 0.0) return 'Non noté';
  return '${rating.toStringAsFixed(1)}/5';
}

void main() {
  group('Rating Utils Tests', () {
    test('shouldComputeAverageRatingCorrectly', () {
      // Given
      final ratings = [4.0, 5.0, 3.0, 4.5, 2.5];

      // When
      final average = computeAverageRating(ratings);

      // Then
      expect(average, equals(3.8));
    });

    test('shouldReturnZeroForEmptyRatingsList', () {
      // Given
      final ratings = <double>[];

      // When
      final average = computeAverageRating(ratings);

      // Then
      expect(average, equals(0.0));
    });

    test('shouldReturnSameValueForSingleRating', () {
      // Given
      final ratings = [4.2];

      // When
      final average = computeAverageRating(ratings);

      // Then
      expect(average, equals(4.2));
    });

    test('shouldFormatRatingDisplay', () {
      // Given & When & Then
      expect(formatRating(0.0), equals('Non noté'));
      expect(formatRating(4.0), equals('4.0/5'));
      expect(formatRating(4.75), equals('4.8/5'));
    });

    test('shouldHandlePerfectRating', () {
      // Given
      final ratings = [5.0, 5.0, 5.0];

      // When
      final average = computeAverageRating(ratings);

      // Then
      expect(average, equals(5.0));
    });
  });
}