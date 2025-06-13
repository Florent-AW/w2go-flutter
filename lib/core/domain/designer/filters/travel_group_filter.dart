// lib\core\domain\filters\travel_group_filter.dart

import '../../models/trip_designer/processing/activity_processing_model.dart';
import '../../models/trip_designer/trip/trip_model.dart';
import 'activity_filter.dart';

class TravelGroupFilter implements ActivityFilter {
  final TravelGroup travelGroup;

  TravelGroupFilter(this.travelGroup);

  @override
  String? get exclusionReason => null; // Plus utilisé ici car géré directement sur l'activité

  @override
  Future<List<ActivityForProcessing>> apply(List<ActivityForProcessing> activities) async {
    print('🔄 Application du TravelGroupFilter');
    print('📋 Contraintes du voyage:');
    print('- Enfants: ${travelGroup.members.children}');
    print('- PMR: ${travelGroup.members.pmr}');
    print('- Seniors: ${travelGroup.members.seniors}');

    return activities.where((activity) {
      print('\n🔍 Analyse de l\'activité: ${activity.name}');
      activity.exclusionReason = null;

      // Log des données initiales
      print('Données activité:');
      print('- kid_friendly: ${activity.kidFriendly}');
      print('- wheelchairAccessible: ${activity.wheelchairAccessible}');
      print('- intensityLevel: ${activity.intensityLevel}');

      // Filtre pour enfants
      if (travelGroup.members.children.isNotEmpty) {
        print('👶 Vérification enfants');
        if (activity.kidFriendly == false) {
          print('❌ Non adapté aux enfants');
          activity.exclusionReason = 'Non adapté aux enfants';
          return false;
        }
      }

      // Filtre pour PMR
      if (travelGroup.members.pmr) {
        print('♿ Vérification PMR');
        if (activity.wheelchairAccessible == 'none') {
          print('❌ Non accessible PMR');
          activity.exclusionReason = 'Non accessible PMR';
          return false;
        }
      }

      // Filtre pour seniors
      if (travelGroup.members.seniors) {
        print('👴 Vérification seniors');
        if (activity.intensityLevel > 2) {
          print('❌ Intensité trop élevée pour seniors');
          activity.exclusionReason = 'Intensité trop élevée pour seniors';
          return false;
        }
      }

      return true;
    }).toList();
  }
}