import 'package:flutter/material.dart';

/// ViaNexis admin visual system.
abstract final class AppTheme {
  static const Color backgroundNavy = Color(0xFF0D1B2A);
  static const Color surfaceNavy = Color(0xFF152238);
  static const Color surfaceElevated = Color(0xFF1B2A44);
  static const Color accentBlue = Color(0xFF4DA3FF);
  static const Color accentMuted = Color(0xFF8FA3BF);
  static const Color textPrimary = Color(0xFFF4F7FB);
  static const Color textSecondary = Color(0xFFB8C5D6);
  static const Color success = Color(0xFF3DDC97);
  static const Color warning = Color(0xFFFFB347);
  static const Color error = Color(0xFFFF6B6B);

  static const double tabletBreakpoint = 600;

  static ThemeData light() => _buildTheme(Brightness.light);

  static ThemeData dark() => _buildTheme(Brightness.dark);

  static ThemeData _buildTheme(Brightness brightness) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: accentBlue,
      brightness: brightness,
      surface: surfaceNavy,
      primary: accentBlue,
      onPrimary: backgroundNavy,
      onSurface: textPrimary,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      scaffoldBackgroundColor: backgroundNavy,
      colorScheme: colorScheme,
      appBarTheme: const AppBarTheme(
        backgroundColor: backgroundNavy,
        foregroundColor: textPrimary,
        elevation: 0,
        centerTitle: false,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: surfaceNavy,
        indicatorColor: accentBlue.withValues(alpha: 0.24),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return TextStyle(
            color: selected ? accentBlue : textSecondary,
            fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return IconThemeData(color: selected ? accentBlue : textSecondary);
        }),
      ),
      navigationRailTheme: const NavigationRailThemeData(
        backgroundColor: surfaceNavy,
        indicatorColor: Color(0x3D4DA3FF),
        selectedIconTheme: IconThemeData(color: accentBlue),
        unselectedIconTheme: IconThemeData(color: textSecondary),
        selectedLabelTextStyle: TextStyle(color: accentBlue),
        unselectedLabelTextStyle: TextStyle(color: textSecondary),
      ),
      cardTheme: CardThemeData(
        color: surfaceElevated,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceElevated,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        labelStyle: const TextStyle(color: textSecondary),
        hintStyle: const TextStyle(color: textSecondary),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: accentBlue,
          foregroundColor: backgroundNavy,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
      textTheme: const TextTheme(
        headlineSmall: TextStyle(
          color: textPrimary,
          fontWeight: FontWeight.w600,
        ),
        titleMedium: TextStyle(
          color: textPrimary,
          fontWeight: FontWeight.w600,
        ),
        bodyMedium: TextStyle(color: textSecondary),
        bodySmall: TextStyle(color: textSecondary),
      ),
      dividerTheme: DividerThemeData(
        color: textSecondary.withValues(alpha: 0.24),
      ),
    );
  }
}
