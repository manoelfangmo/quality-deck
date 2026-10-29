import 'package:flutter_test/flutter_test.dart';

import 'package:app/features/estimates/presentation/validators/estimate_validators.dart';

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

  test('isAlternate follows alternateOfJobId', () {
    expect(backDeckJob.isAlternate, isFalse);
    expect(
      backDeckJob.copyWith(alternateOfJobId: frontStepsJob.id).isAlternate,
      isTrue,
    );
  });

  test('alternateOfJobId is required only when the job is an option', () {
    expect(EstimateValidators.alternateOfJobId(isAlternate: false), isNull);
    expect(
      EstimateValidators.alternateOfJobId(isAlternate: true),
      'Pick the job this option replaces.',
    );
    expect(
      EstimateValidators.alternateOfJobId(
        isAlternate: true,
        alternateOfJobId: backDeckJob.id,
      ),
      isNull,
    );
  });
}
