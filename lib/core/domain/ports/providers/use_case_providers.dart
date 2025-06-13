// core/domain/ports/providers/use_case_providers.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../use_cases/create_trip_use_case.dart';
import '../../use_cases/process_activities_use_case.dart';
import 'port_providers.dart';
import 'service_providers.dart';

final createTripUseCaseProvider = Provider((ref) {
  return CreateTripUseCase(
      ref.watch(tripPortProvider),
      ref.watch(geocodingServiceProvider)
  );
});

final processActivitiesUseCaseProvider = Provider<ProcessActivitiesUseCase>((ref) {
  final processingPort = ref.watch(activityProcessingPortProvider);
  final tripPort = ref.watch(tripPortProvider);
  return ProcessActivitiesUseCase(processingPort, tripPort);
});