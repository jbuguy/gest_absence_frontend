import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.indigo,
      surface: const Color(0xFFF5F5FC),
    ),
    textTheme: GoogleFonts.manropeTextTheme(),

    // Use 'extensions' or global component themes for shared logic
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.grey[100],
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
    ),

    // Buttons now inherit from the seed color automatically
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),
  );
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: const Color(0xFF0E0E0E), // Base Surface Level 0

    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFFBAC3FF), // Primary Indigo
      brightness: Brightness.dark,
      surface: const Color(0xFF0E0E0E),
      onSurface: const Color(0xFFE7E5E5), // Prevents halation
      onSurfaceVariant: const Color(0xFFACABAA), // Secondary contrast
      surfaceContainerLow: const Color(0xFF131313), // Level 1
      surfaceContainer: const Color(0xFF191A1A), // Level 2
      surfaceContainerHighest: const Color(0xFF252626), // Level 3
      outlineVariant: const Color(
        0xFF484848,
      ).withValues(alpha: 0.15), // Ghost Border
    ),

    // Typography: Standardized Manrope with editorial line height
    textTheme: GoogleFonts.manropeTextTheme(ThemeData.dark().textTheme)
        .copyWith(
          displayLarge: const TextStyle(
            letterSpacing: -1.2,
            fontWeight: FontWeight.bold,
          ), // Tight spacing
          bodyMedium: const TextStyle(height: 1.6), // Academic readability
        ),

    // Unified Architecture: The Round Eight Rule
    cardTheme: const CardThemeData(
      elevation: 0,
      color: Color(0xFF131313),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFF131313), // Surface-container-low
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(
          color: Color(0x66BAC3FF),
        ), // 40% Indigo opacity
      ),
    ),
  );
}
