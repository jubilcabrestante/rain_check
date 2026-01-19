import 'package:flutter/material.dart';

class AppCustomLoadingIndicator extends StatelessWidget {
  final double size;

  const AppCustomLoadingIndicator({super.key, this.size = 20.0});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CircularProgressIndicator(
        color: Theme.of(context).colorScheme.primary,
      ),
    );
  }
}
