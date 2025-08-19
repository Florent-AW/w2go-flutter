// core/domain/ports/providers/search/activities_by_concept_provider.dart

import 'package:riverpod/riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../search/activities_by_concept_port.dart';
import '../../../../adapters/supabase/search/activities_by_concept_adapter.dart';

final activitiesByConceptPortProvider = Provider<ActivitiesByConceptPort>((ref) {
  final client = Supabase.instance.client;
  return ActivitiesByConceptAdapter(client);
});
