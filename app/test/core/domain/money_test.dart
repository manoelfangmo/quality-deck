import 'package:flutter_test/flutter_test.dart';

import 'package:app/core/domain/money.dart';

void main() {
  test('parses common money inputs to cents', () {
    expect(Money.tryParse(r'$1,234.5')?.cents, 123450);
    expect(Money.tryParse('4.50')?.cents, 450);
    expect(Money.tryParse('0')?.cents, 0);
    expect(Money.tryParse('1,250')?.cents, 125000);
  });

  test('rejects a sign, non-numeric input, and three decimals', () {
    expect(Money.tryParse('-1'), isNull);
    expect(Money.tryParse('abc'), isNull);
    expect(Money.tryParse('1.234'), isNull);
  });

  test('formats cents as dollars', () {
    expect(const Money(123450).format(), r'$1,234.50');
    expect(const Money(0).format(), r'$0.00');
  });
}
