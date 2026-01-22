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
  final TextStyle? textStyle;

  const AppElevatedButton({
    super.key,
    this.onPressed,
    required this.text,
    this.isLoading = false,
    this.color,
    this.borderRadius = 16,
    this.width,
    this.icon,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    // fallback text color: if caller didn't provide one, assume white for primary BG
    final Color? resolvedTextColor =
        textStyle?.color ??
        (color == null
            ? null
            : (color == AppColors.primary ? AppColors.textWhite : null));

    return IgnorePointer(
      ignoring: isLoading,
      child: SizedBox(
        width: width,
        height: 50,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ButtonStyle(
            backgroundColor: MaterialStatePropertyAll(
              color ?? AppColors.primary,
            ),
            foregroundColor: resolvedTextColor != null
                ? MaterialStatePropertyAll(resolvedTextColor)
                : null,
            textStyle: textStyle != null
                ? MaterialStatePropertyAll(textStyle)
                : null,
            shape: MaterialStatePropertyAll(
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
                      color: resolvedTextColor ?? AppColors.secondary,
                    ),
                  ),
                )
              : (icon != null
                    ? Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // if the icon is an Icon() without color, it will inherit foregroundColor.
                          icon!,
                          const SizedBox(width: 8),
                          Text(
                            text,
                            style:
                                textStyle ??
                                TextStyle(color: resolvedTextColor),
                          ),
                        ],
                      )
                    : Text(
                        text,
                        style: textStyle ?? TextStyle(color: resolvedTextColor),
                      )),
        ),
      ),
    );
  }
}
