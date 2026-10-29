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

class PackageTotal {
  const PackageTotal({
    required this.label,
    required this.jobs,
    required this.subtotal,
    this.overhead,
    this.overheadCents,
    required this.total,
  });

  final String label;
  final List<JobWithLines> jobs;
  final Money subtotal;
  final Percent? overhead;
  final Money? overheadCents;
  final Money total;

  bool get hasOverhead => overhead != null;
}

ProjectTotals projectTotals(List<JobWithLines> jobs, Percent? overhead) {
  return _totalsFor(jobs, overhead);
}

ProjectTotals _totalsFor(List<JobWithLines> jobs, Percent? overhead) {
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

List<PackageTotal> packageTotals(List<JobWithLines> jobs, Percent? overhead) {
  final byId = {for (final job in jobs) job.job.id: job};
  final defaultJobs = [
    for (final job in jobs)
      if (!job.job.isAlternate) job,
  ];
  final alternates = [
    for (final job in jobs)
      if (job.job.isAlternate) job,
  ];

  PackageTotal pack(String label, List<JobWithLines> members) {
    final totals = _totalsFor(members, overhead);
    return PackageTotal(
      label: label,
      jobs: members,
      subtotal: totals.subtotal,
      overhead: totals.overhead,
      overheadCents: totals.overheadCents,
      total: totals.total,
    );
  }

  if (alternates.isEmpty) {
    return [pack('Total Labor & Materials', defaultJobs)];
  }

  final replacedIds = <String>{
    for (final job in alternates)
      if (job.job.alternateOfJobId != null) job.job.alternateOfJobId!,
  };
  final defaultTitles = [
    for (final id in replacedIds)
      if (byId[id] != null) byId[id]!.job.title,
  ];
  final defaultLabel = defaultTitles.isEmpty
      ? 'Total Labor & Materials'
      : 'Total with ${defaultTitles.join(' + ')}';

  return [
    pack(defaultLabel, defaultJobs),
    for (final alternate in alternates)
      pack('Total with ${alternate.job.title}', [
        for (final job in defaultJobs)
          if (job.job.id == alternate.job.alternateOfJobId) alternate else job,
      ]),
  ];
}
