import 'package:flutter_test/flutter_test.dart';

import 'package:app/core/domain/percent.dart';

void main() {
  test('parses a percentage to basis points', () {
    expect(Percent.tryParse('12.5')?.basisPoints, 1250);
    expect(Percent.tryParse('100')?.basisPoints, 10000);
    expect(Percent.tryParse('12')?.basisPoints, 1200);
  });

  test('rejects out of range, a sign, and three decimals', () {
    expect(Percent.tryParse('101'), isNull);
    expect(Percent.tryParse('-1'), isNull);
    expect(Percent.tryParse('1.234'), isNull);
  });

  test('formats basis points without trailing zeros', () {
    expect(const Percent(1250).format(), '12.5%');
    expect(const Percent(1200).format(), '12%');
    expect(const Percent(10000).format(), '100%');
  });
}
