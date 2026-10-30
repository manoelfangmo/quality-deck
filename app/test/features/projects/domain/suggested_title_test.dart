import 'package:flutter_test/flutter_test.dart';

import 'package:app/features/projects/domain/suggested_title.dart';

void main() {
  test('two-word name uses the last word and the street', () {
    expect(suggestedTitle('Ana Melgar', '123 Oak St'), 'Melgar – 123 Oak St');
  });

  test('three-word name uses the last word', () {
    expect(
      suggestedTitle('Mary Ann Melgar', '123 Oak St'),
      'Melgar – 123 Oak St',
    );
  });

  test('one-word name uses the whole name', () {
    expect(suggestedTitle('Prince', '123 Oak St'), 'Prince – 123 Oak St');
  });

  test('blank street gives just the name', () {
    expect(suggestedTitle('Ana Melgar', '  '), 'Melgar');
  });

  test('long input is truncated to 120 characters', () {
    final street = 'A' * 200;
    final result = suggestedTitle('Melgar', street);
    expect(result.length, 120);
    expect(result, startsWith('Melgar – '));
  });
}
