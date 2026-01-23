import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:rain_check/app/router/router.gr.dart';
import 'package:rain_check/core/domain/cubit/auth_user_cubit.dart';
import 'package:rain_check/core/shared/app_custom_button.dart';
import 'package:rain_check/core/shared/app_custom_label.dart';
import 'package:rain_check/core/shared/app_custom_textfield.dart';
import 'package:rain_check/features/login/login.dart';

@RoutePage()
class InputUserScreen extends StatefulWidget {
  final String phoneNumber;
  const InputUserScreen({super.key, required this.phoneNumber});

  @override
  State<InputUserScreen> createState() => _InputUserScreenState();
}

class _InputUserScreenState extends State<InputUserScreen> {
  List<TextEditingController> _textControllers = [];
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _textControllers = List.generate(2, (index) => TextEditingController());
    // _textControllers[0].addListener(_validateEmail);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: BlocConsumer<AuthUserCubit, AuthUserState>(
                listener: (context, state) {
                  // TODO: implement listener
                },
                builder: (context, state) {
                  return Column(
                    children: [
                      Gap(32),
                      HeaderTitle(
                        title: "Fill up the form",
                        subtitle: 'Please provide your details to continue.',
                      ),
                      Gap(24),
                      Label(label: "Full Name"),
                      Gap(8),
                      AppCustomTextField(
                        controller: _textControllers[0],
                        hintText: "Enter your full name",
                      ),
                      Gap(16),
                      // TODO: Implement profile image upload
                      // Label(label: "Email Address"),
                      // Gap(8),
                      // AppCustomTextField(
                      //   controller: _textControllers[1],
                      //   hintText: "Enter your email address",
                      // ),
                      Gap(24),
                      AppElevatedButton(
                        text: "Continue",
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            // Navigate to the next screen with phone number
                            context.router.push(MainAppRoute());
                          }
                        },
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
