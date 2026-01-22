import 'package:flutter/material.dart';
import 'package:flutter_icon_snackbar/flutter_icon_snackbar.dart';

Future<void> showSnackBar(
  BuildContext context, {
  required String message,
  required SnackBarType type,
}) async {
  return IconSnackBar.show(
    context,
    snackBarType: type,
    maxLines: 3,
    label: message,
  );
}
