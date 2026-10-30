class Percent {
  const Percent(this.basisPoints);

  /// 1250 = 12.50%.
  final int basisPoints;

  static final _digits = RegExp(r'^\d+$');

  /// Parses a percentage. Accepts "12.5" and "100". At most two decimals.
  static Percent? tryParse(String? input) {
    if (input == null) return null;
    var text = input.trim();
    if (text.isEmpty) return null;
    if (text.endsWith('%')) {
      text = text.substring(0, text.length - 1).trim();
    }
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

    final percent = int.tryParse(whole);
    if (percent == null) return null;
    final fracBps = int.parse(fraction.padRight(2, '0'));
    final bps = percent * 100 + fracBps;
    if (bps > 10000) return null;
    return Percent(bps);
  }

  /// "12.5%" or "12%" — trailing zeros dropped.
  String format() {
    final whole = basisPoints ~/ 100;
    final fraction = basisPoints % 100;
    if (fraction == 0) return '$whole%';
    if (fraction % 10 == 0) return '$whole.${fraction ~/ 10}%';
    return '$whole.${fraction.toString().padLeft(2, '0')}%';
  }

  @override
  bool operator ==(Object other) =>
      other is Percent && other.basisPoints == basisPoints;

  @override
  int get hashCode => basisPoints.hashCode;

  @override
  String toString() => format();
}
