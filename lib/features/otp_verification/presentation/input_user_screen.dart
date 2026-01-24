import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:rain_check/app/router/router.gr.dart';
import 'package:rain_check/app/themes/colors.dart';
import 'package:rain_check/core/shared/app_custom_button.dart';
import 'package:rain_check/core/shared/app_custom_label.dart';
import 'package:rain_check/core/shared/app_custom_textfield.dart';
import 'package:rain_check/core/utils/keyboard_dismisser.dart';
import 'package:rain_check/core/utils/snack_bar.dart';
import 'package:rain_check/features/login/login.dart';
import 'package:rain_check/features/otp_verification/domain/cubit/verification_cubit.dart';
import 'package:flutter_icon_snackbar/flutter_icon_snackbar.dart';

@RoutePage()
class InputUserScreen extends StatefulWidget {
  const InputUserScreen({super.key});

  @override
  State<InputUserScreen> createState() => _InputUserScreenState();
}

class _InputUserScreenState extends State<InputUserScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Complete Your Profile"),
        backgroundColor: AppColors.background,
        automaticallyImplyLeading: false, // Prevent going back
      ),
      body: SafeArea(
        child: BlocConsumer<VerificationCubit, VerificationState>(
          listener: (context, state) async {
            if (state.status == VerificationStatus.error &&
                state.errorMessage != null) {
              showSnackBar(
                context,
                message: state.errorMessage!,
                type: SnackBarType.fail,
              );
              return;
            }

            // ✅ Profile created successfully
            if (state.status == VerificationStatus.profileCreated) {
              showSnackBar(
                context,
                message: "Profile created successfully!",
                type: SnackBarType.success,
              );

              await Future.delayed(const Duration(seconds: 1));
              if (context.mounted) {
                context.router.pushAndPopUntil(
                  MainAppRoute(),
                  predicate: (route) => false,
                );
              }
            }
          },
          builder: (context, state) {
            final isLoading = state.status == VerificationStatus.loading;

            return KeyboardDismisser(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const HeaderTitle(
                        title: "Welcome!",
                        subtitle: "Please enter your details to continue",
                      ),

                      const Gap(32),

                      Text(
                        "Phone Number",
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                      const Gap(8),
                      Text(
                        state.phoneNumber!,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const Gap(24),
                      Label(label: "Full Name"),
                      Gap(8),
                      AppCustomTextField(
                        controller: _nameController,
                        hintText: "Enter your full name",
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter your name';
                          }
                          if (value.trim().length < 2) {
                            return 'Name must be at least 2 characters';
                          }
                          return null;
                        },
                      ),

                      const Gap(32),

                      AppElevatedButton(
                        text: "Continue",
                        isLoading: isLoading,
                        onPressed: isLoading
                            ? null
                            : () {
                                if (_formKey.currentState!.validate()) {
                                  context
                                      .read<VerificationCubit>()
                                      .createUserProfile(
                                        fullName: _nameController.text.trim(),
                                      );
                                }
                              },
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
