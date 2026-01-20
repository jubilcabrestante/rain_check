import 'package:flutter/material.dart';
import 'package:rain_check/app/themes/colors.dart';

class AppElevatedButton extends StatelessWidget {
  final double? width;
  final void Function()? onPressed;
  final String text;
  final bool? isLoading;
  final Color? color;
  final double? borderRadius;
  const AppElevatedButton({
    super.key,
    this.onPressed,
    required this.text,
    this.isLoading = false,
    this.color,
    this.borderRadius = 16,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: isLoading!,
      child: SizedBox(
        width: width,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ButtonStyle(
            backgroundColor: color == null
                ? null
                : WidgetStatePropertyAll(color),
            shape: WidgetStatePropertyAll(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(borderRadius!),
              ),
            ),
          ),
          child: Builder(
            builder: (context) {
              if (isLoading!) {
                return const Center(
                  child: SizedBox(
                    height: 25,
                    width: 25,
                    child: CircularProgressIndicator(
                      color: AppColors.secondary,
                    ),
                  ),
                );
              }
              return Text(
                text,
                // style: Theme.of(context).textTheme.bodyMedium,
              );
            },
          ),
        ),
      ),
    );
  }
}
