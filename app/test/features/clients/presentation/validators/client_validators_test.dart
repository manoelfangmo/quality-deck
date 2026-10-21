import 'package:flutter_test/flutter_test.dart';

import 'package:app/features/clients/presentation/validators/client_validators.dart';

void main() {
  test('name is required and at most 120 characters after trim', () {
    expect(ClientValidators.name(null), "Enter the client's name.");
    expect(ClientValidators.name('  '), "Enter the client's name.");
    expect(ClientValidators.name('A' * 121), "Enter the client's name.");
    expect(ClientValidators.name('Ana Melgar'), isNull);
    expect(ClientValidators.name('A' * 120), isNull);
  });

  test('phone or email: at least one is required', () {
    expect(
      ClientValidators.contact(phone: '', email: '  '),
      'Add a phone number or an email.',
    );
    expect(ClientValidators.contact(phone: '3015550123', email: ''), isNull);
    expect(
      ClientValidators.contact(phone: '', email: 'ana@example.test'),
      isNull,
    );
  });

  test('email format when present', () {
    expect(ClientValidators.email(null), isNull);
    expect(ClientValidators.email(''), isNull);
    expect(ClientValidators.email('not-an-email'), 'Enter a valid email address.');
    expect(ClientValidators.email('ana@example.test'), isNull);
  });

  test('phone is 10 US digits, optional leading 1', () {
    expect(ClientValidators.phone(null), isNull);
    expect(ClientValidators.phone(''), isNull);
    expect(ClientValidators.phone('5550123'), 'Enter a 10-digit phone number.');
    expect(ClientValidators.phone('(301) 555-0123'), isNull);
    expect(ClientValidators.phone('1-301-555-0123'), isNull);
  });

  test('address is all four or none', () {
    expect(
      ClientValidators.address(street: '', city: '', state: '', zip: ''),
      isNull,
    );
    expect(
      ClientValidators.address(
        street: '12 Oak St',
        city: 'Bowie',
        state: 'MD',
        zip: '20715',
      ),
      isNull,
    );
    expect(
      ClientValidators.address(street: '', city: 'Bowie', state: '', zip: ''),
      'Complete the address or leave it all blank.',
    );
  });

  test('state is 2 letters', () {
    expect(ClientValidators.state(null), isNull);
    expect(ClientValidators.state('MD'), isNull);
    expect(ClientValidators.state('md'), isNull);
    expect(ClientValidators.state('Maryland'), 'Use the 2-letter state, e.g. MD.');
  });

  test('ZIP is 5 digits or ZIP+4', () {
    expect(ClientValidators.zip(null), isNull);
    expect(ClientValidators.zip('20715'), isNull);
    expect(ClientValidators.zip('20715-1234'), isNull);
    expect(ClientValidators.zip('207'), 'Enter a 5-digit ZIP.');
  });
}
