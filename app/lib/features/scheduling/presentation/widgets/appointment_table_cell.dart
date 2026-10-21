import 'package:flutter/material.dart';

import 'package:app/core/domain/business_time.dart';

class AppointmentTableCell extends StatelessWidget {
  const AppointmentTableCell({
    required this.startsAt,
    required this.now,
    required this.timeZone,
    super.key,
  });

  final DateTime? startsAt;
  final DateTime now;
  final String timeZone;

  @override
  Widget build(BuildContext context) {
    final at = startsAt;
    if (at == null) return const SizedBox.shrink();

    final businessTime = BusinessTime(timeZone);
    final past = at.isBefore(now.toUtc());
    if (past) {
      return Text(
        businessTime.formatTablePast(at),
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      );
    }
    return Text(businessTime.formatTableUpcoming(at));
  }
}
