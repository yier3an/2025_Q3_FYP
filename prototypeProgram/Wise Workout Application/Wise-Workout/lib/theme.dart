import 'package:flutter/material.dart';

class AppTheme {
  static const Color purpleLight = Color(0xFFE9E3FF);
  static const Color purple      = Color(0xFF6C63FF);
  static const Color dark        = Colors.black;

  static ThemeData theme() {
    final scheme = ColorScheme.fromSeed(seedColor: dark);
    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme.copyWith(primary: dark, secondary: purple),

      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
      ),

      scaffoldBackgroundColor: Colors.white,

      // <- IMPORTANT: CardThemeData (no trailing dot)
      cardTheme: const CardThemeData(),

      chipTheme: const ChipThemeData(
        backgroundColor: purpleLight,
        selectedColor: purpleLight,
        labelStyle: TextStyle(color: Colors.black),
        shape: StadiumBorder(),
      ),
    );
  }
}
