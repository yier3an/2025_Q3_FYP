import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Admin Dashboard theme (ported) — styling only, no Firebase.
/// Reuse this across the Fitness Professional app.
class AppTheme {
  // Brand colors (from Admin)
  static const Color purpleDark = Color(0xFF3F0FFF);
  static const Color purple = Color(0xFF7A3EF2);
  static const Color purpleLight = Color(0xFFB18CFF);

  // Sidebar background
  static const Color sidebarBg = Color(0xFF2A166B);

  // Light scaffold background
  static const Color scaffoldBg = Color(0xFFF7F7FB);

  // Core ThemeData
  static ThemeData theme = ThemeData(
    useMaterial3: true,
    colorSchemeSeed: purple,
    brightness: Brightness.light,
    scaffoldBackgroundColor: scaffoldBg,
    // Typography from Admin: Inter
    textTheme: GoogleFonts.interTextTheme(),
    pageTransitionsTheme: const PageTransitionsTheme(builders: {
      TargetPlatform.android: ZoomPageTransitionsBuilder(),     // smooth scale+fade
      TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),    // native iOS slide
      TargetPlatform.macOS: FadeUpwardsPageTransitionsBuilder(),
      TargetPlatform.windows: FadeUpwardsPageTransitionsBuilder(),
      TargetPlatform.linux: FadeUpwardsPageTransitionsBuilder(),
      TargetPlatform.fuchsia: FadeUpwardsPageTransitionsBuilder(),
    }),
    // Clean app bar like Admin
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      elevation: 0.5,
    ),
    // Example component themes
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: purple,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: purple,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: purpleDark,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.withOpacity(0.25)),
      ),
    ),
    cardTheme: const CardThemeData(
      color: Colors.white,
      elevation: 0.5,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
    ),
  );

  // Admin dashboard gradient (outside ThemeData)
  static const BoxDecoration dashboardGradient = BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topRight,
      end: Alignment.bottomLeft,
      colors: [Color(0xFF7A3EF2), Color(0xFF3F0FFF)],
    ),
  );
}
