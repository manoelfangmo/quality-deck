import 'package:flutter/material.dart';

import 'package:app/features/estimates/domain/labor.dart';

class LaborRow extends StatelessWidget {
  const LaborRow({required this.labor, required this.onTap, super.key});

  final Labor labor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final secondary = theme.textTheme.bodySmall?.copyWith(
      color: theme.colorScheme.onSurfaceVariant,
    );

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(44, 8, 0, 8),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Labor', style: theme.textTheme.bodyMedium),
                    Text(
                      '${labor.hours.format()} hrs × ${labor.rate.format()} / hr',
                      style: secondary,
                    ),
                  ],
                ),
              ),
              Text(labor.total.format(), style: theme.textTheme.bodyMedium),
            ],
          ),
        ),
      ),
    );
  }
}
