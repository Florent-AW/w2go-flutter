// lib/core/domain/ports/providers/empty_trips/geometry_calculation.provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../adapters/postgis/geometry_calculation.adapter.dart';
import '../../empty_trips/geometry_calculation.port.dart';

final geometryCalculationPortProvider = Provider<GeometryCalculationPort>((ref) {
  final supabase = Supabase.instance.client;
  return GeometryCalculationAdapter(supabase);
});