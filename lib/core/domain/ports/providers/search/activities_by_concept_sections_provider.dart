// core/domain/ports/providers/search/activities_by_concept_sections_provider.dart

import 'package:riverpod/riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../search/activities_by_concept_sections_port.dart';
import '../../../../adapters/supabase/search/activities_by_concept_sections_adapter.dart';

final activitiesByConceptSectionsPortProvider = Provider<ActivitiesByConceptSectionsPort>((ref) {
  final client = Supabase.instance.client;
  return ActivitiesByConceptSectionsAdapter(client);
});
