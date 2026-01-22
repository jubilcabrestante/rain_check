import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:rain_check/app/router/router.gr.dart';
import 'package:rain_check/core/shared/app_custom_button.dart';
import 'package:rain_check/core/shared/app_custom_label.dart';
import 'package:rain_check/core/shared/app_custom_textfield.dart';
import 'package:rain_check/app/themes/colors.dart';
import 'package:rain_check/gen/assets.gen.dart';

@RoutePage()
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final emailNode = FocusNode();
  final passwordNode = FocusNode();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    emailNode.dispose();
    passwordNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Logo
                  Center(
                    child: Container(
                      width: 75,
                      height: 75,
                      decoration: BoxDecoration(
                        color: AppColors.textWhite,
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Image.asset(Assets.images.logoBlue.path),
                    ),
                  ),
                  const Gap(12),

                  // LoginTitle
                  LoginTitle(),
                  const Gap(24),

                  // Email
                  const Label(label: "Email"),
                  const Gap(8),
                  AppCustomTextField(
                    controller: _emailController,
                    hintText: 'hello@raincheck.com',
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const Gap(16),

                  // Password
                  const Label(label: "Password"),
                  const Gap(8),
                  AppCustomTextField(
                    controller: _passwordController,
                    hintText: 'Enter your password',
                    isPassword: true,
                  ),

                  // Forgot password
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {},
                      child: const Text(
                        'Forgot Password?',
                        style: TextStyle(
                          color: Color(0xFF5B9FD8),
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  const Gap(24),

                  // Sign in
                  AppElevatedButton(
                    text: 'Sign In',
                    color: AppColors.primary,
                    textStyle: const TextStyle(
                      color: AppColors.textWhite,
                      fontWeight: FontWeight.w600,
                    ),
                    onPressed: () {
                      context.router.push(const MainAppRoute());
                    },
                  ),
                  const Gap(32),

                  // Divider
                  SignInDivider(),
                  const Gap(32),

                  // Google Sign In
                  AppElevatedButton(
                    text: 'Continue with Google',
                    icon: Image.asset(
                      Assets.images.google.path,
                      width: 20,
                      height: 20,
                    ),
                    onPressed: () {},
                  ),
                  const Gap(16),

                  // Phone Number
                  AppElevatedButton(
                    text: 'Phone Number',
                    icon: const Icon(Icons.phone),
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
                        onPressed: () {
                          context.router.push(const SignupRoute());
                        },
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
        ),
      ),
    );
  }
}

class LoginTitle extends StatelessWidget {
  const LoginTitle({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Center(
      child: Column(
        children: [
          Text(
            'Rain Check',
            style: textTheme.titleLarge?.copyWith(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: AppColors.textBlack,
            ),
          ),
          const Gap(4),
          const Text(
            'Elevate your daily planning',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: AppColors.textGrey,
            ),
          ),
        ],
      ),
    );
  }
}

class SignInDivider extends StatelessWidget {
  const SignInDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
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
    );
  }
}
