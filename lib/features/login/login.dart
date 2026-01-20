import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:rain_check/app/router/router.gr.dart';
import 'package:rain_check/core/shared/app_custom_button.dart';
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
  bool _isPasswordVisible = false;

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
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isDesktop = constraints.maxWidth >= 900;
            final isTablet = constraints.maxWidth >= 600;

            final maxWidth = isDesktop
                ? 420.0
                : isTablet
                ? 480.0
                : double.infinity;

            final horizontalPadding = isDesktop ? 0.0 : 24.0;

            return Center(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: horizontalPadding,
                  vertical: 24,
                ),
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: maxWidth),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Gap(isDesktop ? 40 : 24),

                      // Logo
                      const Center(
                        child: CircleAvatar(
                          radius: 60,
                          backgroundColor: Colors.white,
                          child: Icon(
                            Icons.cloud,
                            size: 60,
                            color: Color(0xFF5B9FD8),
                          ),
                        ),
                      ),
                      const Gap(24),

                      // Title
                      const Center(
                        child: Column(
                          children: [
                            Text(
                              'Rain Check',
                              style: TextStyle(
                                fontSize: 36,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1A1F36),
                              ),
                            ),
                            Gap(8),
                            Text(
                              'Elevate your daily planning',
                              style: TextStyle(
                                fontSize: 16,
                                color: Color(0xFF8B94A8),
                              ),
                            ),
                          ],
                        ),
                      ),

                      Gap(isDesktop ? 48 : 32),

                      // Email
                      AppTextFormField(
                        controller: _emailController,
                        hintText: 'hello@raincheck.com',
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Email is required';
                          }
                          if (!value.contains('@')) {
                            return 'Enter a valid email';
                          }
                          return null;
                        },
                      ),

                      const Gap(16),

                      // Password
                      AppTextFormField(
                        controller: _passwordController,
                        hintText: '••••••••',
                        isPassword: true,
                        isShowPassword: _isPasswordVisible,
                        textInputAction: TextInputAction.done,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Password is required';
                          }
                          if (value.length < 6) {
                            return 'Password must be at least 6 characters';
                          }
                          return null;
                        },
                        onPressed: (value) {
                          setState(() {
                            _isPasswordVisible = value;
                          });
                        },
                      ),

                      const Gap(12),

                      // Forgot password
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {},
                          child: const Text(
                            'Forgot Password?',
                            style: TextStyle(
                              color: Color(0xFF5B9FD8),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),

                      const Gap(24),

                      // Sign in
                      AppElevatedButton(
                        text: 'Sign In',
                        // TODO: implement Sign In with email and password
                        onPressed: () {
                          context.router.push(const MainAppRoute());
                        },
                      ),

                      const Gap(32),

                      // Divider
                      Row(
                        children: const [
                          Expanded(child: Divider(color: Color(0xFFE1E5EB))),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            child: Text(
                              'OR',
                              style: TextStyle(
                                color: Color(0xFF8B94A8),
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Expanded(child: Divider(color: Color(0xFFE1E5EB))),
                        ],
                      ),

                      const Gap(32),

                      // Google
                      AppElevatedButton(
                        text: 'Google Sign In',
                        // TODO: implement Google Sign In
                        onPressed: () {},
                      ),

                      const Gap(16),

                      // Phone
                      AppElevatedButton(
                        text: 'Continue with Phone',
                        // TODO: implement Phone Sign In
                        onPressed: () {},
                      ),

                      const Gap(32),

                      // Create account
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'New to Rain Check? ',
                            style: TextStyle(color: Color(0xFF8B94A8)),
                          ),
                          TextButton(
                            onPressed: () {},
                            child: const Text(
                              'Create Account',
                              style: TextStyle(
                                color: Color(0xFF5B9FD8),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
