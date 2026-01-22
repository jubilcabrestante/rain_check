import 'package:flutter/material.dart';

class AppColors {
  AppColors._(); // prevents instantiation

  static const Color primary = Color(0xFF49c2f9); // #4A90E2 49c2f9
  static const Color secondary = Color(0xFF7DD3FC); // #7DD3FC
  static const Color background = Color(0xFFF0F9FF); // #f0f9ff
  static const Color secondaryBackground = Color(0xFFF0F9FF); // #F0F9FF
  static const Color textWhite = Colors.white;
  static const Color textGrey = Colors.blueGrey;
  static const Color textBlack = Colors.black;
  static const Color error = Colors.red;

  // Flood risk colors
  static const Color highRiskRed = Color(0xFFD32F2F); // Red
  static const Color moderateRiskYellow = Color(0xFFFBC02D); // Yellow
  static const Color lowRiskGreen = Color(0xFF388E3C); // Green
}
