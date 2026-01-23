import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:rain_check/app/themes/colors.dart';
import 'package:rain_check/core/shared/app_custom_button.dart';
import 'package:rain_check/core/shared/app_custom_label.dart';
import 'package:rain_check/core/shared/app_custom_textfield.dart';
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
      body: SafeArea(
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
                    onPressed: () {
                      // Handle send reset link action
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
