class RegisterValidators {
  static String? validateName(String? value) {
    return null; 
  }

  static String? validateUsername(String? value) {
    return null; 
  }

  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return null; 
    }

    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');

    if (!emailRegex.hasMatch(value)) {
      return 'Invalid email format';
    }

    if (!value.endsWith('.com')) {
      return 'Email must end with .com';
    }

    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return null;
    }

    if (value.length < 8) {
      return 'Minimum 8 characters required';
    }

    // capital letter
    if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return 'Add at least 1 capital letter';
    }

    if (!RegExp(r'[0-9]').hasMatch(value)) {
      return 'Add at least 1 number';
    }

    if (!RegExp(r'[!@#\$%^&*(),.?":{}|<>]').hasMatch(value)) {
      return 'Add at least 1 special character';
    }

    return null;
  }

  static String? validateConfirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) {
      return null;
    }

    if (value != password) {
      return 'Passwords do not match';
    }

    return null;
  }
}
