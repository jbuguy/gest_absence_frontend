import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.indigo,
      brightness: Brightness.light,
      primary: Colors.indigo,
      onPrimary: Colors.white,
      surface: const Color(0xFFF8F9FF),
      surfaceContainerLow: Colors.white,
    ),
    textTheme: GoogleFonts.manropeTextTheme(),
    cardTheme: CardThemeData(
      elevation: 0,
      shape: RoundedRectangleBorder(),
      color: Colors.white,
    ),
  );
}
