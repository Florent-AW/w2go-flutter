// lib/core/common/utils/debouncer.dart

import 'dart:async';
import 'package:flutter/foundation.dart';

/// Utilitaire pour limiter les appels fréquents à une fonction
class Debouncer {
  final int milliseconds;
  Timer? _timer;

  Debouncer({this.milliseconds = 300});

  void run(VoidCallback action) {
    _timer?.cancel();
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }

  void cancel() {
    _timer?.cancel();
  }

  bool get isActive => _timer?.isActive ?? false;
}