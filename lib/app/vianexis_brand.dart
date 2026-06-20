import 'package:flutter/material.dart';

/// ViaNexis Admin design tokens — enterprise control center visual system.
abstract final class VianexisBrand {
  // Core brand palette
  static const Color backgroundNavy = Color(0xFF0D1B2A);
  static const Color panelNavy = Color(0xFF152238);
  static const Color surfaceElevated = Color(0xFF1B2A44);
  static const Color surfaceMuted = Color(0xFF243447);

  static const Color viaNexisBlue = Color(0xFF4FA3E3);
  static const Color accentBlue = Color(0xFF4DA3FF);
  static const Color accentMuted = Color(0xFF8FA3BF);
  static const Color goldAccent = Color(0xFFD4AF37);

  static const Color textPrimary = Color(0xFFF4F7FB);
  static const Color textSecondary = Color(0xFFB8C5D6);
  static const Color borderSubtle = Color(0xFF2E4059);

  // Semantic colors
  static const Color success = Color(0xFF3DDC97);
  static const Color warning = Color(0xFFFFB347);
  static const Color danger = Color(0xFFFF6B6B);
  static const Color info = Color(0xFF77C2FF);

  // Spacing
  static const double spaceXs = 4;
  static const double spaceSm = 8;
  static const double spaceMd = 12;
  static const double spaceLg = 16;
  static const double spaceXl = 20;
  static const double space2xl = 24;
  static const double space3xl = 32;

  // Radius
  static const double radiusSm = 8;
  static const double radiusMd = 12;
  static const double radiusLg = 16;

  // Layout
  static const double tabletBreakpoint = 600;
  static const double desktopNavBreakpoint = 900;
  static const double maxContentWidth = 1200;

  // Asset paths (optional — widgets fall back if missing)
  static const String logoAsset = 'assets/branding/vianexis_logo.png';
  static const String markAsset = 'assets/branding/vianexis_mark.png';
  static const String watermarkAsset = 'assets/branding/vianexis_watermark.png';

  static BoxShadow cardShadow(Brightness brightness) {
    return BoxShadow(
      color: Colors.black.withValues(alpha: brightness == Brightness.dark ? 0.35 : 0.12),
      blurRadius: 16,
      offset: const Offset(0, 6),
    );
  }

  static TextStyle sectionTitleStyle(BuildContext context) {
    return Theme.of(context).textTheme.titleMedium!.copyWith(
      color: textPrimary,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.2,
    );
  }

  static TextStyle metricValueStyle(BuildContext context) {
    return Theme.of(context).textTheme.titleLarge!.copyWith(
      color: textPrimary,
      fontWeight: FontWeight.w700,
    );
  }
}
