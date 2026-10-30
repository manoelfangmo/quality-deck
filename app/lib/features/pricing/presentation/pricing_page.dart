import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:app/core/constants/breakpoints.dart';
import 'package:app/core/utils/toasts.dart';
import 'package:app/core/widgets/error_retry.dart';
import 'package:app/core/widgets/paginated_table_component.dart';
import 'package:app/core/widgets/table_dropdown_button.dart';
import 'package:app/features/pricing/domain/price_item.dart';
import 'package:app/features/pricing/presentation/controllers/price_item_actions.dart';
import 'package:app/features/pricing/presentation/controllers/price_items_table.dart';
import 'package:app/features/pricing/presentation/controllers/pricing_settings.dart';
import 'package:app/features/pricing/presentation/widgets/delete_price_item_dialog.dart';
import 'package:app/features/pricing/presentation/widgets/edit_labor_rate_sheet.dart';
import 'package:app/features/pricing/presentation/widgets/edit_overhead_sheet.dart';
import 'package:app/features/pricing/presentation/widgets/price_item_form_sheet.dart';
import 'package:app/features/pricing/presentation/widgets/pricing_settings_header.dart';

class PricingPage extends ConsumerWidget {
  const PricingPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(pricingSettingsProvider);
    final items = ref.watch(allPriceItemsProvider);
    final compact = MediaQuery.sizeOf(context).width < Breakpoints.phone;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Pricing', style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 16),
            settings.when(
              loading: () => const Padding(
                padding: EdgeInsets.symmetric(vertical: 24),
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (error, stackTrace) => ErrorRetry(
                onRetry: () => ref.invalidate(pricingSettingsProvider),
              ),
              data: (value) => PricingSettingsHeader(
                settings: value,
                onEditLaborRate: () => showEditLaborRateSheet(
                  context,
                  settings: value,
                ),
                onEditOverhead: () =>
                    showEditOverheadSheet(context, settings: value),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Price list',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                _AddItemButton(
                  compact: compact,
                  onPressed: () => _openForm(context),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: items.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stackTrace) => ErrorRetry(
                  onRetry: () => ref.invalidate(allPriceItemsProvider),
                ),
                data: (list) {
                  if (list.isEmpty) {
                    return _EmptyPriceList(
                      compact: compact,
                      onAdd: () => _openForm(context),
                    );
                  }
                  return PaginatedTableComponent<PriceItem>(
                    showSearchField: false,
                    columns: _columns(context, ref, compact: compact),
                    data: list,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<TableColumn<PriceItem>> _columns(
    BuildContext context,
    WidgetRef ref, {
    required bool compact,
  }) {
    return [
      TableColumn(
        columnName: 'Name',
        onBuild: (item) {
          final line = item.descriptionLine;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(item.name),
              if (line != null)
                Text(
                  line,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
            ],
          );
        },
      ),
      TableColumn(columnName: 'Price', onBuild: (item) => Text(item.priceLabel)),
      if (!compact)
        TableColumn(
          columnName: 'Updated',
          onBuild: (item) => Text(DateFormat.MMMd().format(item.updatedAt)),
        ),
      TableColumn(
        columnName: '',
        onBuild: (item) => TableDropdownButton(
          actions: [
            DropDownAction(
              actionName: 'Edit',
              onClick: () => _openForm(context, item: item),
            ),
            DropDownAction(
              actionName: 'Delete',
              isDestructive: true,
              onClick: () => _delete(context, ref, item),
            ),
          ],
        ),
      ),
    ];
  }

  Future<void> _openForm(BuildContext context, {PriceItem? item}) async {
    await showPriceItemForm(context, item: item);
  }

  Future<void> _delete(
    BuildContext context,
    WidgetRef ref,
    PriceItem item,
  ) async {
    final confirmed = await showDeletePriceItemDialog(
      context: context,
      name: item.name,
    );
    if (!confirmed) return;
    final deleted = await ref
        .read(priceItemActionsControllerProvider(item.id).notifier)
        .delete();
    if (deleted && context.mounted) {
      AppSnackbars.show(context, 'Item deleted');
    }
  }
}

class _AddItemButton extends StatelessWidget {
  const _AddItemButton({required this.compact, required this.onPressed});

  final bool compact;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    if (compact) {
      return IconButton.filled(
        tooltip: 'Add item',
        onPressed: onPressed,
        icon: const Icon(Icons.add),
      );
    }
    return FilledButton.icon(
      onPressed: onPressed,
      style: FilledButton.styleFrom(minimumSize: const Size(44, 48)),
      icon: const Icon(Icons.add),
      label: const Text('Add item'),
    );
  }
}

class _EmptyPriceList extends StatelessWidget {
  const _EmptyPriceList({required this.compact, required this.onAdd});

  final bool compact;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'No prices yet',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 16),
          _AddItemButton(compact: compact, onPressed: onAdd),
        ],
      ),
    );
  }
}
