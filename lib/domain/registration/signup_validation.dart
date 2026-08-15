class SignupValidation {
  static final RegExp _emailRegex = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );

  static String? validateName(String? value) {
    return (value ?? '').trim().isEmpty ? 'Name is required' : null;
  }

  static String? validateEmail(String? value) {
    final trimmed = (value ?? '').trim();
    if (trimmed.isEmpty) return 'Email is required';
    if (!_emailRegex.hasMatch(trimmed)) return 'Enter a valid email';
    return null;
  }

  static String? validatePhone(String? value) {
    final digits = (value ?? '').replaceAll(RegExp(r'\D'), '');
    if (digits.isEmpty) return 'Phone number is required';
    if (digits.length < 7) return 'Enter a valid phone number';
    return null;
  }

  static String? validateRequired(Object? value, String label) {
    return value == null ? '$label is required' : null;
  }

  static String? validatePrivacy(bool value) {
    return value ? null : 'Privacy acknowledgement is required';
  }
}
