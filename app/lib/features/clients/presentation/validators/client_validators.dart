import 'package:app/core/domain/phone.dart';

abstract final class ClientValidators {
  static final _emailPattern = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
  static final _statePattern = RegExp(r'^[A-Za-z]{2}$');
  static final _zipPattern = RegExp(r'^\d{5}(-\d{4})?$');

  static String? name(String? value) {
    final trimmed = value?.trim() ?? '';
    if (trimmed.isEmpty || trimmed.length > 120) {
      return "Enter the client's name.";
    }
    return null;
  }

  static String? contact({String? phone, String? email}) {
    if (_isBlank(phone) && _isBlank(email)) {
      return 'Add a phone number or an email.';
    }
    return null;
  }

  static String? email(String? value) {
    if (_isBlank(value)) return null;
    if (!_emailPattern.hasMatch(value!.trim())) {
      return 'Enter a valid email address.';
    }
    return null;
  }

  static String? phone(String? value) {
    if (_isBlank(value)) return null;
    if (!Phone.isValidUs(value)) {
      return 'Enter a 10-digit phone number.';
    }
    return null;
  }

  static String? address({
    String? street,
    String? city,
    String? state,
    String? zip,
  }) {
    final fields = [street, city, state, zip];
    final filled = fields.where((f) => !_isBlank(f)).length;
    if (filled == 0 || filled == 4) return null;
    return 'Complete the address or leave it all blank.';
  }

  static String? state(String? value) {
    if (_isBlank(value)) return null;
    if (!_statePattern.hasMatch(value!.trim())) {
      return 'Use the 2-letter state, e.g. MD.';
    }
    return null;
  }

  static String? zip(String? value) {
    if (_isBlank(value)) return null;
    if (!_zipPattern.hasMatch(value!.trim())) {
      return 'Enter a 5-digit ZIP.';
    }
    return null;
  }

  static bool _isBlank(String? value) => value == null || value.trim().isEmpty;
}
