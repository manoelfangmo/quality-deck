import 'package:flutter_test/flutter_test.dart';

import 'package:app/features/projects/presentation/validators/project_validators.dart';

void main() {
  test('client is required', () {
    expect(
      ProjectValidators.client(null),
      'Choose a client or add a new one.',
    );
    expect(ProjectValidators.client(Object()), isNull);
  });

  test('street and city are required', () {
    expect(ProjectValidators.street(''), 'Enter the site address.');
    expect(ProjectValidators.city('  '), 'Enter the site address.');
    expect(ProjectValidators.street('12 Oak St'), isNull);
    expect(ProjectValidators.city('Bowie'), isNull);
  });

  test('state must be two letters', () {
    expect(ProjectValidators.state(''), 'Use the 2-letter state, e.g. MD.');
    expect(ProjectValidators.state('M'), 'Use the 2-letter state, e.g. MD.');
    expect(ProjectValidators.state('MD'), isNull);
  });

  test('ZIP must be 5 digits or ZIP+4', () {
    expect(ProjectValidators.zip(''), 'Enter a 5-digit ZIP.');
    expect(ProjectValidators.zip('207'), 'Enter a 5-digit ZIP.');
    expect(ProjectValidators.zip('20715'), isNull);
    expect(ProjectValidators.zip('20715-1234'), isNull);
  });

  test('title is required and at most 120 characters', () {
    expect(ProjectValidators.title(''), 'Enter a project title.');
    expect(ProjectValidators.title('A' * 121), 'Enter a project title.');
    expect(ProjectValidators.title('Melgar – 12 Oak St'), isNull);
  });
}
