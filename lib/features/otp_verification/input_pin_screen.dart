import 'dart:async';
import 'dart:developer';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_icon_snackbar/flutter_icon_snackbar.dart';
import 'package:gap/gap.dart';
import 'package:pinput/pinput.dart';
import 'package:rain_check/app/router/router.gr.dart';
import 'package:rain_check/app/themes/colors.dart';
import 'package:rain_check/core/utils/snack_bar.dart';
import 'package:rain_check/features/login/login.dart';
import 'package:rain_check/features/otp_verification/domain/cubit/verification_cubit.dart';

@RoutePage()
class InputPinScreen extends StatefulWidget {
  final String phoneNumber;
  const InputPinScreen({super.key, required this.phoneNumber});

  @override
  State<InputPinScreen> createState() => _InputPinScreenState();
}

class _InputPinScreenState extends State<InputPinScreen> {
  final _pinController = TextEditingController();
  final _focusNode = FocusNode();

  late Timer _timer;
  int _secondsRemaining = 120;
  bool _canResend = false;

  @override
  void initState() {
    super.initState();
    _focusNode;
    _pinController;
    if (widget.phoneNumber.isNotEmpty) {
      _startTimer();
    }
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _timer.cancel();
    _pinController.dispose();
    super.dispose();
  }

  void _startTimer() {
    setState(() {
      _canResend = false;
      _secondsRemaining = 120;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() {
          _secondsRemaining--;
        });
      } else {
        setState(() {
          _canResend = true;
        });
        _timer.cancel();
      }
    });
  }

  void _resendOtp() {
    log("Resend OTP clicked");
    _startTimer();
  }

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: const TextStyle(
        fontSize: 20,
        color: Color.fromRGBO(30, 60, 87, 1),
        fontWeight: FontWeight.w600,
      ),
      decoration: BoxDecoration(
        border: Border.all(color: const Color.fromRGBO(234, 239, 243, 1)),
        borderRadius: BorderRadius.circular(20),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: const Color.fromRGBO(114, 178, 238, 1)),
      borderRadius: BorderRadius.circular(8),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration?.copyWith(
        color: const Color.fromRGBO(234, 239, 243, 1),
      ),
    );

    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Enter OTP"),
        backgroundColor: AppColors.background,
      ),
      body: SafeArea(
        child: BlocConsumer<VerificationCubit, VerificationState>(
          listener: (context, state) async {
            // Handle errors
            if (state.status == VerificationStatus.error &&
                state.errorMessage != null) {
              _pinController.clear(); // Clear wrong PIN
              showSnackBar(
                context,
                message: state.errorMessage!,
                type: SnackBarType.fail,
              );
              return;
            }

            // Handle resend OTP success
            if (state.status == VerificationStatus.otpSent) {
              showSnackBar(
                context,
                message: "OTP Successfully Sent",
                type: SnackBarType.success,
              );
              _resendOtp(); // Restart timer
              return;
            }

            // Navigate for new user (need to create profile)
            if (state.status == VerificationStatus.verifiedNewUser) {
              showSnackBar(
                context,
                message: "Your mobile number is verified",
                type: SnackBarType.success,
              );

              await Future.delayed(const Duration(seconds: 1));
              if (context.mounted) {
                context.router.pushAndPopUntil(
                  InputUserRoute(phoneNumber: widget.phoneNumber),
                  predicate: (route) => false, // Remove all previous routes
                );
              }
            }

            // Navigate for existing user
            if (state.status == VerificationStatus.verifiedExistingUser) {
              showSnackBar(
                context,
                message: "Welcome back!",
                type: SnackBarType.success,
              );

              await Future.delayed(const Duration(seconds: 1));
              if (context.mounted) {
                context.router.pushAndPopUntil(
                  MainAppRoute(),
                  predicate: (route) => false, // Remove all previous routes
                );
              }
            }
          },
          builder: (context, state) {
            final verifyCubit = context.read<VerificationCubit>();
            final isVerifying = state.status == VerificationStatus.verifying;

            return Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  const HeaderTitle(
                    title: "Enter Verification Code",
                    subtitle: "We've sent a 6-digit code to your phone",
                  ),

                  const Gap(32),

                  // PIN Input
                  Pinput(
                    controller: _pinController,
                    focusNode: _focusNode,
                    length: 6,
                    defaultPinTheme: defaultPinTheme,
                    focusedPinTheme: focusedPinTheme,
                    submittedPinTheme: submittedPinTheme,
                    enabled: !isVerifying, // Disable during verification
                    // ✅ Auto-submit when 6 digits are entered
                    onCompleted: (pin) {
                      verifyCubit.verifyOTP(pin);
                    },

                    // Show error styling if verification failed
                    errorPinTheme: defaultPinTheme.copyWith(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.red),
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),

                    pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
                  ),

                  const Gap(24),

                  // Loading indicator or resend button
                  Center(
                    child: Builder(
                      builder: (context) {
                        if (isVerifying) {
                          return const CircularProgressIndicator.adaptive();
                        }

                        if (_canResend) {
                          return TextButton(
                            onPressed: () {
                              _pinController.clear();
                              verifyCubit.sendOTP(widget.phoneNumber);
                            },
                            child: Text(
                              "Resend OTP",
                              style: theme.textTheme.labelLarge?.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          );
                        }

                        return Text(
                          "Resend OTP in $_secondsRemaining seconds",
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: Colors.grey,
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
