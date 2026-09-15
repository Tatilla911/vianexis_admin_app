import 'package:flutter/material.dart';

import '../../app/vianexis_brand.dart';

/// High-contrast status accents for dark and light admin surfaces.
abstract final class AdminStatusColors {
  static const Color success = VianexisBrand.success;
  static const Color warning = VianexisBrand.warning;
  static const Color danger = VianexisBrand.danger;
  static const Color info = VianexisBrand.info;

  /// Neutral / inactive — readable on navy (not Material grey/black54).
  static const Color neutral = Color(0xFFB8C5D6);

  /// Archived / unknown — slightly cooler neutral.
  static const Color muted = Color(0xFF9AA8BA);
}
