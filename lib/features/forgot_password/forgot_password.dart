import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_icon_snackbar/flutter_icon_snackbar.dart';
import 'package:gap/gap.dart';
import 'package:rain_check/app/themes/colors.dart';
import 'package:rain_check/core/domain/cubit/auth_user_cubit.dart';
import 'package:rain_check/core/shared/app_custom_button.dart';
import 'package:rain_check/core/shared/app_custom_label.dart';
import 'package:rain_check/core/shared/app_custom_textfield.dart';
import 'package:rain_check/core/utils/snack_bar.dart';
import 'package:rain_check/features/login/login.dart';

@RoutePage()
class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authUserCubit = context.read<AuthUserCubit>();

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 40,
        backgroundColor: AppColors.background,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: BlocConsumer<AuthUserCubit, AuthUserState>(
        listener: (context, state) {
          if (state.status == AuthStatus.passwordResetSent) {
            showSnackBar(
              context,
              message: "Password reset email sent. Please check your inbox.",
              type: SnackBarType.success,
            );
          }
        },
        builder: (context, state) {
          return SafeArea(
            child: Stack(
              children: [
                // Main content
                SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      HeaderTitle(
                        title: 'Forgot Password?',
                        subtitle:
                            'Enter your email to receive a password reset link for your account.',
                      ),
                      Gap(24),
                      Label(label: 'Email'),
                      Gap(8),
                      AppCustomTextField(
                        hintText: "raincheck@example.com",
                        controller: _emailController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          }
                          return null;
                        },
                      ),
                      Gap(32),
                      AppElevatedButton(
                        text: "Send Reset Link",
                        isLoading: state.status == AuthStatus.loading,
                        onPressed: () {
                          authUserCubit.forgotPassword(_emailController.text);
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
