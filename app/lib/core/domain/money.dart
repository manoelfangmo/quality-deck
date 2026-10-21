class Money {
  const Money(this.cents);

  final int cents;

  static final _digits = RegExp(r'^\d+$');

  /// Parses dollars and cents. Accepts "4.5", "$4.50", and "1,250".
  /// Rejects a leading sign, non-numeric input, and more than two decimals.
  static Money? tryParse(String? input) {
    if (input == null) return null;
    var text = input.trim();
    if (text.isEmpty) return null;
    text = text.replaceAll(r'$', '').replaceAll(',', '').trim();
    if (text.isEmpty || text.startsWith('-') || text.startsWith('+')) {
      return null;
    }

    final parts = text.split('.');
    if (parts.length > 2) return null;
    final whole = parts[0];
    final fraction = parts.length == 2 ? parts[1] : '';
    if (whole.isEmpty || !_digits.hasMatch(whole)) return null;
    if (fraction.isNotEmpty && !_digits.hasMatch(fraction)) return null;
    if (fraction.length > 2) return null;

    final dollars = int.tryParse(whole);
    if (dollars == null) return null;
    final cents = int.parse(fraction.padRight(2, '0'));
    return Money(dollars * 100 + cents);
  }

  /// "$1,234.50"
  String format() {
    final sign = cents < 0 ? '-' : '';
    final absolute = cents.abs();
    final dollars = absolute ~/ 100;
    final remainder = absolute % 100;
    return '$sign\$${_withCommas(dollars)}.${remainder.toString().padLeft(2, '0')}';
  }

  static String _withCommas(int value) {
    final digits = value.toString();
    final buffer = StringBuffer();
    for (var i = 0; i < digits.length; i++) {
      if (i > 0 && (digits.length - i) % 3 == 0) buffer.write(',');
      buffer.write(digits[i]);
    }
    return buffer.toString();
  }

  @override
  bool operator ==(Object other) => other is Money && other.cents == cents;

  @override
  int get hashCode => cents.hashCode;

  @override
  String toString() => format();
}
