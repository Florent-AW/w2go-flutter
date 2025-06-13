// lib/core/adapters/supabase/search/activity_details_adapter.dart

import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../domain/models/shared/activity_details_model.dart';
import '../../../domain/models/shared/activity_image_model.dart';
import '../../../domain/ports/search/activity_details_port.dart';

class ActivityDetailsAdapter implements ActivityDetailsPort {
  final SupabaseClient _client;

  ActivityDetailsAdapter(this._client);

  @override
  Future<ActivityDetails> getActivityDetails(String activityId) async {
    try {
      print('Fetching details for activity: $activityId');

      final response = await _client
          .from('activities')
          .select('''
  id,
  name,
  description,
  latitude,
  longitude,
  category_id,
  address,
  city,
  google_place_id,
  base_price,
  min_duration_minutes,
  max_duration_minutes,
  booking_level,
  wheelchair_accessible,
  kid_friendly,
  postal_code,
  contact_phone,
  contact_email,
  contact_website,
  current_opening_hours,
  price_level,
  categories!inner(name),
  activity_subcategories!activities_subcategory_id_fkey(name, icon),
  activities_images(
    id,
    mobile_url,
    is_main
  )
''')
          .eq('id', activityId)
          .single();


      // Mapper les images directement avec mobile_url
// Initialiser une liste vide par défaut
      List<ActivityImage> images = [];

// Vérifier si on a des images avant de traiter
      final rawImages = response['activities_images'];
      if (rawImages != null) {
        images = (rawImages as List)
            .where((img) => img['mobile_url'] != null)
            .map((img) => ActivityImage(
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


      final details = ActivityDetails.fromJson({
        'id': response['id'] ?? '',
        'name': response['name'] ?? '',
        'description': response['description'],
        'latitude': (response['latitude'] ?? 0.0).toDouble(),
        'longitude': (response['longitude'] ?? 0.0).toDouble(),
        'categoryId': response['category_id'] ?? '',
        'categoryName': response['categories']?['name'],
        'subcategoryName': response['activity_subcategories']?['name'],
        'subcategoryIcon': response['activity_subcategories']?['icon'],
        'postalCode': response['postal_code'],
        'address': response['address'],
        'city': response['city'],
        'googlePlaceId': response['google_place_id'],
        'currentOpeningHours': response['current_opening_hours'],
        'contactPhone': response['contact_phone'],
        'contactEmail': response['contact_email'],
        'contactWebsite': response['contact_website'],
        'bookingLevel': response['booking_level'],
        'kidFriendly': response['kid_friendly'],
        'wheelchairAccessible': response['wheelchair_accessible'],
        'minDurationMinutes': response['min_duration_minutes'],
        'maxDurationMinutes': response['max_duration_minutes'],
        'priceLevel': response['price_level'],
        'basePrice': response['base_price'],
        'images': images.map((img) => {
          'id': img.id,
          'mobileUrl': img.mobileUrl,
          'isMain': img.isMain,
        }).toList(),
      });

      return details;
    } catch (e, stack) {
      throw Exception('Erreur lors de la récupération des détails : $e');
    }
  }
}
