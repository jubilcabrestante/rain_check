import 'package:flutter/material.dart';
import 'package:rain_check/app/themes/colors.dart';

class AppElevatedButton extends StatelessWidget {
  final double? width;
  final void Function()? onPressed;
  final String text;
  final bool isLoading;
  final Color? color;
  final double borderRadius;
  final Widget? icon;
  final TextStyle? textStyle;

  const AppElevatedButton({
    super.key,
    this.onPressed,
    required this.text,
    this.isLoading = false,
    this.color = AppColors.textWhite,
    this.borderRadius = 16,
    this.width,
    this.icon,
    this.textStyle,
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
            backgroundColor: color == null
                ? null
                : WidgetStatePropertyAll(color),
            shape: WidgetStatePropertyAll(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(borderRadius),
              ),
            ),
          ),
          child: isLoading
              ? const Center(
                  child: SizedBox(
                    height: 25,
                    width: 25,
                    child: CircularProgressIndicator(
                      color: AppColors.secondary,
                    ),
                  ),
                )
              : icon != null
              ? Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [icon!, const SizedBox(width: 8), Text(text)],
                )
              : Text(text, style: textStyle),
        ),
      ),
    );
  }
}
