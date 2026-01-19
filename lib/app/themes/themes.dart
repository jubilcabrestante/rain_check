import 'package:flutter/material.dart';
import 'package:rain_check/app/themes/colors.dart';

class AppTheme {
  AppTheme._();

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,

    // Primary colors (blue / rain theme)
    primaryColor: const Color(0xFF3F51B5),
    scaffoldBackgroundColor: const Color(0xFFEAF0FA),

    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF3F51B5),
      primary: const Color(0xFF3F51B5),
      secondary: const Color(0xFF5C6BC0),
      surface: Colors.white,
      error: AppColors.highRiskRed,
    ),

    // AppBar
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF3F51B5),
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
    ),

    // Cards (white rounded like image)
    cardTheme: CardThemeData(
      color: Colors.white,
      elevation: 4,
      shadowColor: Colors.black12,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),

    // Buttons (rounded blue button)
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF3F51B5),
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        textStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          letterSpacing: 0.8,
        ),
      ),
    ),

    // Text styles
    textTheme: const TextTheme(
      titleLarge: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: Color(0xFF1A237E),
      ),
      titleMedium: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: Color(0xFF1A237E),
      ),
      bodyMedium: TextStyle(fontSize: 14, color: Color(0xFF37474F)),
      bodySmall: TextStyle(fontSize: 12, color: Color(0xFF607D8B)),
    ),

    // Divider
    dividerTheme: const DividerThemeData(color: Colors.black12, thickness: 1),

    // Icons
    iconTheme: const IconThemeData(color: Color(0xFF3F51B5)),
  );
}
