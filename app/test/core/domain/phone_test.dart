import 'package:flutter_test/flutter_test.dart';

import 'package:app/core/domain/phone.dart';

void main() {
  test('normalizes common US formats to E.164', () {
    expect(Phone.normalize('(301) 555-0123'), '+13015550123');
    expect(Phone.normalize('301.555.0123'), '+13015550123');
    expect(Phone.normalize('1-301-555-0123'), '+13015550123');
  });

  test('formats E.164 back to a US number', () {
    expect(Phone.format('+13015550123'), '(301) 555-0123');
  });

  test('empty input normalizes to null', () {
    expect(Phone.normalize(null), isNull);
    expect(Phone.normalize(''), isNull);
    expect(Phone.normalize('   '), isNull);
  });
}
