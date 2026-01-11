import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Panggil class ini di main.dart -> MaterialApp(theme: JalanKitaTheme.darkTheme)

class JalanKitaTheme {
  // Definisi Warna Utama
  static const Color primaryColor = Color(0xFFFFC107); // Amber
  static const Color backgroundColor = Color(0xFF121212); // Hitam Pekat
  static const Color surfaceColor = Color(0xFF1E1E1E); // Abu Gelap (Card)
  static const Color errorColor = Color(0xFFEF5350); // Merah
  static const Color inputColor = Color(0xFF2C2C2C); // Abu (Input)

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: primaryColor,
      scaffoldBackgroundColor: backgroundColor,

      // Mengatur Warna Aksen & Scheme
      colorScheme: const ColorScheme.dark(
        primary: primaryColor,
        secondary: primaryColor,
        surface: surfaceColor,
        error: errorColor,
        onPrimary: Colors.black, // Warna teks di atas tombol kuning
        onSurface: Colors.white, // Warna teks di atas card gelap
      ),

      // Mengatur Font Default
      textTheme: TextTheme(
        displayLarge: GoogleFonts.poppins(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        displayMedium: GoogleFonts.poppins(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        bodyLarge: GoogleFonts.inter(fontSize: 16, color: Colors.white70),
        bodyMedium: GoogleFonts.inter(fontSize: 14, color: Colors.white60),
      ),

      // Mengatur Style Tombol (ElevatedButton)
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.black, // Teks tombol jadi hitam biar kontras
          elevation: 0,
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold),
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),

      // Mengatur Style Input Form (TextField)
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: inputColor, 
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primaryColor, width: 2),
        ),
        labelStyle: const TextStyle(color: Colors.grey),
        hintStyle: TextStyle(color: Colors.grey.withOpacity(0.5)),
      ),

      // Mengatur Style Card
      cardTheme: CardThemeData(
        color: surfaceColor,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }
}
