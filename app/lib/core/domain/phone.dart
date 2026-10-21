abstract final class Phone {
  static final _digits = RegExp(r'\D');

  /// US numbers to E.164 (`+1` + 10 digits). Empty input becomes null.
  static String? normalize(String? input) {
    if (input == null) return null;
    final digits = input.replaceAll(_digits, '');
    if (digits.isEmpty) return null;
    if (digits.length == 10) return '+1$digits';
    if (digits.length == 11 && digits.startsWith('1')) return '+$digits';
    return '+$digits';
  }

  /// 10 US digits after stripping formatting, allowing a leading 1.
  static bool isValidUs(String? input) {
    if (input == null) return false;
    final digits = input.replaceAll(_digits, '');
    if (digits.length == 10) return true;
    return digits.length == 11 && digits.startsWith('1');
  }

  /// E.164 (or any digit string) back to `(301) 555-0123`.
  static String format(String value) {
    final digits = value.replaceAll(_digits, '');
    final national = digits.length == 11 && digits.startsWith('1')
        ? digits.substring(1)
        : digits;
    if (national.length != 10) return value;
    return '(${national.substring(0, 3)}) ${national.substring(3, 6)}-${national.substring(6)}';
  }

  /// Formats a partial digit string as the user types.
  static String formatPartial(String digits) {
    var d = digits.replaceAll(_digits, '');
    if (d.length > 11) d = d.substring(0, 11);

    final hasCountry = d.startsWith('1') && d.length > 1;
    final national = hasCountry ? d.substring(1) : d;
    final local = _formatNational(national);
    if (local.isEmpty) return hasCountry ? '1' : '';
    return hasCountry ? '1 $local' : local;
  }

  static String _formatNational(String national) {
    if (national.isEmpty) return '';
    if (national.length <= 3) return '($national';
    if (national.length <= 6) {
      return '(${national.substring(0, 3)}) ${national.substring(3)}';
    }
    final rest = national.length > 10 ? national.substring(0, 10) : national;
    return '(${rest.substring(0, 3)}) ${rest.substring(3, 6)}-${rest.substring(6)}';
  }
}
