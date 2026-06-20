import 'package:flutter/material.dart';

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
      onPrimary: VianexisBrand.backgroundNavy,
      onSurface: VianexisBrand.textPrimary,
      error: VianexisBrand.danger,
      tertiary: VianexisBrand.goldAccent,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      scaffoldBackgroundColor: VianexisBrand.backgroundNavy,
      colorScheme: colorScheme,
      appBarTheme: const AppBarTheme(
        backgroundColor: VianexisBrand.backgroundNavy,
        foregroundColor: VianexisBrand.textPrimary,
        elevation: 0,
        centerTitle: false,
        surfaceTintColor: Colors.transparent,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: VianexisBrand.panelNavy,
        indicatorColor: VianexisBrand.accentBlue.withValues(alpha: 0.24),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return TextStyle(
            color: selected ? VianexisBrand.accentBlue : VianexisBrand.textSecondary,
            fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return IconThemeData(
            color: selected ? VianexisBrand.accentBlue : VianexisBrand.textSecondary,
          );
        }),
      ),
      navigationRailTheme: const NavigationRailThemeData(
        backgroundColor: VianexisBrand.panelNavy,
        indicatorColor: Color(0x3D4DA3FF),
        selectedIconTheme: IconThemeData(color: VianexisBrand.accentBlue),
        unselectedIconTheme: IconThemeData(color: VianexisBrand.textSecondary),
        selectedLabelTextStyle: TextStyle(color: VianexisBrand.accentBlue),
        unselectedLabelTextStyle: TextStyle(color: VianexisBrand.textSecondary),
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
        labelStyle: const TextStyle(color: VianexisBrand.textSecondary),
        hintStyle: const TextStyle(color: VianexisBrand.textSecondary),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: VianexisBrand.accentBlue,
          foregroundColor: VianexisBrand.backgroundNavy,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(VianexisBrand.radiusMd),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: VianexisBrand.accentBlue,
          side: const BorderSide(color: VianexisBrand.borderSubtle),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(VianexisBrand.radiusMd),
          ),
        ),
      ),
      textTheme: const TextTheme(
        headlineSmall: TextStyle(
          color: VianexisBrand.textPrimary,
          fontWeight: FontWeight.w600,
        ),
        titleMedium: TextStyle(
          color: VianexisBrand.textPrimary,
          fontWeight: FontWeight.w600,
        ),
        bodyMedium: TextStyle(color: VianexisBrand.textSecondary),
        bodySmall: TextStyle(color: VianexisBrand.textSecondary),
      ),
      dividerTheme: DividerThemeData(
        color: VianexisBrand.textSecondary.withValues(alpha: 0.24),
      ),
    );
  }
}
