import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// ViaNexis Admin design tokens — enterprise control center visual system.
abstract final class VianexisBrand {
  // Dark (night) palette — slightly lifted navy for readability
  static const Color backgroundNavy = Color(0xFF152536);
  static const Color panelNavy = Color(0xFF1C2F48);
  static const Color surfaceElevated = Color(0xFF243A58);
  static const Color surfaceMuted = Color(0xFF2C4564);

  // Light (day) palette
  static const Color backgroundLight = Color(0xFFF3F6FA);
  static const Color panelLight = Color(0xFFFFFFFF);
  static const Color surfaceElevatedLight = Color(0xFFFFFFFF);
  static const Color surfaceMutedLight = Color(0xFFE8EEF5);
  static const Color textPrimaryLight = Color(0xFF152536);
  static const Color textSecondaryLight = Color(0xFF4A5D73);
  static const Color borderSubtleLight = Color(0xFFCDD7E4);

  static const Color viaNexisBlue = Color(0xFF4FA3E3);
  static const Color accentBlue = Color(0xFF4DA3FF);
  static const Color accentMuted = Color(0xFFB08F58);
  static const Color goldAccent = Color(0xFFD4AF37);

  /// Champagne metallic ink (replaces flat white on dark chrome).
  static const Color textPrimary = Color(0xFFF3E9C8);
  static const Color textSecondary = Color(0xFFD4C49A);
  static const Color brandInkSoft = Color(0xFFE8D5A3);
  static const Color brandInkOnGold = Color(0xFF3D2E14);
  static const Color borderSubtle = Color(0xFF3A5270);

  /// Lockup-matching champagne gradient stops.
  static const List<Color> metallicGoldStops = [
    Color(0xFFF8F1DC),
    Color(0xFFEFE0B8),
    Color(0xFFDCC487),
    Color(0xFFC4A46A),
    Color(0xFFA8884E),
    Color(0xFFE6D4A4),
    Color(0xFFF3E9C8),
  ];

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
  static const String backgroundAsset =
      'assets/backgrounds/admin_background.png';
  static const String appIconAsset = 'assets/icons/app_icon.png';

  static String get displayFontFamily =>
      GoogleFonts.playfairDisplay().fontFamily ?? 'serif';

  static TextStyle displayStyle({
    double fontSize = 18,
    FontWeight fontWeight = FontWeight.w600,
    Color? color,
    double? letterSpacing,
    double? height,
  }) {
    return GoogleFonts.playfairDisplay(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color ?? textPrimary,
      letterSpacing: letterSpacing,
      height: height,
    );
  }

  static Shader metallicGoldShader(Rect bounds) {
    return const LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: metallicGoldStops,
    ).createShader(bounds);
  }

  static BoxShadow cardShadow(Brightness brightness) {
    return BoxShadow(
      color: Colors.black.withValues(
        alpha: brightness == Brightness.dark ? 0.28 : 0.08,
      ),
      blurRadius: 16,
      offset: const Offset(0, 6),
    );
  }

  static Color scaffoldOf(Brightness brightness) =>
      brightness == Brightness.dark ? backgroundNavy : backgroundLight;

  static Color panelOf(Brightness brightness) =>
      brightness == Brightness.dark ? panelNavy : panelLight;

  static Color surfaceOf(Brightness brightness) =>
      brightness == Brightness.dark ? surfaceElevated : surfaceElevatedLight;

  static Color textPrimaryOf(Brightness brightness) =>
      brightness == Brightness.dark ? textPrimary : textPrimaryLight;

  static Color textSecondaryOf(Brightness brightness) =>
      brightness == Brightness.dark ? textSecondary : textSecondaryLight;

  static Color borderOf(Brightness brightness) =>
      brightness == Brightness.dark ? borderSubtle : borderSubtleLight;

  static TextStyle sectionTitleStyle(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return displayStyle(
      fontSize: Theme.of(context).textTheme.titleMedium?.fontSize ?? 16,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.2,
      color: textPrimaryOf(brightness),
    );
  }

  static TextStyle metricValueStyle(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return displayStyle(
      fontSize: Theme.of(context).textTheme.titleLarge?.fontSize ?? 22,
      fontWeight: FontWeight.w700,
      color: textPrimaryOf(brightness),
    );
  }
}
