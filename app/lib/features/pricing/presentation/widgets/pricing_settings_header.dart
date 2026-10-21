import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:app/core/constants/breakpoints.dart';
import 'package:app/features/pricing/domain/pricing_settings.dart';

class PricingSettingsHeader extends StatelessWidget {
  const PricingSettingsHeader({
    required this.settings,
    required this.onEditLaborRate,
    required this.onEditOverhead,
    super.key,
  });

  final PricingSettings? settings;
  final VoidCallback onEditLaborRate;
  final VoidCallback onEditOverhead;

  @override
  Widget build(BuildContext context) {
    final wide = MediaQuery.sizeOf(context).width >= Breakpoints.wide;
    final labor = _SettingsCard(
      title: 'Labor rate',
      value: settings?.laborRate == null
          ? 'Not set'
          : '${settings!.laborRate!.format()} / hr',
      isSet: settings?.laborRate != null,
      updatedAt: settings?.laborRate != null ? settings!.updatedAt : null,
      updatedByName: settings?.laborRate != null
          ? settings!.updatedByName
          : null,
      onEdit: onEditLaborRate,
    );
    final overhead = _SettingsCard(
      title: 'Project overhead',
      value: settings?.overhead?.format() ?? 'Not set',
      isSet: settings?.overhead != null,
      updatedAt: settings?.overhead != null ? settings!.updatedAt : null,
      updatedByName: settings?.overhead != null
          ? settings!.updatedByName
          : null,
      onEdit: onEditOverhead,
    );

    if (wide) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: labor),
          const SizedBox(width: 12),
          Expanded(child: overhead),
        ],
      );
    }
    return Column(
      children: [
        labor,
        const SizedBox(height: 12),
        overhead,
      ],
    );
  }
}

class _SettingsCard extends StatelessWidget {
  const _SettingsCard({
    required this.title,
    required this.value,
    required this.isSet,
    required this.onEdit,
    this.updatedAt,
    this.updatedByName,
  });

  final String title;
  final String value;
  final bool isSet;
  final DateTime? updatedAt;
  final String? updatedByName;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final updated = _updatedLabel();
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 8, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(title, style: theme.textTheme.titleMedium),
            const SizedBox(height: 4),
            Row(
              children: [
                Expanded(
                  child: Text(value, style: theme.textTheme.headlineSmall),
                ),
                TextButton(
                  onPressed: onEdit,
                  child: Text(isSet ? 'Edit' : 'Set'),
                ),
              ],
            ),
            if (updated != null)
              Text(
                updated,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
          ],
        ),
      ),
    );
  }

  String? _updatedLabel() {
    if (updatedAt == null) return null;
    final date = DateFormat.MMMd().format(updatedAt!);
    final name = updatedByName;
    if (name == null || name.isEmpty) return 'Updated $date';
    return 'Updated $date · $name';
  }
}
