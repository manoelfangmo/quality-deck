class Quantity {
  const Quantity(this.hundredths);

  /// 19250 = 192.5
  final int hundredths;

  static final _digits = RegExp(r'^\d+$');

  /// Parses a quantity. Accepts "192.5" and "3". At most two decimals.
  /// Rejects zero, a leading sign, non-numeric input, and more than two
  /// decimals.
  static Quantity? tryParse(String? input) {
    if (input == null) return null;
    var text = input.trim();
    if (text.isEmpty) return null;
    if (text.startsWith('-') || text.startsWith('+')) return null;

    final parts = text.split('.');
    if (parts.length > 2) return null;
    final whole = parts[0];
    final fraction = parts.length == 2 ? parts[1] : '';
    if (whole.isEmpty || !_digits.hasMatch(whole)) return null;
    if (fraction.isNotEmpty && !_digits.hasMatch(fraction)) return null;
    if (fraction.length > 2) return null;

    final units = int.tryParse(whole);
    if (units == null) return null;
    final hundredths = units * 100 + int.parse(fraction.padRight(2, '0'));
    if (hundredths <= 0) return null;
    return Quantity(hundredths);
  }

  /// Parses a Postgres numeric (`"192.50"`) without using [double].
  factory Quantity.fromDb(Object value) {
    final parsed = tryParse(value.toString());
    if (parsed == null) {
      throw FormatException('Invalid quantity: $value');
    }
    return parsed;
  }

  /// "192.5" or "3" — trailing zeros dropped.
  String format() {
    final whole = hundredths ~/ 100;
    final fraction = hundredths % 100;
    if (fraction == 0) return '$whole';
    if (fraction % 10 == 0) return '$whole.${fraction ~/ 10}';
    return '$whole.${fraction.toString().padLeft(2, '0')}';
  }

  /// The value to send to Postgres numeric columns.
  String toDb() => format();

  @override
  bool operator ==(Object other) =>
      other is Quantity && other.hundredths == hundredths;

  @override
  int get hashCode => hundredths.hashCode;

  @override
  String toString() => format();
}
