import 'package:flutter_test/flutter_test.dart';

import 'package:app/core/domain/quantity.dart';

void main() {
  test('parses quantities to hundredths', () {
    expect(Quantity.tryParse('192.5')?.hundredths, 19250);
    expect(Quantity.tryParse('3')?.hundredths, 300);
    expect(Quantity.tryParse('0.01')?.hundredths, 1);
  });

  test('rejects zero, a sign, three decimals, and non-numeric input', () {
    expect(Quantity.tryParse('0'), isNull);
    expect(Quantity.tryParse('-1'), isNull);
    expect(Quantity.tryParse('1.234'), isNull);
    expect(Quantity.tryParse('abc'), isNull);
  });

  test('formats without trailing zeros', () {
    expect(const Quantity(19250).format(), '192.5');
    expect(const Quantity(300).format(), '3');
    expect(const Quantity(1).format(), '0.01');
  });
}
