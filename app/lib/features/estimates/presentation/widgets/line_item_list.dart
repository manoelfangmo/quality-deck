import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:app/core/utils/toasts.dart';
import 'package:app/features/estimates/domain/line_item.dart';
import 'package:app/features/estimates/presentation/controllers/line_reorder.dart';
import 'package:app/features/estimates/presentation/widgets/line_form_sheet.dart';
import 'package:app/features/estimates/presentation/widgets/line_item_row.dart';

class LineItemList extends ConsumerWidget {
  const LineItemList({
    required this.projectId,
    required this.jobId,
    required this.lines,
    required this.fullIds,
    required this.hiddenIds,
    required this.readOnly,
    super.key,
  });

  final String projectId;
  final String jobId;
  final List<LineItem> lines;
  final List<String> fullIds;
  final Set<String> hiddenIds;
  final bool readOnly;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (lines.isEmpty) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(44, 8, 0, 8),
        child: Text(
          'No line items yet.',
          style: Theme.of(context).textTheme.bodyMedium
              ?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
        ),
      );
    }

    ref.listen(
      lineReorderControllerProvider(projectId: projectId, jobId: jobId),
      (previous, next) {
        final message = next.errorMessage;
        if (message != null && message != previous?.errorMessage) {
          AppSnackbars.show(context, message);
        }
      },
    );

    if (readOnly) {
      return Column(
        children: [
          for (var i = 0; i < lines.length; i++)
            LineItemRow(
              key: ValueKey(lines[i].id),
              item: lines[i],
              index: i,
              showHandle: false,
              onTap: () => showLineFormSheet(
                context,
                projectId: projectId,
                jobId: jobId,
                item: lines[i],
                readOnly: true,
              ),
            ),
        ],
      );
    }

    return ReorderableListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      buildDefaultDragHandles: false,
      itemCount: lines.length,
      onReorderItem: (oldIndex, newIndex) {
        ref
            .read(
              lineReorderControllerProvider(
                projectId: projectId,
                jobId: jobId,
              ).notifier,
            )
            .reorder(
              fullIds: fullIds,
              hiddenIds: hiddenIds,
              oldIndex: oldIndex,
              newIndex: newIndex,
            );
      },
      proxyDecorator: (child, index, animation) {
        final scheme = Theme.of(context).colorScheme;
        return AnimatedBuilder(
          animation: animation,
          builder: (context, child) {
            final t = Curves.easeOutCubic.transform(animation.value);
            return Transform.scale(
              scale: lerpDouble(1.0, 1.04, t)!,
              child: Material(
                elevation: lerpDouble(0, 12, t)!,
                color: scheme.surfaceContainerHigh, // opaque so rows underneath don't show through
                shadowColor: Colors.black.withValues(alpha: 0.35),
                borderRadius: BorderRadius.circular(12),
                clipBehavior: Clip.antiAlias,
                child: child,
              ),
            );
          },
          child: child,
        );
      },
      itemBuilder: (context, index) {
        final item = lines[index];
        return LineItemRow(
          key: ValueKey(item.id),
          item: item,
          index: index,
          showHandle: true,
          onTap: () => showLineFormSheet(
            context,
            projectId: projectId,
            jobId: jobId,
            item: item,
            readOnly: false,
          ),
        );
      },
    );
  }
}
