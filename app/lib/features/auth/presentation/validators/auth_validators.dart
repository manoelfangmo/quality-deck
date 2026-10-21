abstract final class AuthValidators {
  static final _emailPattern = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

  static String? name(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Enter your name.';
    }
    return null;
  }

  static String? email(String? value) {
    final trimmed = value?.trim() ?? '';
    if (trimmed.isEmpty) return 'Enter your email.';
    if (!_emailPattern.hasMatch(trimmed)) return 'Enter a valid email.';
    return null;
  }

  static String? password(String? value) {
    if (value == null || value.length < 8) {
      return 'Password must be at least 8 characters.';
    }
    return null;
  }
}
