import 'package:flutter_test/flutter_test.dart';

import 'package:app/core/domain/percent.dart';
import 'package:app/core/domain/quantity.dart';
import 'package:app/features/estimates/domain/job.dart';
import 'package:app/features/estimates/domain/job_type.dart';
import 'package:app/features/estimates/domain/job_with_lines.dart';
import 'package:app/features/estimates/domain/line_math.dart';

import '../../../helpers/fixtures.dart';

void main() {
  test('lineTotal matches the SQL rounding cases', () {
    expect(lineTotal(const Quantity(19250), 450), 86625);
    expect(lineTotal(const Quantity(300), 33), 99);
    expect(lineTotal(const Quantity(125), 1), 1);
    expect(lineTotal(const Quantity(4200), 3500), 147000);
  });

  test('laborTotal and overhead rounding', () {
    expect(laborTotal(const Quantity(1250), 6500), 81250);
    expect(overheadAmount(433875, 1250), 54234);
    expect(overheadAmount(4, 1250), 1);
  });

  test(
    'ProjectTotals includes labor in the subtotal and overhead in the total',
    () {
      final totals = projectTotals([
        backDeckWithLines,
        frontStepsWithLines,
      ], const Percent(1250));
      expect(totals.subtotal, backDeckWithLines.total);
      expect(totals.hasOverhead, isTrue);
      expect(
        totals.total.cents,
        totals.subtotal.cents + totals.overheadCents!.cents,
      );
    },
  );

  test('ProjectTotals has no overhead row when overhead is null', () {
    final totals = projectTotals([backDeckWithLines], null);
    expect(totals.hasOverhead, isFalse);
    expect(totals.overheadCents, isNull);
    expect(totals.total, totals.subtotal);
  });

  test('packageTotals is one total when no job is an alternate', () {
    final packages = packageTotals([
      backDeckWithLines,
      frontStepsWithLines,
    ], const Percent(1250));
    expect(packages, hasLength(1));
    expect(packages.single.label, 'Total Labor & Materials');
    expect(
      packages.single.total,
      projectTotals([
        backDeckWithLines,
        frontStepsWithLines,
      ], const Percent(1250)).total,
    );
  });

  test('packageTotals replaces the base job in each alternate package', () {
    final alternate = JobWithLines(
      job: Job(
        id: 'job-composite-option',
        projectId: backDeckJob.projectId,
        title: 'Composite option',
        jobType: JobType.deck,
        alternateOfJobId: backDeckJob.id,
        createdAt: DateTime.utc(2026, 10, 19),
        number: 3,
      ),
      lines: [customHaulAway],
    );
    final packages = packageTotals([
      backDeckWithLines,
      frontStepsWithLines,
      alternate,
    ], null);
    expect(packages, hasLength(2));
    expect(packages[0].label, 'Total with Back deck');
    expect(
      packages[0].total.cents,
      backDeckWithLines.total.cents + frontStepsWithLines.total.cents,
    );
    expect(packages[1].label, 'Total with Composite option');
    expect(
      packages[1].total.cents,
      alternate.total.cents + frontStepsWithLines.total.cents,
    );
  });

  test('job total is line totals plus labor', () {
    final linesOnly =
        compositeLine.total.cents +
        customHaulAway.total.cents +
        overriddenRailing.total.cents;
    expect(
      backDeckWithLines.total.cents,
      linesOnly + backDeckLabor.total.cents,
    );
  });
}
