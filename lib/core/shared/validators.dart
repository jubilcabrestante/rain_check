class Validators {
  static String? validateField(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return '$fieldName is required';
    }

    if (fieldName == 'Email' &&
        !RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
      return 'Enter a valid email';
    }

    if (fieldName == 'Password') {
      // Check if password is at least 8 characters long
      if (value.length < 8) {
        return 'Password must be at least 8 characters';
      }

      // Check for uppercase letters
      if (!value.contains(RegExp(r'[A-Z]'))) {
        return 'Password must contain at least one uppercase letter';
      }

      // Check for lowercase letters
      if (!value.contains(RegExp(r'[a-z]'))) {
        return 'Password must contain at least one lowercase letter';
      }

      // Check for digits
      if (!value.contains(RegExp(r'[0-9]'))) {
        return 'Password must contain at least one digit';
      }

      // Check for special characters
      if (!value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
        return 'Password must contain at least one special character';
      }
    }

    return null; // Return null if all validations pass
  }

  static String? validateDropdown(dynamic value, String fieldName) {
    return value == null ? '$fieldName selection is required' : null;
  }
}
