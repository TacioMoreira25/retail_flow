import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Cores estáticas (aqui o const é permitido)
  static const Color primaryRed = Color(0xFFD32F2F);
  static const Color accentRed = Color(0xFFFFEBEE);
  static const Color textDark = Color(0xFF2D2D2D);
  static const Color white = Colors.white;

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,

      // 1. Configuração de Fonte
      textTheme: GoogleFonts.montserratTextTheme().apply(
        bodyColor: textDark,
        displayColor: primaryRed,
      ),

      // 2. Esquema de Cores
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryRed,
        primary: primaryRed,
        secondary: primaryRed,
        background: const Color(0xFFF5F5F5),
        surface: white,
      ),

      // 3. AppBar
      appBarTheme: AppBarTheme(
        backgroundColor: primaryRed,
        foregroundColor: white,
        centerTitle: true,
        elevation: 0,
        titleTextStyle: GoogleFonts.montserrat(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: white,
        ),
      ),

      // 4. Floating Action Button
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: primaryRed,
        foregroundColor: white,
      ),

      // 5. Cards
      // REMOVIDO TODOS OS 'CONST' AQUI
      cardTheme: CardThemeData(
        color: white,
        elevation: 3,
        shadowColor: Colors.black26,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),

      // 6. Inputs (Campos de Texto)
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12), // Isso não pode ser const!
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.grey, width: 0.2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: primaryRed, width: 1.5),
        ),
        labelStyle: const TextStyle(color: Colors.grey),
      ),

      // 7. Botões
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: primaryRed,
          foregroundColor: white,
          textStyle: GoogleFonts.montserrat(fontWeight: FontWeight.bold),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12), // Sem const aqui também
          ),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        ),
      ),
    );
  }
}
