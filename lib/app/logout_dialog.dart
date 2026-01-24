import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rain_check/app/router/router.gr.dart';
import 'package:rain_check/app/themes/colors.dart';
import 'package:rain_check/core/domain/cubit/auth_user_cubit.dart';
import 'package:rain_check/core/shared/app_custom_button.dart';

class LogoutDialog {
  static Future<void> show(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Logout'),
          content: const Text('Are you sure you want to logout?'),
          actions: [
            AppElevatedButton(
              color: AppColors.error,
              onPressed: () => Navigator.of(context).pop(),
              text: 'Cancel',
            ),
            TextButton(
              onPressed: () {
                // Call logout in AuthUserCubit
                context.read<AuthUserCubit>().logout();
                context.router.replaceAll([LoginRoute()]);
              },
              child: const Text(
                'Logout',
                style: TextStyle(color: AppColors.primary),
              ),
            ),
          ],
        );
      },
    );
  }
}
