import 'package:flutter/material.dart';
import 'package:rain_check/app/themes/colors.dart';

class AppElevatedButton extends StatelessWidget {
  final double? width;
  final void Function()? onPressed;
  final String text;
  final bool isLoading;
  final Color? color; // background color
  final double borderRadius;
  final Widget? icon;
  final Color? textColor;

  const AppElevatedButton({
    super.key,
    this.onPressed,
    required this.text,
    this.isLoading = false,
    this.color,
    this.borderRadius = 16,
    this.width,
    this.icon,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: isLoading,
      child: SizedBox(
        width: width,
        height: 50,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ButtonStyle(
            backgroundColor: WidgetStatePropertyAll(color ?? AppColors.primary),
            foregroundColor: WidgetStatePropertyAll(
              textColor ?? AppColors.textWhite,
            ),
            shape: WidgetStatePropertyAll(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(borderRadius),
              ),
            ),
          ),
          child: isLoading
              ? Center(
                  child: SizedBox(
                    height: 25,
                    width: 25,
                    child: CircularProgressIndicator(
                      color: textColor ?? AppColors.textWhite,
                    ),
                  ),
                )
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (icon != null) ...[icon!, const SizedBox(width: 8)],
                    Text(
                      text,
                      style: TextStyle(color: textColor ?? AppColors.textWhite),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
