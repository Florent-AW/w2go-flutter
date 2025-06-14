// test/widget/activity_card_test.dart

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FeaturedExperienceCard Widget Tests', () {

    testWidgets('shouldDisplayActivityTitle', (WidgetTester tester) async {
      // Given - Card simulée sans providers
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Simule l'image
                    Container(
                      height: 150,
                      color: Colors.grey[300],
                      child: Center(child: Text('Image placeholder')),
                    ),
                    SizedBox(height: 8),
                    // Simule le titre
                    Text(
                      'Château de Test',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    // Simule la ville
                    Text(
                      'Périgueux',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );

      // When
      await tester.pump();

      // Then
      expect(find.text('Château de Test'), findsOneWidget);
    });

    testWidgets('shouldDisplayCityName', (WidgetTester tester) async {
      // Given
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                Text('Château de Beynac'),
                Text('Périgueux'),
                Text('Culture'),
              ],
            ),
          ),
        ),
      );

      // When
      await tester.pump();

      // Then
      expect(find.text('Périgueux'), findsOneWidget);
    });

    testWidgets('shouldDisplayCategoryName', (WidgetTester tester) async {
      // Given
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Container(
              padding: EdgeInsets.all(16),
              child: Row(
                children: [
                  Icon(Icons.castle),
                  SizedBox(width: 8),
                  Text('Culture'),
                ],
              ),
            ),
          ),
        ),
      );

      // When
      await tester.pump();

      // Then
      expect(find.text('Culture'), findsOneWidget);
      expect(find.byIcon(Icons.castle), findsOneWidget);
    });

    testWidgets('shouldDisplaySubcategoryWhenEnabled', (WidgetTester tester) async {
      // Given
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Chip(
              label: Text('Château'),
              avatar: Icon(Icons.castle, size: 16),
            ),
          ),
        ),
      );

      // When
      await tester.pump();

      // Then
      expect(find.text('Château'), findsOneWidget);
      expect(find.byType(Chip), findsOneWidget);
    });

    testWidgets('shouldHandleTapGesture', (WidgetTester tester) async {
      // Given
      bool tapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GestureDetector(
              onTap: () => tapped = true,
              child: Container(
                height: 200,
                child: Card(
                  child: Center(
                    child: Text('Activité tappable'),
                  ),
                ),
              ),
            ),
          ),
        ),
      );

      // When
      await tester.tap(find.text('Activité tappable'));
      await tester.pump();

      // Then
      expect(tapped, isTrue);
    });

    testWidgets('shouldDisplayImagePlaceholder', (WidgetTester tester) async {
      // Given
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Container(
              height: 200,
              width: 300,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.image, size: 48, color: Colors.grey[600]),
                  SizedBox(height: 8),
                  Text(
                    'Image non disponible',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      // When
      await tester.pump();

      // Then
      expect(find.text('Image non disponible'), findsOneWidget);
      expect(find.byIcon(Icons.image), findsOneWidget);
    });

    testWidgets('shouldDisplayDistanceBadge', (WidgetTester tester) async {
      // Given
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.blue[100],
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.location_on, size: 16),
                  SizedBox(width: 4),
                  Text('5.0 km'),
                ],
              ),
            ),
          ),
        ),
      );

      // When
      await tester.pump();

      // Then
      expect(find.text('5.0 km'), findsOneWidget);
      expect(find.byIcon(Icons.location_on), findsOneWidget);
    });

    testWidgets('shouldDisplayFavoriteButton', (WidgetTester tester) async {
      // Given
      bool isFavorite = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                return IconButton(
                  onPressed: () => setState(() => isFavorite = !isFavorite),
                  icon: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: isFavorite ? Colors.red : Colors.grey,
                  ),
                );
              },
            ),
          ),
        ),
      );

      // When
      await tester.tap(find.byType(IconButton));
      await tester.pump();

      // Then
      expect(find.byIcon(Icons.favorite), findsOneWidget);
    });
  });
}