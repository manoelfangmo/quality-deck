import 'package:flutter/material.dart';

import 'package:app/core/domain/business_time.dart';
import 'package:app/core/domain/phone.dart';
import 'package:app/features/projects/data/models.dart';

class ProjectClientCell extends StatelessWidget {
  const ProjectClientCell({
    required this.row,
    required this.now,
    required this.timeZone,
    this.expanded = false,
    super.key,
  });

  final ProjectRow row;
  final DateTime now;
  final String timeZone;
  final bool expanded;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final name = row.clientRemoved
        ? '${row.clientName} (removed)'
        : row.clientName;
    final appointment = _appointmentLine();
    final phone = row.clientPhone;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          name,
          style: expanded ? theme.textTheme.titleMedium : theme.textTheme.bodyMedium,
        ),
        if (expanded && phone != null) ...[
          const SizedBox(height: 4),
          Text(Phone.format(phone), style: theme.textTheme.bodyMedium),
        ],
        if (appointment != null) ...[
          const SizedBox(height: 2),
          Text(
            appointment,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ] else if (expanded) ...[
          const SizedBox(height: 2),
          Text(
            'No appointment',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ],
    );
  }

  String? _appointmentLine() {
    final startsAt = row.appointmentStartsAt;
    if (startsAt == null) return null;
    final businessTime = BusinessTime(timeZone);
    if (startsAt.isBefore(now.toUtc())) {
      return businessTime.formatTablePast(startsAt);
    }
    return businessTime.formatTableUpcoming(startsAt);
  }
}
