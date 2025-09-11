import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color purpleDark = Color(0xFF3F0FFF);
  static const Color purple = Color(0xFF7A3EF2);
  static const Color purpleLight = Color(0xFFB18CFF);
  static const Color sidebarBg = Color(0xFF2A166B);

  static ThemeData theme = ThemeData(
    useMaterial3: true,
    colorSchemeSeed: purple,
    scaffoldBackgroundColor: const Color(0xFFF7F7FB),
    textTheme: GoogleFonts.interTextTheme(),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      elevation: 0.5,
    ),
  );

  static BoxDecoration dashboardGradient = const BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topRight,
      end: Alignment.bottomLeft,
      colors: [Color(0xFF7A3EF2), Color(0xFF3F0FFF)],
    ),
  );
}
