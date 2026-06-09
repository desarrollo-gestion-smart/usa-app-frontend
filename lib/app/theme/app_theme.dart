import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Colors
  static const Color accent = Color(0xFFFF6B1A);
  static const Color accentDark = Color(0xFFC44A08);
  static const Color accentLight = Color(0xFFFF8A3D);
  static const Color accentDim = Color.fromARGB(36, 255, 107, 26); // rgba(255, 107, 26, 0.14)

  static const Color paper = Color(0xFFFFFFFF);
  static const Color surface = Color(0xFFFAFAFA);
  static const Color fg = Color(0xFF1F1F1F);
  static const Color ink = Color(0xFF0A0A0A);
  static const Color muted = Color(0xFF777777);
  static const Color line = Color(0xFFE5E5E5);
  static const Color lineDark = Color(0xFFD6D6D6);

  static const Color good = Color(0xFF58CC02);
  static const Color goodDark = Color(0xFF46A302);
  static const Color goodDim = Color.fromARGB(36, 88, 204, 2);

  static const Color warn = Color(0xFFFFC800);

  static ThemeData light() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: paper,

      colorScheme: const ColorScheme.light(
        primary: accent,
        secondary: accentLight,
        surface: surface,
        onSurface: fg,
        onPrimary: paper,
      ),

      textTheme: _textTheme(),
      appBarTheme: AppBarTheme(
        backgroundColor: paper,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: GoogleFonts.fredoka(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: fg,
        ),
        iconTheme: const IconThemeData(color: fg),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: paper,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: line, width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: line, width: 2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: accent, width: 2),
        ),
        hintStyle: GoogleFonts.nunito(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: muted,
        ),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: accent,
          foregroundColor: paper,
          elevation: 5,
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 15),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          textStyle: GoogleFonts.fredoka(
            fontSize: 13,
            fontWeight: FontWeight.w900,
            letterSpacing: 0.14,
          ),
        ),
      ),
    );
  }

  static TextTheme _textTheme() {
    return TextTheme(
      displayLarge: GoogleFonts.fredoka(
        fontSize: 42,
        fontWeight: FontWeight.w800,
        letterSpacing: -0.018,
        color: fg,
      ),
      displayMedium: GoogleFonts.fredoka(
        fontSize: 32,
        fontWeight: FontWeight.w800,
        letterSpacing: -0.018,
        color: fg,
      ),
      displaySmall: GoogleFonts.fredoka(
        fontSize: 28,
        fontWeight: FontWeight.w800,
        letterSpacing: -0.012,
        color: fg,
      ),
      headlineMedium: GoogleFonts.fredoka(
        fontSize: 22,
        fontWeight: FontWeight.w800,
        letterSpacing: -0.01,
        color: fg,
      ),
      headlineSmall: GoogleFonts.fredoka(
        fontSize: 19,
        fontWeight: FontWeight.w800,
        letterSpacing: -0.005,
        color: fg,
      ),
      titleLarge: GoogleFonts.nunito(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: fg,
      ),
      titleMedium: GoogleFonts.nunito(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: fg,
      ),
      bodyLarge: GoogleFonts.nunito(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: fg,
      ),
      bodyMedium: GoogleFonts.nunito(
        fontSize: 13,
        fontWeight: FontWeight.w400,
        color: fg,
      ),
      bodySmall: GoogleFonts.nunito(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: muted,
      ),
      labelLarge: GoogleFonts.fredoka(
        fontSize: 13,
        fontWeight: FontWeight.w900,
        letterSpacing: 0.14,
        color: paper,
      ),
    );
  }
}
