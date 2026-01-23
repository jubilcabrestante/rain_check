enum AuthMode { changePassword, forgotPassword, changePin, forgotPin }

extension AuthModeExtension on AuthMode {
  String get confirmText {
    switch (this) {
      case AuthMode.forgotPassword:
        return "Confirm Password";
      case AuthMode.changePassword:
        return "Confirm Password";
      case AuthMode.changePin:
        return "Confirm PIN Code";
      case AuthMode.forgotPin:
        return "Confirm PIN Code";
    }
  }

  String get newCredentialText {
    switch (this) {
      case AuthMode.forgotPassword:
        return "New Password";
      case AuthMode.changePassword:
        return "New Password";
      case AuthMode.changePin:
        return "New PIN Code";
      case AuthMode.forgotPin:
        return "New PIN Code";
    }
  }

  String get screenTitle {
    switch (this) {
      case AuthMode.forgotPassword:
        return "Forgot Password";
      case AuthMode.changePassword:
        return "Change Password";
      case AuthMode.changePin:
        return "PIN Code";
      case AuthMode.forgotPin:
        return "Forgot PIN Code";
    }
  }
}
