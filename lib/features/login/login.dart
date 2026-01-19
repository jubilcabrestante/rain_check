import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:rain_check/app/router/router.gr.dart';
import 'package:rain_check/core/shared/app_custom_button.dart';
import 'package:rain_check/core/shared/app_custom_loading_indicator.dart';
import 'package:rain_check/core/shared/app_custom_textfield.dart';

@RoutePage()
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Gap(60),

              // Cloud Icon
              const Center(
                child: CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.cloud, size: 60, color: Color(0xFF5B9FD8)),
                ),
              ),
              const Gap(32),

              // Title & Subtitle
              const Center(
                child: Column(
                  children: [
                    Text(
                      'Rain Check',
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1A1F36),
                        letterSpacing: -0.5,
                      ),
                    ),
                    Gap(8),
                    Text(
                      'Elevate your daily planning',
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFF8B94A8),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              const Gap(48),

              // Email Field
              AppCustomTextfield(
                controller: _emailController,
                label: 'EMAIL',
                hintText: 'hello@raincheck.com',
                type: 'email',
              ),

              // Password Field
              AppCustomTextfield(
                controller: _passwordController,
                label: 'PASSWORD',
                hintText: '••••••••',
                isPassword: true,
              ),

              const Gap(16),

              // Forgot Password
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: const Text(
                    'Forgot Password?',
                    style: TextStyle(
                      color: Color(0xFF5B9FD8),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),

              const Gap(24),

              // Sign In Button
              // TODO: Implement sign-in functionality
              AppCustomButton(
                text: _isLoading ? null : 'Sign In',
                ontab: () {
                  context.router.push(const MainAppRoute());
                },
                backgroundColor: const Color(0xFF5DBAEC),
                textColor: Colors.white,
                height: 52,
                child: _isLoading
                    ? const AppCustomLoadingIndicator(size: 20)
                    : null,
              ),

              const Gap(32),

              // OR Divider
              Row(
                children: [
                  Expanded(
                    child: Container(height: 1, color: const Color(0xFFE1E5EB)),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'OR',
                      style: TextStyle(
                        color: Color(0xFF8B94A8),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(height: 1, color: const Color(0xFFE1E5EB)),
                  ),
                ],
              ),

              const Gap(32),

              // Google Sign In
              AppCustomButton(
                // TODO: Implement Google sign-in functionality
                ontab: () {},
                backgroundColor: Colors.white,
                height: 52,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.network(
                      'https://www.gstatic.com/firebasejs/ui/2.0.0/images/auth/google.svg',
                      height: 20,
                      width: 20,
                    ),
                    const Gap(8),
                    const Text('Continue with Google'),
                  ],
                ),
              ),

              const Gap(16),

              // Phone Sign In
              AppCustomButton(
                // TODO: Implement phone sign-in functionality
                ontab: () {},
                backgroundColor: Colors.white,
                height: 52,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(
                      Icons.phone_android,
                      color: Color(0xFF5B9FD8),
                      size: 20,
                    ),
                    Gap(8),
                    Text('Phone Number'),
                  ],
                ),
              ),

              const Gap(40),

              // Create Account
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'New to Rain Check?  ',
                    style: TextStyle(color: Color(0xFF8B94A8), fontSize: 14),
                  ),
                  TextButton(
                    onPressed: () {},
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: const Text(
                      'Create Account',
                      style: TextStyle(
                        color: Color(0xFF5B9FD8),
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),

              const Gap(40),
            ],
          ),
        ),
      ),
    );
  }
}
