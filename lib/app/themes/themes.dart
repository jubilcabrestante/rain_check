import 'package:flutter/material.dart';
import 'package:rain_check/app/themes/colors.dart';
import 'package:rain_check/gen/fonts.gen.dart';

class AppTheme {
  AppTheme._(); // private constructor

  factory AppTheme.getInstance() => AppTheme._();

  // LIGHT THEME
  ThemeData get lightTheme => ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    fontFamily: FontFamily.plusJakartaSans,

    // Core colors
    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: AppColors.background,

    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      brightness: Brightness.light,
      primary: AppColors.primary,
      secondary: AppColors.secondary,
      surface: AppColors.background,
      onSurface: AppColors.textBlack,
      error: AppColors.highRiskRed,
      onPrimary: AppColors.textWhite,
      onError: AppColors.textWhite,
    ),

    // AppBar
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.primary,
      foregroundColor: AppColors.textWhite,
      elevation: 0,
      centerTitle: true,
    ),

    // Cards
    cardTheme: CardThemeData(
      color: AppColors.textWhite,
      elevation: 4,
      shadowColor: Colors.black12,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),

    // Elevated Buttons
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        textStyle: const WidgetStatePropertyAll(
          TextStyle(
            fontFamily: FontFamily.plusJakartaSans,
            fontWeight: FontWeight.w200,
            fontSize: 16,
          ),
        ),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        ),
        padding: const WidgetStatePropertyAll(
          EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        ),
      ),
    ),

    // TextButton
    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
        foregroundColor: const WidgetStatePropertyAll(AppColors.primary),
        textStyle: const WidgetStatePropertyAll(
          TextStyle(
            fontFamily: FontFamily.plusJakartaSans,
            fontWeight: FontWeight.w500,
            fontSize: 16,
          ),
        ),
      ),
    ),

    // OutlinedButton
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: ButtonStyle(
        side: const WidgetStatePropertyAll(
          BorderSide(color: AppColors.primary),
        ),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
      ),
    ),

    // Inputs
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.textWhite,
      hintStyle: const TextStyle(
        fontFamily: FontFamily.plusJakartaSans,
        fontSize: 14,
        color: AppColors.textGrey,
      ),
      labelStyle: const TextStyle(
        fontFamily: FontFamily.plusJakartaSans,
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: AppColors.textGrey,
      ),
      floatingLabelStyle: const TextStyle(
        fontFamily: FontFamily.plusJakartaSans,
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: AppColors.primary,
      ),

      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: AppColors.secondaryBackground),
      ),

      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: AppColors.primary),
      ),

      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: AppColors.highRiskRed),
      ),

      // ✅ THIS IS THE MISSING PIECE
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: AppColors.highRiskRed, width: 1.5),
      ),
    ),

    // Text Theme
    textTheme: TextTheme(
      titleLarge: const TextStyle(
        fontFamily: FontFamily.plusJakartaSans,
        fontSize: 22,
        fontWeight: FontWeight.w900,
        color: AppColors.textBlack,
      ),
      titleMedium: const TextStyle(
        fontFamily: FontFamily.plusJakartaSans,
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: AppColors.textBlack,
      ),
      bodyLarge: const TextStyle(
        fontFamily: FontFamily.plusJakartaSans,
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
      bodyMedium: const TextStyle(
        fontFamily: FontFamily.plusJakartaSans,
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: AppColors.textGrey,
      ),
      bodySmall: const TextStyle(
        fontFamily: FontFamily.plusJakartaSans,
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: AppColors.textGrey,
      ),
    ),

    // Divider
    dividerTheme: const DividerThemeData(color: Colors.black12, thickness: 1),

    // Icons
    iconTheme: const IconThemeData(color: AppColors.primary),
  );

  // DARK THEME
  ThemeData get darkTheme => ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    fontFamily: FontFamily.plusJakartaSans,

    // Core colors
    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: const Color(0xFF0F1115), // dark background
    cardColor: const Color(0xFF1C1F26),
    canvasColor: const Color(0xFF0F1115),

    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      brightness: Brightness.dark,
      primary: AppColors.primary,
      secondary: AppColors.secondary,
      surface: const Color(0xFF1C1F26),
      onSurface: AppColors.textWhite,
      error: AppColors.highRiskRed,
      onPrimary: AppColors.textWhite,
      onError: AppColors.textWhite,
    ),

    // AppBar
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.primary,
      foregroundColor: AppColors.textWhite,
      elevation: 0,
      centerTitle: true,
    ),

    // Cards
    cardTheme: CardThemeData(
      color: const Color(0xFF1C1F26),
      elevation: 4,
      shadowColor: Colors.black54,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),

    // Elevated Buttons
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) {
            return const Color(0xFF3A3E47);
          }
          return AppColors.primary;
        }),
        foregroundColor: const WidgetStatePropertyAll(AppColors.textWhite),
        textStyle: const WidgetStatePropertyAll(
          TextStyle(
            fontFamily: FontFamily.plusJakartaSans,
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        ),
        padding: const WidgetStatePropertyAll(
          EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        ),
      ),
    ),

    // TextButton
    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
        foregroundColor: const WidgetStatePropertyAll(AppColors.secondary),
        textStyle: const WidgetStatePropertyAll(
          TextStyle(
            fontFamily: FontFamily.plusJakartaSans,
            fontWeight: FontWeight.w500,
            fontSize: 16,
          ),
        ),
      ),
    ),

    // OutlinedButton
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: ButtonStyle(
        side: const WidgetStatePropertyAll(
          BorderSide(color: AppColors.secondary),
        ),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
      ),
    ),

    // Inputs
    inputDecorationTheme: InputDecorationTheme(
      hintStyle: const TextStyle(
        fontFamily: FontFamily.plusJakartaSans,
        fontSize: 14,
        color: AppColors.textGrey,
      ),
      labelStyle: const TextStyle(
        fontFamily: FontFamily.plusJakartaSans,
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: AppColors.textWhite,
      ),
      floatingLabelStyle: const TextStyle(
        fontFamily: FontFamily.plusJakartaSans,
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: AppColors.primary,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Color(0xFF3A3E47)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: AppColors.primary),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: AppColors.highRiskRed),
      ),
    ),

    // Text Theme
    textTheme: TextTheme(
      titleLarge: const TextStyle(
        fontFamily: FontFamily.plusJakartaSans,
        fontSize: 22,
        fontWeight: FontWeight.w900,
        color: AppColors.textWhite,
      ),
      titleMedium: const TextStyle(
        fontFamily: FontFamily.plusJakartaSans,
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: AppColors.textWhite,
      ),
      bodyLarge: const TextStyle(
        fontFamily: FontFamily.plusJakartaSans,
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: AppColors.textWhite,
      ),
      bodyMedium: const TextStyle(
        fontFamily: FontFamily.plusJakartaSans,
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: AppColors.textGrey,
      ),
      bodySmall: const TextStyle(
        fontFamily: FontFamily.plusJakartaSans,
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: AppColors.textGrey,
      ),
    ),

    // Divider
    dividerTheme: const DividerThemeData(color: Colors.white24, thickness: 1),

    // Icons
    iconTheme: const IconThemeData(color: AppColors.textWhite),
  );
}
