abstract final class ProjectValidators {
  static final _statePattern = RegExp(r'^[A-Za-z]{2}$');
  static final _zipPattern = RegExp(r'^\d{5}(-\d{4})?$');

  static String? client(Object? value) {
    if (value == null) return 'Choose a client or add a new one.';
    return null;
  }

  static String? street(String? value) {
    if (_isBlank(value)) return 'Enter the site address.';
    return null;
  }

  static String? city(String? value) {
    if (_isBlank(value)) return 'Enter the site address.';
    return null;
  }

  static String? state(String? value) {
    if (_isBlank(value) || !_statePattern.hasMatch(value!.trim())) {
      return 'Use the 2-letter state, e.g. MD.';
    }
    return null;
  }

  static String? zip(String? value) {
    if (_isBlank(value) || !_zipPattern.hasMatch(value!.trim())) {
      return 'Enter a 5-digit ZIP.';
    }
    return null;
  }

  static String? title(String? value) {
    final trimmed = value?.trim() ?? '';
    if (trimmed.isEmpty || trimmed.length > 120) {
      return 'Enter a project title.';
    }
    return null;
  }

  static bool _isBlank(String? value) => value == null || value.trim().isEmpty;
}
