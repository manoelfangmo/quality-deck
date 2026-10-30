import 'package:flutter_test/flutter_test.dart';

import '../../helpers/fixtures.dart';

void main() {
  test('hasBusiness and isOwner are false with no membership', () {
    expect(noBusinessUser.hasBusiness, isFalse);
    expect(noBusinessUser.isOwner, isFalse);
  });

  test('isOwner is true only for an owner membership', () {
    expect(ownerUser.hasBusiness, isTrue);
    expect(ownerUser.isOwner, isTrue);
    expect(memberUser.hasBusiness, isTrue);
    expect(memberUser.isOwner, isFalse);
  });
}
