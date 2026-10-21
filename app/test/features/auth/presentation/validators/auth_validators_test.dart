import 'package:flutter_test/flutter_test.dart';

import 'package:app/features/auth/presentation/validators/auth_validators.dart';
import 'package:app/features/business/presentation/validators/business_validators.dart';

void main() {
  test('name must be non-empty', () {
    expect(AuthValidators.name(null), isNotNull);
    expect(AuthValidators.name('  '), isNotNull);
    expect(AuthValidators.name('Moises'), isNull);
  });

  test('email must look like an email', () {
    expect(AuthValidators.email(null), isNotNull);
    expect(AuthValidators.email('not-an-email'), isNotNull);
    expect(AuthValidators.email('owner@qualitydeck.test'), isNull);
  });

  test('password must be at least 8 characters', () {
    expect(AuthValidators.password('short'), isNotNull);
    expect(AuthValidators.password('password123'), isNull);
  });

  test('business name must be 1 to 80 characters', () {
    expect(BusinessValidators.businessName(''), isNotNull);
    expect(BusinessValidators.businessName('  '), isNotNull);
    expect(BusinessValidators.businessName('A' * 81), isNotNull);
    expect(BusinessValidators.businessName('Test Decks'), isNull);
    expect(BusinessValidators.businessName('A' * 80), isNull);
  });
}
