import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Cores Oficiais ASCLABS
  static const Color deepDark = Color(0xFF050509);
  static const Color cosmicTeal = Color(0xFF00E5FF);
  static const Color galacticViolet = Color(0xFF8A2BE2);
  static const Color stellarWhite = Color(0xFFF8F9FA);
  
  // Cores Auxiliares (Derivadas)
  static const Color surfaceDark = Color(0xFF0C0C14);
  static const Color greyText = Color(0xFF94A3B8);
  static const Color glowColor = Color(0x4D00E5FF); // 30% teal glow

  static final ThemeData darkTheme = ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.dark(
        surface: deepDark,
        primary: cosmicTeal,
        secondary: galacticViolet,
        onSurface: stellarWhite,
        onPrimary: deepDark,
        outline: Colors.white12,
      ),
      scaffoldBackgroundColor: deepDark,
      
      // Tipografia Baseada em Sora e Inter
      textTheme: GoogleFonts.interTextTheme().copyWith(
        displayLarge: GoogleFonts.sora(color: stellarWhite, fontWeight: FontWeight.bold),
        displayMedium: GoogleFonts.sora(color: stellarWhite, fontWeight: FontWeight.bold),
        headlineMedium: GoogleFonts.sora(color: stellarWhite, fontWeight: FontWeight.w600),
        titleLarge: GoogleFonts.sora(color: stellarWhite, fontWeight: FontWeight.w600),
        bodyLarge: GoogleFonts.inter(color: stellarWhite),
        bodyMedium: GoogleFonts.inter(color: greyText),
      ),

      appBarTheme: const AppBarTheme(
        backgroundColor: deepDark,
        foregroundColor: stellarWhite,
        elevation: 0,
        centerTitle: false,
        iconTheme: IconThemeData(color: cosmicTeal),
      ),

      cardTheme: CardThemeData(
        color: surfaceDark,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: const BorderSide(color: Colors.white10, width: 1),
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white.withAlpha(5),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Colors.white24),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: cosmicTeal, width: 2),
        ),
        labelStyle: const TextStyle(color: greyText, fontSize: 14),
        hintStyle: const TextStyle(color: Colors.white24),
        prefixIconColor: cosmicTeal,
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent, // Usado com gradiente no wrapper
          foregroundColor: deepDark,
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 32),
          textStyle: GoogleFonts.sora(
            fontSize: 15,
            fontWeight: FontWeight.w800,
            letterSpacing: 1,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ).copyWith(
          backgroundColor: WidgetStateProperty.all(cosmicTeal), // Fallback
        ),
      ),

      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: deepDark,
        indicatorColor: cosmicTeal.withAlpha(30),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return GoogleFonts.inter(color: cosmicTeal, fontWeight: FontWeight.bold, fontSize: 12);
          }
          return GoogleFonts.inter(color: greyText, fontSize: 12);
        }),
      ),
    );

  // Estilos de Gradiente e Glow
  static Decoration get digitalGlowDecoration => BoxDecoration(
    borderRadius: BorderRadius.circular(16),
    gradient: const LinearGradient(
      colors: [cosmicTeal, galacticViolet],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    boxShadow: [
      BoxShadow(
        color: cosmicTeal.withAlpha(50),
        blurRadius: 15,
        spreadRadius: -2,
      ),
    ],
  );

  static Decoration get cardGlowDecoration => BoxDecoration(
    color: surfaceDark,
    borderRadius: BorderRadius.circular(24),
    border: Border.all(color: Colors.white10),
    boxShadow: [
      BoxShadow(
        color: cosmicTeal.withAlpha(10),
        blurRadius: 30,
        offset: const Offset(0, 10),
      ),
    ],
  );

  // Fallbacks de compatibilidade
  static const Color primaryBlue = cosmicTeal;
  static const Color accentColor = galacticViolet;
  static const Color textMain = stellarWhite;
  static const Color textSecondary = greyText;
  static const Color surfaceColor = surfaceDark;
  static const Color backgroundColor = deepDark;
}
