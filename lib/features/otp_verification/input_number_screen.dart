import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_icon_snackbar/flutter_icon_snackbar.dart';
import 'package:gap/gap.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:rain_check/app/router/router.gr.dart';
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
    focusNode = FocusNode();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      focusNode.requestFocus(); // Request focus after the widget tree is built
    });
    super.initState();
  }

  @override
  void dispose() {
    focusNode.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SafeArea(
        child: BlocConsumer<VerificationCubit, VerificationState>(
          listener: (context, state) async {
            if (state.errorMessage != null) {
              showSnackBar(
                context,
                message: state.errorMessage!,
                type: SnackBarType.fail,
              );
              return;
            }
            if (state.status == VerificationStatus.otpSent &&
                state.status != VerificationStatus.loading) {
              showSnackBar(
                context,
                message: "OTP Successfully Sent",
                type: SnackBarType.success,
              );
              await Future.delayed(const Duration(seconds: 2));
              if (context.mounted) {
                context.router.replace(
                  InputPinRoute(phoneNumber: mobileNumber),
                );
              }
            }
          },
          builder: (context, state) {
            return KeyboardDismisser(
              child: ListView(
                children: [
                  Gap(32),
                  HeaderTitle(
                    title: "Verify your Phone",
                    subtitle:
                        "Please enter your details to receive a secure one time pin",
                  ),
                  Gap(24),
                  // Phone Number Input Field
                  IntlPhoneField(
                    autofocus: true,
                    focusNode: focusNode,
                    decoration: InputDecoration(
                      hintStyle: theme.textTheme.bodyMedium,
                      labelText: 'Phone Number',
                      helperStyle: theme.textTheme.bodyMedium,
                      suffixStyle: theme.textTheme.bodyMedium,
                      labelStyle: theme.textTheme.bodyMedium,
                      floatingLabelStyle: theme.textTheme.bodyMedium,
                      border: const OutlineInputBorder(
                        borderSide: BorderSide(),
                        borderRadius: BorderRadius.all(Radius.circular(16)),
                      ),
                    ),
                    initialCountryCode: 'PH',
                    onChanged: (phone) {
                      var bool = phone.completeNumber.length < 13;
                      if (phone.completeNumber.length == 13) {
                        focusNode.unfocus();
                        return setState(() {
                          allowToContinue = true;
                          mobileNumber = phone.completeNumber;
                        });
                      }

                      if (bool && allowToContinue) {
                        setState(() {
                          allowToContinue = false;
                        });
                      }
                    },
                  ),
                  Visibility(
                    visible: allowToContinue,
                    child: SizedBox(
                      width: double.infinity,
                      child: AppElevatedButton(
                        onPressed: () {
                          context.read<VerificationCubit>().sendOTP(
                            mobileNumber,
                          );
                        },
                        text: "CONTINUE",
                        isLoading: state.status == VerificationStatus.loading,
                      ),
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
