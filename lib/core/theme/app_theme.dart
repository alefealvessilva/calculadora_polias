import 'package:flutter/material.dart';

/// Tema único do app: escuro, plano, sem gradientes, brilhos ou sombras.
/// Usa a fonte padrão do sistema (nenhum download de fonte na inicialização).
class AppTheme {
  static const Color background = Color(0xFF0E1014);
  static const Color surface = Color(0xFF161A20);
  static const Color border = Color(0xFF262B34);
  static const Color accent = Color(0xFF22D3EE);
  static const Color textMain = Color(0xFFF1F5F9);
  static const Color textMuted = Color(0xFF8A94A6);

  // Aliases usados pelo restante do código.
  static const Color deepDark = background;
  static const Color surfaceDark = surface;
  static const Color cosmicTeal = accent;
  static const Color stellarWhite = textMain;
  static const Color greyText = textMuted;
  static const Color surfaceColor = surface;
  static const Color backgroundColor = background;

  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: background,
    colorScheme: const ColorScheme.dark(
      surface: background,
      primary: accent,
      onPrimary: background,
      onSurface: textMain,
      outline: border,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: background,
      foregroundColor: textMain,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: false,
      titleTextStyle: TextStyle(
        color: textMain,
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
    ),
    dividerTheme: const DividerThemeData(color: border, space: 1, thickness: 1),
    cardTheme: CardThemeData(
      color: surface,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: border),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: surface,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: accent, width: 1.5),
      ),
      labelStyle: const TextStyle(color: textMuted, fontSize: 14),
      floatingLabelStyle: const TextStyle(color: accent),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: accent,
        foregroundColor: background,
        minimumSize: const Size.fromHeight(50),
        textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: textMain,
        side: const BorderSide(color: border),
        minimumSize: const Size.fromHeight(46),
        textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: textMuted,
        textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
      ),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: background,
      surfaceTintColor: Colors.transparent,
      indicatorColor: accent.withAlpha(28),
      height: 64,
      labelTextStyle: WidgetStateProperty.resolveWith((states) {
        final selected = states.contains(WidgetState.selected);
        return TextStyle(
          fontSize: 12,
          fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
          color: selected ? accent : textMuted,
        );
      }),
      iconTheme: WidgetStateProperty.resolveWith((states) {
        return IconThemeData(
          color: states.contains(WidgetState.selected) ? accent : textMuted,
        );
      }),
    ),
    snackBarTheme: const SnackBarThemeData(behavior: SnackBarBehavior.floating),
  );
}
