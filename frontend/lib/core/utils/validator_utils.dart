class ValidatorUtils {
  ValidatorUtils._();

  static String? required(String? value, {String fieldName = 'This field'}) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }

    return null;
  }

  static String? name(String? value) {
    final error = required(value, fieldName: 'Name');

    if (error != null) {
      return error;
    }

    if (value!.trim().length < 2) {
      return 'Name must be at least 2 characters';
    }

    return null;
  }

  static String? email(String? value) {
    final error = required(value, fieldName: 'Email');

    if (error != null) {
      return error;
    }

    final email = value!.trim();

    final emailRegex = RegExp(r'^[\w.-]+@([\w-]+\.)+[\w-]{2,}$');

    if (!emailRegex.hasMatch(email)) {
      return 'Enter a valid email address';
    }

    return null;
  }

  static String? password(String? value) {
    final error = required(value, fieldName: 'Password');

    if (error != null) {
      return error;
    }

    if (value!.length < 6) {
      return 'Password must be at least 8 characters';
    }

    return null;
  }

  static String? confirmPassword(String? value, String password) {
    final error = required(value, fieldName: 'Confirm password');

    if (error != null) {
      return error;
    }

    if (value != password) {
      return 'Passwords do not match';
    }

    return null;
  }
}
