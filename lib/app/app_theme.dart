import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'vianexis_brand.dart';

/// ViaNexis admin visual system — delegates to [VianexisBrand] tokens.
abstract final class AppTheme {
  static const Color backgroundNavy = VianexisBrand.backgroundNavy;
  static const Color surfaceNavy = VianexisBrand.panelNavy;
  static const Color surfaceElevated = VianexisBrand.surfaceElevated;
  static const Color accentBlue = VianexisBrand.accentBlue;
  static const Color accentMuted = VianexisBrand.accentMuted;
  static const Color textPrimary = VianexisBrand.textPrimary;
  static const Color textSecondary = VianexisBrand.textSecondary;
  static const Color success = VianexisBrand.success;
  static const Color warning = VianexisBrand.warning;
  static const Color error = VianexisBrand.danger;

  static const double tabletBreakpoint = VianexisBrand.tabletBreakpoint;

  static ThemeData light() => _buildTheme(Brightness.light);

  static ThemeData dark() => _buildTheme(Brightness.dark);

  static ThemeData _buildTheme(Brightness brightness) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: VianexisBrand.viaNexisBlue,
      brightness: brightness,
      surface: VianexisBrand.panelNavy,
      primary: VianexisBrand.accentBlue,
      onPrimary: VianexisBrand.brandInkOnGold,
      onSurface: VianexisBrand.textPrimary,
      error: VianexisBrand.danger,
      tertiary: VianexisBrand.goldAccent,
    );

    final baseText = GoogleFonts.playfairDisplayTextTheme(
      ThemeData(brightness: brightness).textTheme,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      scaffoldBackgroundColor: VianexisBrand.backgroundNavy,
      colorScheme: colorScheme,
      fontFamily: VianexisBrand.displayFontFamily,
      appBarTheme: AppBarTheme(
        backgroundColor: VianexisBrand.backgroundNavy,
        foregroundColor: VianexisBrand.textPrimary,
        elevation: 0,
        centerTitle: false,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: VianexisBrand.displayStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: VianexisBrand.panelNavy,
        indicatorColor: VianexisBrand.accentBlue.withValues(alpha: 0.24),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return GoogleFonts.playfairDisplay(
            color: selected ? VianexisBrand.goldAccent : VianexisBrand.textSecondary,
            fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
            fontSize: 12,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return IconThemeData(
            color: selected ? VianexisBrand.goldAccent : VianexisBrand.textSecondary,
          );
        }),
      ),
      navigationRailTheme: NavigationRailThemeData(
        backgroundColor: VianexisBrand.panelNavy,
        indicatorColor: const Color(0x3D4DA3FF),
        selectedIconTheme: const IconThemeData(color: VianexisBrand.goldAccent),
        unselectedIconTheme: const IconThemeData(color: VianexisBrand.textSecondary),
        selectedLabelTextStyle: GoogleFonts.playfairDisplay(
          color: VianexisBrand.goldAccent,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelTextStyle: GoogleFonts.playfairDisplay(
          color: VianexisBrand.textSecondary,
        ),
      ),
      cardTheme: CardThemeData(
        color: VianexisBrand.surfaceElevated,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(VianexisBrand.radiusMd),
          side: const BorderSide(color: VianexisBrand.borderSubtle),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: VianexisBrand.surfaceElevated,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(VianexisBrand.radiusMd),
          borderSide: const BorderSide(color: VianexisBrand.borderSubtle),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(VianexisBrand.radiusMd),
          borderSide: const BorderSide(color: VianexisBrand.borderSubtle),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(VianexisBrand.radiusMd),
          borderSide: const BorderSide(color: VianexisBrand.accentBlue, width: 1.5),
        ),
        labelStyle: GoogleFonts.playfairDisplay(color: VianexisBrand.textSecondary),
        hintStyle: GoogleFonts.playfairDisplay(color: VianexisBrand.textSecondary),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: VianexisBrand.goldAccent,
          foregroundColor: VianexisBrand.brandInkOnGold,
          textStyle: GoogleFonts.playfairDisplay(fontWeight: FontWeight.w600),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(VianexisBrand.radiusMd),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: VianexisBrand.brandInkSoft,
          textStyle: GoogleFonts.playfairDisplay(fontWeight: FontWeight.w600),
          side: const BorderSide(color: VianexisBrand.goldAccent, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(VianexisBrand.radiusMd),
          ),
        ),
      ),
      textTheme: baseText.copyWith(
        headlineSmall: VianexisBrand.displayStyle(
          fontSize: 24,
          fontWeight: FontWeight.w600,
        ),
        titleLarge: VianexisBrand.displayStyle(
          fontSize: 22,
          fontWeight: FontWeight.w700,
        ),
        titleMedium: VianexisBrand.displayStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
        bodyMedium: GoogleFonts.playfairDisplay(
          color: VianexisBrand.textSecondary,
          fontSize: 14,
        ),
        bodySmall: GoogleFonts.playfairDisplay(
          color: VianexisBrand.textSecondary,
          fontSize: 12,
        ),
        labelLarge: GoogleFonts.playfairDisplay(
          color: VianexisBrand.textPrimary,
          fontWeight: FontWeight.w600,
        ),
      ),
      dividerTheme: DividerThemeData(
        color: VianexisBrand.textSecondary.withValues(alpha: 0.24),
      ),
    );
  }
}
