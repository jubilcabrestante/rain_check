import 'package:flutter/material.dart';

class AppColors {
  AppColors._(); // prevents instantiation
  static const Color primary = Color(0xFF3F51B5);
  static const Color secondary = Color.fromARGB(255, 114, 140, 255);
  static const Color lightBlueBackground = Color(0xFFEAF0FA);
  static const Color textWhite = Colors.white;
  static const Color textGrey = Colors.grey;
  static const Color error = Colors.red;
  // Flood risk colors
  static const Color highRiskRed = Color(0xFFD32F2F); // Red
  static const Color moderateRiskYellow = Color(0xFFFBC02D); // Yellow
  static const Color lowRiskGreen = Color(0xFF388E3C); // Green
}
