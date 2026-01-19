import 'package:flutter/material.dart';

class AppCustomButton extends StatelessWidget {
  final String? text;
  final VoidCallback? ontab;
  final Color? backgroundColor;
  final Color? textColor;
  final Widget? child;
  final bool? isActive;
  final double? width;
  final double? height;
  final double? padding;

  const AppCustomButton({
    super.key,
    this.width,
    this.padding,
    this.height,
    this.text,
    this.ontab,
    this.backgroundColor,
    this.textColor,
    this.child,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    var colorScheme = ThemeData().colorScheme;
    var textTheme = ThemeData().textTheme;

    return InkWell(
      onTap: ontab,
      child: Container(
        width: width,
        height: height,
        padding: padding != null
            ? EdgeInsets.all(padding!)
            : EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isActive!
              ? colorScheme.primary
              : backgroundColor ?? colorScheme.secondary,
          borderRadius: BorderRadius.circular(10),
        ),
        constraints: const BoxConstraints(minWidth: 0, minHeight: 0),
        child:
            child ?? Text(text ?? '', style: textTheme.bodyMedium!.copyWith()),
      ),
    );
  }
}
