import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:rain_check/app/router/router.gr.dart';
import 'package:rain_check/core/domain/cubit/auth_user_cubit.dart';
import 'package:rain_check/core/shared/app_custom_button.dart';
import 'package:rain_check/core/shared/app_custom_label.dart';
import 'package:rain_check/core/shared/app_custom_textfield.dart';
import 'package:rain_check/app/themes/colors.dart';
import 'package:rain_check/core/utils/keyboard_dismisser.dart';
import 'package:rain_check/gen/assets.gen.dart';

@RoutePage()
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  List<TextEditingController> _textControllers = [];

  @override
  void initState() {
    super.initState();
    _textControllers = List.generate(2, (index) => TextEditingController());
    // _textControllers[0].addListener(_validateEmail);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: BlocConsumer<AuthUserCubit, AuthUserState>(
          listener: (context, state) {
            // Clear any previous errors
            // if (state.status == AuthStatus.loading ||
            //     state.status == AuthStatus.googleSignInLoading) {
            //   // Optionally show loading
            //   return;
            // }

            // Handle errors
            if (state.status == AuthStatus.error && state.message != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message!),
                  backgroundColor: Colors.red,
                  duration: const Duration(seconds: 3),
                ),
              );
              return;
            }

            // ✅ Navigate ONLY when authenticated
            if (state.status == AuthStatus.authenticated &&
                state.currentUser != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Welcome, ${state.currentUser!.fullName}!'),
                  backgroundColor: Colors.green,
                  duration: const Duration(seconds: 2),
                ),
              );

              // Navigate after a short delay
              Future.delayed(const Duration(milliseconds: 500), () {
                if (context.mounted) {
                  context.router.replaceAll([MainAppRoute()]);
                }
              });
            }

            // Handle password reset
            if (state.status == AuthStatus.passwordResetSent &&
                state.message != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message!),
                  backgroundColor: Colors.blue,
                ),
              );
            }
          },
          builder: (context, state) {
            final authUserCubit = context.read<AuthUserCubit>();
            return KeyboardDismisser(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 24,
                  ),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 400),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Logo

                          // HeaderTitle
                          HeaderTitle(
                            title: 'Rain Check',
                            subtitle: 'Plan your day, the smart way',
                          ),
                          const Gap(24),

                          // Email
                          const Label(label: "Email"),
                          const Gap(8),
                          AppCustomTextField(
                            controller: _textControllers[0],
                            hintText: 'hello@raincheck.com',
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your email';
                              }
                              if (!RegExp(
                                r'^[^@]+@[^@]+\.[^@]+',
                              ).hasMatch(value)) {
                                return 'Please enter a valid email';
                              }
                              return null;
                            },
                          ),
                          const Gap(16),

                          // Password
                          const Label(label: "Password"),
                          const Gap(8),
                          AppCustomTextField(
                            controller: _textControllers[1],
                            hintText: 'Enter your password',
                            isPassword: true,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your password';
                              }
                              if (value.length < 6) {
                                return 'Password must be at least 6 characters';
                              }
                              return null;
                            },
                          ),

                          // Forgot password
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () {
                                context.router.push(
                                  const ForgotPasswordRoute(),
                                );
                              },
                              child: const Text(
                                'Forgot Password?',
                                style: TextStyle(color: Color(0xFF5B9FD8)),
                              ),
                            ),
                          ),
                          const Gap(24),

                          // Sign in
                          // Sign in
                          AppElevatedButton(
                            text: 'Sign In',
                            color: AppColors.primary,
                            textColor: AppColors.textWhite,
                            isLoading: state.status == AuthStatus.loading,
                            onPressed: state.status == AuthStatus.loading
                                ? null
                                : () {
                                    if (_formKey.currentState!.validate()) {
                                      authUserCubit.login(
                                        email: _textControllers[0].text,
                                        password: _textControllers[1].text,
                                      );
                                      // ✅ Don't navigate here! Let the listener handle it
                                    }
                                  },
                          ),
                          const Gap(32),

                          // Divider
                          SignInDivider(),
                          const Gap(32),

                          // Google Sign In
                          AppElevatedButton(
                            text: 'Continue with Google',
                            textColor: AppColors.textBlack,
                            color: AppColors.textWhite,
                            icon: Image.asset(
                              Assets.images.google.path,
                              width: 20,
                              height: 20,
                            ),
                            isLoading:
                                state.status == AuthStatus.googleSignInLoading,
                            onPressed:
                                state.status == AuthStatus.googleSignInLoading
                                ? null
                                : () {
                                    authUserCubit.signInWithGoogle();
                                  },
                          ),
                          const Gap(16),

                          // Phone Number
                          AppElevatedButton(
                            text: 'Phone Number',
                            icon: const Icon(Icons.phone),
                            textColor: AppColors.textBlack,
                            color: AppColors.textWhite,
                            onPressed: () {
                              context.router.push(InputNumberRoute());
                            },
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
          },
        ),
      ),
    );
  }
}

class HeaderTitle extends StatefulWidget {
  final String title;
  final String subtitle;
  const HeaderTitle({super.key, required this.title, required this.subtitle});

  @override
  State<HeaderTitle> createState() => _HeaderTitleState();
}

class _HeaderTitleState extends State<HeaderTitle> {
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Center(
      child: Column(
        children: [
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
          Text(
            // 'Rain Check',
            widget.title,
            style: textTheme.titleLarge?.copyWith(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.textBlack,
            ),
          ),
          const Gap(8),
          Text(
            // 'Elevate your daily planning',
            widget.subtitle,
            textAlign: TextAlign.center,
            style: const TextStyle(
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
