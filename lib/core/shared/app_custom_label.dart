import 'package:flutter/material.dart';
import 'package:rain_check/app/themes/colors.dart';
import 'package:rain_check/gen/fonts.gen.dart';

class Label extends StatelessWidget {
  final String label;
  final TextStyle? style;
  final FontWeight? fontWeight; // optional override for weight

  const Label({super.key, required this.label, this.style, this.fontWeight});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style:
          style ??
          TextStyle(
            fontSize: 14,
            fontFamily: FontFamily.plusJakartaSans,
            fontWeight: fontWeight ?? FontWeight.w400, // default bold
            letterSpacing: 1.5,
            color: AppColors.textGrey,
          ),
    );
  }
}
