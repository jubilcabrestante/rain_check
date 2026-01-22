import 'package:flutter/material.dart';

class KeyboardDismisser extends StatelessWidget {
  const KeyboardDismisser({
    super.key,
    required this.child,
    this.onDismiss,
  });

  final Widget child;
  final Function()? onDismiss;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusNode currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus && currentFocus.hasFocus) {
          onDismiss?.call();
          FocusManager.instance.primaryFocus?.unfocus();
        }
      },
      child: child,
    );
  }
}
