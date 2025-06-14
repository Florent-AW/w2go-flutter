// test/unit/activity_filter_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:travel_in_perigord_app/core/domain/models/activity/search/searchable_activity.dart';
import 'package:travel_in_perigord_app/core/domain/models/activity/base/activity_base.dart';
import 'package:travel_in_perigord_app/core/domain/models/search/activity_filter.dart';

void main() {
  group('ActivityFilter Tests', () {
    late List<SearchableActivity> testActivities;

    setUp(() {
      testActivities = [
        SearchableActivity(
          base: ActivityBase(
            id: '1',
            name: 'Château pas cher',
            description: 'Description test',
            latitude: 45.0,
            longitude: 1.0,
            categoryId: 'culture',
            city: 'Périgueux',
            bookingRequired: false,
          ),
          categoryName: 'Culture',
          subcategoryName: 'Château',
          subcategoryIcon: 'castle',
          distance: 5.0,
        ),
        SearchableActivity(
          base: ActivityBase(
            id: '2',
            name: 'Activité chère',
            description: 'Description test',
            latitude: 45.1,
            longitude: 1.1,
            categoryId: 'culture',
            city: 'Sarlat',
            bookingRequired: true,
          ),
          categoryName: 'Culture',
          subcategoryName: 'Musée',
          subcategoryIcon: 'museum',
          distance: 15.0,
        ),
        SearchableActivity(
          base: ActivityBase(
            id: '3',
            name: 'Gratuite',
            description: 'Description test',
            latitude: 45.2,
            longitude: 1.2,
            categoryId: 'nature',
            city: 'Bergerac',
            bookingRequired: false,
          ),
          categoryName: 'Nature',
          subcategoryName: 'Randonnée',
          subcategoryIcon: 'hiking',
          distance: 3.0,
        ),
      ];
    });


    test('shouldFilterActivitiesByCategory', () {
      // Given
      final targetCategory = 'culture';

      // When
      final filtered = testActivities.where((activity) =>
      activity.base.categoryId == targetCategory
      ).toList();

      // Then
      expect(filtered.length, equals(2));
      expect(filtered.every((a) => a.base.categoryId == 'culture'), isTrue);
    });

    test('shouldFilterActivitiesByDistance', () {
      // Given
      final maxDistance = 10.0;

      // When
      final filtered = testActivities.where((activity) =>
      (activity.distance ?? 0.0) <= maxDistance
      ).toList();

      // Then
      expect(filtered.length, equals(2));
      expect(filtered[0].base.name, equals('Château pas cher'));
      expect(filtered[1].base.name, equals('Gratuite'));
    });
  });
}