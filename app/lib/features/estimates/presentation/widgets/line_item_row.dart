import 'package:flutter/material.dart';

import 'package:app/core/constants/breakpoints.dart';
import 'package:app/core/domain/pricing_type.dart';
import 'package:app/features/estimates/domain/line_item.dart';

class LineItemRow extends StatelessWidget {
  const LineItemRow({
    required this.item,
    required this.index,
    required this.onTap,
    this.showHandle = true,
    super.key,
  });

  final LineItem item;
  final int index;
  final VoidCallback onTap;
  final bool showHandle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final compact = MediaQuery.sizeOf(context).width < Breakpoints.phone;
    final nameStyle = theme.textTheme.bodyMedium;
    final secondary = theme.textTheme.bodySmall?.copyWith(
      color: theme.colorScheme.onSurfaceVariant,
    );

    final handle = showHandle
        ? ReorderableDragStartListener(
            index: index,
            child: const SizedBox(
              width: 44,
              height: 44,
              child: Icon(Icons.drag_handle),
            ),
          )
        : const SizedBox(width: 44, height: 44);

    final name = Row(
      children: [
        Flexible(child: Text(item.name, style: nameStyle)),
        if (item.isCustom) ...[
          const SizedBox(width: 8),
          const _CustomBadge(),
        ],
      ],
    );

    final description = item.descriptionLine;
    final priceLine = _PriceLine(item: item, style: secondary);
    final total = Text(item.total.format(), style: nameStyle);

    final body = compact
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              name,
              if (description != null) Text(description, style: secondary),
              priceLine,
              Align(alignment: Alignment.centerRight, child: total),
            ],
          )
        : Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    name,
                    if (description != null) Text(description, style: secondary),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Flexible(child: priceLine),
              const SizedBox(width: 12),
              total,
            ],
          );

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              handle,
              Expanded(child: body),
            ],
          ),
        ),
      ),
    );
  }
}

class _CustomBadge extends StatelessWidget {
  const _CustomBadge();

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: scheme.secondaryContainer,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        'Custom',
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: scheme.onSecondaryContainer,
        ),
      ),
    );
  }
}

class _PriceLine extends StatelessWidget {
  const _PriceLine({required this.item, required this.style});

  final LineItem item;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    if (item.pricingType == PricingType.fixed) {
      if (!item.hasOverride) {
        return Text('Fixed', style: style);
      }
      return Text.rich(
        TextSpan(
          style: style,
          children: [
            TextSpan(
              text: item.savedPrice.format(),
              style: const TextStyle(decoration: TextDecoration.lineThrough),
            ),
            TextSpan(text: ' ${item.effectivePrice.format()}  Fixed'),
          ],
        ),
      );
    }

    final quantity = '${item.quantity.format()} ${item.pricingType.quantityUnit}';
    if (!item.hasOverride) {
      return Text('$quantity × ${item.effectivePrice.format()}', style: style);
    }
    return Text.rich(
      TextSpan(
        style: style,
        children: [
          TextSpan(
            text: item.savedPrice.format(),
            style: const TextStyle(decoration: TextDecoration.lineThrough),
          ),
          TextSpan(
            text: ' $quantity × ${item.effectivePrice.format()}',
          ),
        ],
      ),
    );
  }
}
