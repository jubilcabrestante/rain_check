import 'package:rain_check/core/utils/disposal_email.dart';

class EmailValidator {
  const EmailValidator._();

  static bool isValidEmail(String email) {
    return !Disposable.emails.any((domain) => email.contains(domain)) &&
        RegExp(
          r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$',
        ).hasMatch(email.trim());
  }

  // // returns an error message if invalid
  // static String? validate(
  //   String? value, {
  //   String fieldName = App.emailAddress,
  // }) {
  //   if (value == null || value.isEmpty || value.trim().isEmpty) {
  //     return '$fieldName cannot be empty';
  //   }

  //   if (!isValidEmail(value.trim())) {
  //     return '$fieldName format is incorrect';
  //   }

  //   return null;
  // }
}
