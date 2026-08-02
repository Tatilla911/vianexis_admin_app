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
    final isDark = brightness == Brightness.dark;
    final scaffold = VianexisBrand.scaffoldOf(brightness);
    final panel = VianexisBrand.panelOf(brightness);
    final surface = VianexisBrand.surfaceOf(brightness);
    final onSurface = VianexisBrand.textPrimaryOf(brightness);
    final muted = VianexisBrand.textSecondaryOf(brightness);
    final border = VianexisBrand.borderOf(brightness);

    final colorScheme = ColorScheme.fromSeed(
      seedColor: VianexisBrand.viaNexisBlue,
      brightness: brightness,
      surface: panel,
      primary: VianexisBrand.accentBlue,
      onPrimary: isDark ? VianexisBrand.brandInkOnGold : Colors.white,
      onSurface: onSurface,
      error: VianexisBrand.danger,
      tertiary: VianexisBrand.goldAccent,
    );

    final baseText = GoogleFonts.playfairDisplayTextTheme(
      ThemeData(brightness: brightness).textTheme,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      scaffoldBackgroundColor: scaffold,
      colorScheme: colorScheme,
      fontFamily: VianexisBrand.displayFontFamily,
      appBarTheme: AppBarTheme(
        backgroundColor: scaffold,
        foregroundColor: onSurface,
        elevation: 0,
        centerTitle: false,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: VianexisBrand.displayStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: onSurface,
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: panel,
        indicatorColor: VianexisBrand.accentBlue.withValues(alpha: 0.24),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return GoogleFonts.playfairDisplay(
            color: selected ? VianexisBrand.goldAccent : muted,
            fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
            fontSize: 12,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return IconThemeData(
            color: selected ? VianexisBrand.goldAccent : muted,
          );
        }),
      ),
      navigationRailTheme: NavigationRailThemeData(
        backgroundColor: panel,
        indicatorColor: const Color(0x3D4DA3FF),
        selectedIconTheme: const IconThemeData(color: VianexisBrand.goldAccent),
        unselectedIconTheme: IconThemeData(color: muted),
        selectedLabelTextStyle: GoogleFonts.playfairDisplay(
          color: VianexisBrand.goldAccent,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelTextStyle: GoogleFonts.playfairDisplay(color: muted),
      ),
      cardTheme: CardThemeData(
        color: surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(VianexisBrand.radiusMd),
          side: BorderSide(color: border),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(VianexisBrand.radiusMd),
          borderSide: BorderSide(color: border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(VianexisBrand.radiusMd),
          borderSide: BorderSide(color: border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(VianexisBrand.radiusMd),
          borderSide: const BorderSide(
            color: VianexisBrand.accentBlue,
            width: 1.5,
          ),
        ),
        labelStyle: GoogleFonts.playfairDisplay(color: muted),
        hintStyle: GoogleFonts.playfairDisplay(color: muted),
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
          foregroundColor: isDark ? VianexisBrand.brandInkSoft : onSurface,
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
          color: onSurface,
        ),
        titleLarge: VianexisBrand.displayStyle(
          fontSize: 22,
          fontWeight: FontWeight.w700,
          color: onSurface,
        ),
        titleMedium: VianexisBrand.displayStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: onSurface,
        ),
        bodyLarge: GoogleFonts.playfairDisplay(color: onSurface, fontSize: 16),
        bodyMedium: GoogleFonts.playfairDisplay(color: muted, fontSize: 14),
        bodySmall: GoogleFonts.playfairDisplay(color: muted, fontSize: 12),
        labelLarge: GoogleFonts.playfairDisplay(
          color: onSurface,
          fontWeight: FontWeight.w600,
        ),
      ),
      dividerTheme: DividerThemeData(color: muted.withValues(alpha: 0.24)),
      listTileTheme: ListTileThemeData(
        iconColor: muted,
        textColor: onSurface,
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return VianexisBrand.goldAccent;
          }
          return muted;
        }),
      ),
    );
  }
}
