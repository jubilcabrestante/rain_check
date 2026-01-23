import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_icon_snackbar/flutter_icon_snackbar.dart';
import 'package:gap/gap.dart';
import 'package:rain_check/app/router/router.gr.dart';
import 'package:rain_check/app/themes/colors.dart';
import 'package:rain_check/core/domain/cubit/auth_user_cubit.dart';
import 'package:rain_check/core/shared/app_custom_button.dart';
import 'package:rain_check/core/shared/app_custom_label.dart';
import 'package:rain_check/core/shared/app_custom_textfield.dart';
import 'package:rain_check/core/utils/keyboard_dismisser.dart';
import 'package:rain_check/core/utils/snack_bar.dart';
import 'package:rain_check/core/utils/validators.dart';
import 'package:rain_check/features/login/login.dart';

@RoutePage()
class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  List<TextEditingController> _textControllers = [];

  @override
  void initState() {
    super.initState();
    _textControllers = List.generate(3, (index) => TextEditingController());
    // _textControllers[0].addListener(_validateEmail);
  }

  @override
  Widget build(BuildContext context) {
    final authUserCubit = context.read<AuthUserCubit>();

    return Scaffold(
      body: SafeArea(
        child: KeyboardDismisser(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: BlocConsumer<AuthUserCubit, AuthUserState>(
              listener: (context, state) {
                // TODO: implement listener
                // successfull
                if (state.status == AuthStatus.success) {
                  showSnackBar(
                    context,
                    message: "Success creating an account",
                    type: SnackBarType.success,
                  );

                  for (var controller in _textControllers) {
                    controller.clear();
                  }

                  context.router.popAndPush(LoginRoute());
                }

                // error
                if (state.status == AuthStatus.error) {
                  showSnackBar(
                    context,
                    message: state.message!,
                    type: SnackBarType.fail,
                  );
                }
              },
              builder: (context, state) {
                return Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      HeaderTitle(
                        title: 'Join Rain Check',
                        subtitle:
                            'Stay ahead of the weather and plan your day with confidence.',
                      ),

                      const Gap(24),

                      const Label(label: "Full Name"),
                      const Gap(8),
                      AppCustomTextField(
                        controller: _textControllers[0],
                        textInputAction: TextInputAction.next,
                        hintText: 'Enter your name',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your name';
                          }
                          return null;
                        },
                      ),

                      const Gap(16),

                      const Label(label: "Email"),
                      const Gap(8),
                      AppCustomTextField(
                        textInputAction: TextInputAction.next,
                        controller: _textControllers[1],
                        hintText: 'Enter your email',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          }
                          if (!EmailValidator.isValidEmail(value)) {
                            return 'Please enter a valid email';
                          }
                          return null;
                        },
                      ),

                      const Gap(16),

                      const Label(label: "Password"),
                      const Gap(8),
                      AppCustomTextField(
                        textInputAction: TextInputAction.next,
                        controller: _textControllers[2],
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

                      const Gap(16),

                      const Label(label: "Confirm Password"),
                      const Gap(8),
                      AppCustomTextField(
                        textInputAction: TextInputAction.done,
                        hintText: 'Confirm your password',
                        isPassword: true,
                        validator: (value) {
                          if (value != _textControllers[2].text) {
                            return 'Passwords do not match';
                          }
                          return null;
                        },
                      ),
                      Gap(32),
                      AppElevatedButton(
                        text: "Create Account",
                        color: AppColors.primary,
                        isLoading: state.status == AuthStatus.loading,
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            // Process data.
                            authUserCubit.register(
                              fullName: _textControllers[0].text,
                              email: _textControllers[1].text,
                              password: _textControllers[2].text,
                            );
                          }
                        },
                      ),

                      Gap(16),
                      const Text(
                        'BY CONTINUING, YOU AGREE TO OUR TERMS OF SERVICE AND PRIVACY POLICY.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: AppColors.textGrey,
                        ),
                      ),
                      Gap(32),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Already have an account? ',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: AppColors.textGrey,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              context.router.pop();
                            },
                            child: const Text(
                              'Login',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
