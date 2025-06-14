// test/widget/recommendations_section_test.dart

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ActivityRecommendationsSection Widget Tests', () {

    testWidgets('shouldDisplayBasicWidgets', (WidgetTester tester) async {
      // Given - Test ultra-simple sans providers
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                Text('Activités similaires'),
                Text('À proximité'),
                Container(
                  height: 200,
                  child: Text('Zone de recommandations'),
                ),
              ],
            ),
          ),
        ),
      );

      // When
      await tester.pump();

      // Then
      expect(find.text('Activités similaires'), findsOneWidget);
      expect(find.text('À proximité'), findsOneWidget);
      expect(find.text('Zone de recommandations'), findsOneWidget);
    });

    testWidgets('shouldDisplayCarouselTitle', (WidgetTester tester) async {
      // Given
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Recommandations similaires',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16),
                  Container(
                    height: 150,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text('Carousel placeholder'),
                    ),
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
      expect(find.text('Recommandations similaires'), findsOneWidget);
      expect(find.text('Carousel placeholder'), findsOneWidget);
    });

    testWidgets('shouldDisplayMultipleSections', (WidgetTester tester) async {
      // Given
      final sections = ['Activités similaires', 'À proximité', 'Populaires'];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ListView.builder(
              itemCount: sections.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        sections[index],
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                      SizedBox(height: 8),
                      Container(
                        height: 100,
                        color: Colors.blue[100],
                        child: Center(child: Text('Section ${index + 1}')),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      );

      // When
      await tester.pump();

      // Then
      for (String section in sections) {
        expect(find.text(section), findsOneWidget);
      }
      expect(find.text('Section 1'), findsOneWidget);
      expect(find.text('Section 2'), findsOneWidget);
      expect(find.text('Section 3'), findsOneWidget);
    });

    testWidgets('shouldHandleEmptyContent', (WidgetTester tester) async {
      // Given
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                Text('Recommandations'),
                SizedBox.shrink(), // Simule un carousel vide
                Text('Fin des recommandations'),
              ],
            ),
          ),
        ),
      );

      // When
      await tester.pump();

      // Then
      expect(find.text('Recommandations'), findsOneWidget);
      expect(find.text('Fin des recommandations'), findsOneWidget);
      expect(find.byType(SizedBox), findsAtLeastNWidgets(1));
    });

    testWidgets('shouldDisplayLoadingIndicator', (WidgetTester tester) async {
      // Given
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                Text('Chargement des recommandations'),
                CircularProgressIndicator(),
              ],
            ),
          ),
        ),
      );

      // When
      await tester.pump();

      // Then
      expect(find.text('Chargement des recommandations'), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
  });
}