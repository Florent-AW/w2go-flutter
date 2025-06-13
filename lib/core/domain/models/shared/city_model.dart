// lib/core/domain/models/shared/city_model.dart

import 'package:equatable/equatable.dart';


class City extends Equatable{
  final String id;
  final String cityName;
  final double lat;
  final double lon;
  final String geohash5;
  final String? placeId;
  final String? zoneCode;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? postalCode;
  final String? department;

  const City({  // Ajout du const pour optimisation
    required this.id,
    required this.cityName,
    required this.lat,
    required this.lon,
    required this.geohash5,
    this.zoneCode,
    this.placeId,
    this.postalCode,
    this.department,
    required this.createdAt,
    required this.updatedAt,
  });

  // Factory constructor pour créer une instance à partir d'un JSON
  factory City.fromJson(Map<String, dynamic> json) {
    return City(
      id: json['id']?.toString() ?? '',  // Assurons-nous d'avoir une String
      cityName: json['city_name']?.toString() ?? '',
      lat: (json['lat'] as num?)?.toDouble() ?? 0.0,
      lon: (json['lon'] as num?)?.toDouble() ?? 0.0,
      geohash5: json['geohash_5']?.toString() ?? '',
      zoneCode: json['zone_code']?.toString(),
      placeId: json['place_id']?.toString(),
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'].toString())
          : DateTime.now(),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'].toString())
          : DateTime.now(),
      postalCode: json['postal_code']?.toString(),
      department: json['department']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'city_name': cityName,
      'lat': lat,
      'lon': lon,
      'geohash_5': geohash5,
      'zone_code': zoneCode,
      'place_id': placeId,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'postal_code': postalCode,
      'department': department,
    };
  }

  // Ajout d'une méthode pour la copie avec modifications
  City copyWith({
    String? id,
    String? cityName,
    double? lat,
    double? lon,
    String? geohash5,
    String? zoneCode,
    String? placeId,
    String? postalCode,
    String? department,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return City(
      id: id ?? this.id,
      cityName: cityName ?? this.cityName,
      lat: lat ?? this.lat,
      lon: lon ?? this.lon,
      geohash5: geohash5 ?? this.geohash5,
      zoneCode: zoneCode ?? this.zoneCode,
      placeId: placeId ?? this.placeId,
      postalCode: postalCode ?? this.postalCode,
      department: department ?? this.department,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() => 'City(id: $id, cityName: $cityName, geohash5: $geohash5, zoneCode: $zoneCode, postalCode: $postalCode, department: $department)';

  @override
  List<Object?> get props => [id, cityName, lat, lon, geohash5, zoneCode, postalCode, department, createdAt, updatedAt];
}