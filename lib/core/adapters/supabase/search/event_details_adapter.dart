// lib/core/adapters/supabase/search/event_details_adapter.dart

import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../domain/models/event/details/event_details_model.dart';
import '../../../domain/models/shared/event_image_model.dart';
import '../../../domain/ports/search/event_details_port.dart';

class EventDetailsAdapter implements EventDetailsPort {
  final SupabaseClient _client;

  EventDetailsAdapter(this._client);

  @override
  Future<EventDetails> getEventDetails(String eventId) async {
    try {
      print('🔍 EventDetailsAdapter: Fetching details for event: $eventId');

      final response = await _client
          .from('events')
          .select('''
          id,
          name,
          description,
          latitude,
          longitude,
          category_id,
          address,
          city,
          start_date,
          end_date,
          booking_required,
          has_multiple_occurrences,
          is_recurring,
          categories!inner(name),
          activity_subcategories!events_subcategory_id_fkey(name, icon),
          events_images!event_images_event_id_fkey(
            id,
            mobile_url,
            is_main
          )
        ''')
          .eq('id', eventId)
          .single();

      print('✅ EventDetailsAdapter: Response received');

      // Mapper les images
      List<EventImage> images = [];
      final rawImages = response['events_images'];
      if (rawImages != null) {
        images = (rawImages as List)
            .where((img) => img['mobile_url'] != null)
            .map((img) => EventImage(
          id: img['id'] ?? '',
          mobileUrl: img['mobile_url'] ?? '',
          isMain: img['is_main'] ?? false,
        ))
            .toList();

        // Trier pour mettre l'image principale en premier
        images.sort((a, b) {
          final aIsMain = a.isMain ?? false;
          final bIsMain = b.isMain ?? false;
          if (aIsMain && !bIsMain) return -1;
          if (!aIsMain && bIsMain) return 1;
          return 0;
        });
      }

      final details = EventDetails(
        id: response['id'] ?? '',
        name: response['name'] ?? '',
        description: response['description'],
        latitude: (response['latitude'] ?? 0.0).toDouble(),
        longitude: (response['longitude'] ?? 0.0).toDouble(),
        address: response['address'],
        city: response['city'],
        categoryId: response['category_id'] ?? '',
        categoryName: response['categories']?['name'],
        subcategoryName: response['activity_subcategories']?['name'],
        subcategoryIcon: response['activity_subcategories']?['icon'],
        startDate: DateTime.parse(response['start_date']),
        endDate: DateTime.parse(response['end_date']),
        bookingRequired: response['booking_required'] ?? false,
        hasMultipleOccurrences: response['has_multiple_occurrences'] ?? false,
        isRecurring: response['is_recurring'] ?? false,
        images: images,
      );

      print('✅ EventDetailsAdapter: EventDetails created successfully');
      return details;

    } catch (e, stack) {
      print('❌ EventDetailsAdapter ERROR: $e');
      throw Exception('Erreur lors de la récupération des détails d\'événement : $e');
    }
  }
}