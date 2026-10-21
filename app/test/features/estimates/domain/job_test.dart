import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/fixtures.dart';

void main() {
  test('jobs are numbered in created_at order', () {
    expect(backDeckJob.numberedTitle, '1. Back deck');
    expect(frontStepsJob.numberedTitle, '2. Front steps');
  });

  test('remaining jobs renumber after a delete', () {
    final remaining = frontStepsJob.copyWith(number: 1);
    expect(remaining.numberedTitle, '1. Front steps');
  });
}
