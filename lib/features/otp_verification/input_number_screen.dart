import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_icon_snackbar/flutter_icon_snackbar.dart';
import 'package:gap/gap.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:rain_check/app/router/router.gr.dart';
import 'package:rain_check/app/themes/colors.dart';
import 'package:rain_check/core/shared/app_custom_button.dart';
import 'package:rain_check/core/utils/keyboard_dismisser.dart';
import 'package:rain_check/core/utils/snack_bar.dart';
import 'package:rain_check/features/login/login.dart';
import 'package:rain_check/features/otp_verification/domain/cubit/verification_cubit.dart';

@RoutePage()
class InputNumberScreen extends StatefulWidget {
  const InputNumberScreen({super.key});

  @override
  State<InputNumberScreen> createState() => _InputNumberScreenState();
}

class _InputNumberScreenState extends State<InputNumberScreen> {
  String mobileNumber = '';
  bool allowToContinue = false;
  late FocusNode focusNode;

  @override
  void initState() {
    super.initState();
    focusNode = FocusNode();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 40,
        backgroundColor: AppColors.background,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: BlocConsumer<VerificationCubit, VerificationState>(
          listener: (context, state) {
            // Handle errors
            if (state.status == VerificationStatus.error &&
                state.errorMessage != null) {
              showSnackBar(
                context,
                message: state.errorMessage!,
                type: SnackBarType.fail,
              );
              return;
            }

            // ✅ Navigate to PIN screen when OTP is sent
            if (state.status == VerificationStatus.otpSent) {
              showSnackBar(
                context,
                message: "OTP sent successfully",
                type: SnackBarType.success,
              );

              Future.delayed(const Duration(milliseconds: 800), () {
                if (context.mounted) {
                  context.router.push(InputPinRoute(phoneNumber: mobileNumber));
                }
              });
            }

            // ✅ Handle phone already linked
            if (state.status == VerificationStatus.phoneLinked) {
              showSnackBar(
                context,
                message: "Phone number verified automatically",
                type: SnackBarType.success,
              );

              Future.delayed(const Duration(milliseconds: 800), () {
                if (context.mounted) {
                  context.router.pushAndPopUntil(
                    MainAppRoute(),
                    predicate: (route) => false,
                  );
                }
              });
            }
          },
          builder: (context, state) {
            final isLoading = state.status == VerificationStatus.loading;

            return KeyboardDismisser(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: ListView(
                  children: [
                    const HeaderTitle(
                      title: "Verify your Phone",
                      subtitle:
                          "Please enter your details to receive a secure one time pin",
                    ),
                    const Gap(24),

                    // Phone Number Input Field
                    IntlPhoneField(
                      enabled: !isLoading,
                      autofocus: true,
                      focusNode: focusNode,
                      decoration: InputDecoration(
                        hintStyle: theme.textTheme.bodyMedium,
                        labelText: 'Phone Number',
                        border: const OutlineInputBorder(
                          borderSide: BorderSide(),
                          borderRadius: BorderRadius.all(Radius.circular(16)),
                        ),
                      ),
                      initialCountryCode: 'PH',
                      onChanged: (phone) {
                        final isComplete = phone.completeNumber.length == 13;

                        if (isComplete) {
                          focusNode.unfocus();
                          setState(() {
                            allowToContinue = true;
                            mobileNumber = phone.completeNumber;
                          });
                        } else if (allowToContinue) {
                          setState(() {
                            allowToContinue = false;
                          });
                        }
                      },
                    ),

                    const Gap(16),

                    // Continue Button
                    if (allowToContinue)
                      SizedBox(
                        width: double.infinity,
                        child: AppElevatedButton(
                          onPressed: isLoading
                              ? null
                              : () {
                                  context
                                      .read<VerificationCubit>()
                                      .sendOTPForSignIn(mobileNumber);
                                },
                          text: "CONTINUE",
                          isLoading: isLoading,
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
