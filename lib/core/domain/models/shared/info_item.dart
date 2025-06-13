// lib/core/domain/models/shared/info_item.dart

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/material.dart';

part 'info_item.freezed.dart';

@freezed
class InfoItem with _$InfoItem {
  const factory InfoItem({
    required String iconName,        // Icône
    required String value,           // Info directe (plus de title)
    String? subtitle,               // Ligne descriptive optionnelle
    Color? valueColor,              // Couleur spécifique
    InfoItemType? type,             // Type pour logique métier
  }) = _InfoItem;
}

enum InfoItemType {
  family,
  booking,
  duration,
  price,
  accessibility,
  hours,
  status,
}