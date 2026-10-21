import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:app/core/domain/money.dart';
import 'package:app/core/domain/percent.dart';
import 'package:app/features/estimates/domain/job.dart';
import 'package:app/features/estimates/domain/line_item.dart';
import 'package:app/features/estimates/domain/line_math.dart';

part 'job_with_lines.freezed.dart';

@freezed
abstract class JobWithLines with _$JobWithLines {
  const JobWithLines._();

  const factory JobWithLines({
    required Job job,
    required List<LineItem> lines,
  }) = _JobWithLines;

  Money get total => jobTotal(lines: lines, labor: job.labor);
}

class ProjectTotals {
  const ProjectTotals({
    required this.jobs,
    required this.subtotal,
    this.overhead,
    this.overheadCents,
    required this.total,
  });

  final List<JobWithLines> jobs;
  final Money subtotal;
  final Percent? overhead;
  final Money? overheadCents;
  final Money total;

  bool get hasOverhead => overhead != null;
}

ProjectTotals projectTotals(List<JobWithLines> jobs, Percent? overhead) {
  final subtotal = jobs.fold<int>(0, (sum, job) => sum + job.total.cents);
  final overheadCents = overhead == null
      ? null
      : Money(overheadAmount(subtotal, overhead.basisPoints));
  return ProjectTotals(
    jobs: jobs,
    subtotal: Money(subtotal),
    overhead: overhead,
    overheadCents: overheadCents,
    total: Money(subtotal + (overheadCents?.cents ?? 0)),
  );
}
