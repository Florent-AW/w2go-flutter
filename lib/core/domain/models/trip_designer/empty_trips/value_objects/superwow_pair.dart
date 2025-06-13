// lib/core/domain/empty_trips/value_objects/superwow_pair.dart

import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class SuperWowPair extends Equatable {
  final String sw1Id;  // Premier SuperWow (le plus proche du départ)
  final String sw2Id;  // Second SuperWow
  final LatLng sw1Location;
  final LatLng sw2Location;
  final int distanceBetween;  // Distance en mètres entre SW1 et SW2
  final Duration travelTime;  // Temps de trajet entre SW1 et SW2

  const SuperWowPair({
    required this.sw1Id,
    required this.sw2Id,
    required this.sw1Location,
    required this.sw2Location,
    required this.distanceBetween,
    required this.travelTime,
  });

  @override
  List<Object?> get props => [
    sw1Id,
    sw2Id,
    sw1Location,
    sw2Location,
    distanceBetween,
    travelTime,
  ];

  double get distanceInKm => distanceBetween / 1000;
}