import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:app/core/constants/breakpoints.dart';
import 'package:app/core/domain/money.dart';
import 'package:app/core/domain/pricing_type.dart';
import 'package:app/core/domain/quantity.dart';
import 'package:app/core/utils/toasts.dart';
import 'package:app/core/widgets/adaptive_sheet.dart';
import 'package:app/core/widgets/confirm_dialog.dart';
import 'package:app/features/estimates/domain/line_item.dart';
import 'package:app/features/estimates/domain/line_math.dart';
import 'package:app/features/estimates/presentation/controllers/line_form.dart';
import 'package:app/features/estimates/presentation/controllers/line_removal.dart';
import 'package:app/features/estimates/presentation/validators/estimate_validators.dart';

Future<bool> showLineFormSheet(
  BuildContext context, {
  required String projectId,
  required String jobId,
  LineItem? item,
  bool readOnly = false,
}) async {
  final result = await showAdaptiveFormSheet<bool>(
    context: context,
    builder: (context) => LineFormSheet(
      projectId: projectId,
      jobId: jobId,
      item: item,
      readOnly: readOnly,
    ),
  );
  return result ?? false;
}

class LineFormSheet extends ConsumerStatefulWidget {
  const LineFormSheet({
    required this.projectId,
    required this.jobId,
    this.item,
    this.readOnly = false,
    super.key,
  });

  final String projectId;
  final String jobId;
  final LineItem? item;
  final bool readOnly;

  @override
  ConsumerState<LineFormSheet> createState() => _LineFormSheetState();
}

class _LineFormSheetState extends ConsumerState<LineFormSheet> {
  late final TextEditingController _name;
  late final TextEditingController _description;
  late final TextEditingController _quantity;
  late final TextEditingController _price;

  @override
  void initState() {
    super.initState();
    final item = widget.item;
    _name = TextEditingController(text: item?.name ?? '');
    _description = TextEditingController(text: item?.description ?? '');
    _quantity = TextEditingController(
      text: item == null || item.pricingType == PricingType.fixed
          ? ''
          : item.quantity.format(),
    );
    _price = TextEditingController(
      text: item == null ? '' : _moneyInput(item.effectivePrice.cents),
    );
  }

  @override
  void dispose() {
    _name.dispose();
    _description.dispose();
    _quantity.dispose();
    _price.dispose();
    super.dispose();
  }

  LineFormController get _form => ref.read(
    lineFormControllerProvider(
      projectId: widget.projectId,
      jobId: widget.jobId,
      item: widget.item,
    ).notifier,
  );

  Future<void> _cancel() async {
    if (!widget.readOnly && _form.isDirty) {
      final discard = await showConfirmDialog(
        context: context,
        title: 'Discard changes?',
        body: 'Your edits will be lost.',
        confirmLabel: 'Discard',
      );
      if (!discard) return;
    }
    if (mounted) Navigator.of(context).pop(false);
  }

  Future<void> _save() async {
    final adding = widget.item == null;
    final saved = await _form.submit();
    if (!saved || !mounted) return;
    AppSnackbars.show(context, adding ? 'Line added' : 'Line updated');
    Navigator.of(context).pop(true);
  }

  void _remove() {
    final item = widget.item;
    if (item == null) return;
    Navigator.of(context).pop(true);
    ref.read(lineRemovalControllerProvider(widget.projectId).notifier).hide(item.id);
    AppSnackbars.showUndo(
      context,
      'Line removed',
      duration: const Duration(seconds: 5),
      onUndo: () {
        ref.read(lineRemovalControllerProvider(widget.projectId).notifier).undo(item.id);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final form = ref.watch(
      lineFormControllerProvider(
        projectId: widget.projectId,
        jobId: widget.jobId,
        item: widget.item,
      ),
    );
    final wide = MediaQuery.sizeOf(context).width >= Breakpoints.wide;
    final type = form.pricingType;
    final enabled = !form.isSubmitting && !widget.readOnly;
    final preview = _preview(form.pricingType, form.quantity, form.price);

    final sourceLabel = form.isAdd
        ? null
        : form.isCustom
        ? null
        : (form.priceItemDeleted
              ? 'Price list item deleted'
              : 'From your price list');

    return FormSheetScaffold(
      title: form.isAdd ? 'Add custom line' : 'Edit line',
      primaryLabel: form.isAdd ? 'Add' : 'Save',
      isSubmitting: form.isSubmitting,
      readOnly: widget.readOnly,
      onCancel: _cancel,
      onPrimary: _save,
      bottom: widget.readOnly || form.isAdd
          ? null
          : TextButton(
              onPressed: form.isSubmitting ? null : _remove,
              style: TextButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.error,
              ),
              child: const Text('Remove line'),
            ),
      fields: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (sourceLabel != null) ...[
            Text(
              sourceLabel,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 12),
          ],
          TextField(
            controller: _name,
            textInputAction: TextInputAction.next,
            textCapitalization: TextCapitalization.sentences,
            enabled: enabled && form.isCustom,
            decoration: InputDecoration(
              labelText: 'Name',
              errorText: form.nameError,
            ),
            onChanged: _form.setName,
          ),
          const SizedBox(height: 16),
          if (form.isCustom)
            _PricingTypeField(
              value: form.pricingType,
              errorText: form.pricingTypeError,
              enabled: enabled,
              wide: wide,
              onChanged: _form.setPricingType,
            )
          else
            InputDecorator(
              decoration: const InputDecoration(labelText: 'Pricing type'),
              child: Text(form.pricingType?.label ?? ''),
            ),
          const SizedBox(height: 16),
          TextField(
            controller: _description,
            minLines: 2,
            maxLines: 4,
            textCapitalization: TextCapitalization.sentences,
            enabled: enabled,
            decoration: InputDecoration(
              labelText: 'Description',
              errorText: form.descriptionError,
              helperText:
                  form.description.length >= 800 ||
                      form.description.length >
                          EstimateValidators.maxLineDescriptionLength
                  ? '${form.description.length} / ${EstimateValidators.maxLineDescriptionLength}'
                  : null,
            ),
            onChanged: _form.setDescription,
          ),
          if (type != PricingType.fixed) ...[
            const SizedBox(height: 16),
            TextField(
              controller: _quantity,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              textInputAction: TextInputAction.next,
              enabled: enabled,
              decoration: InputDecoration(
                labelText: 'Quantity',
                suffixText: type?.quantityUnit,
                errorText: form.quantityError,
              ),
              onChanged: _form.setQuantity,
            ),
          ],
          const SizedBox(height: 16),
          TextField(
            controller: _price,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            textInputAction: TextInputAction.done,
            enabled: enabled,
            decoration: InputDecoration(
              labelText: form.isPriceList
                  ? 'Price for this job'
                  : (type?.priceFieldLabel ?? 'Price'),
              errorText: form.priceError,
              helperText: form.isPriceList
                  ? 'Original: \$${form.originalPrice}'
                  : null,
            ),
            onChanged: _form.setPrice,
            onSubmitted: enabled ? (_) => _save() : null,
          ),
          if (form.isPriceList && form.hasOverride && enabled) ...[
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton(
                onPressed: () {
                  _form.resetOverride();
                  _price.text = form.originalPrice;
                },
                child: const Text('Reset'),
              ),
            ),
          ],
          if (preview != null) ...[
            const SizedBox(height: 12),
            Text(
              preview,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
          if (form.errorMessage != null) ...[
            const SizedBox(height: 16),
            Text(
              form.errorMessage!,
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ],
        ],
      ),
    );
  }
}

String _moneyInput(int cents) {
  final dollars = cents ~/ 100;
  final remainder = cents % 100;
  if (remainder == 0) return dollars.toString();
  if (remainder % 10 == 0) return '$dollars.${remainder ~/ 10}';
  return '$dollars.${remainder.toString().padLeft(2, '0')}';
}

String? _preview(PricingType? type, String quantityText, String priceText) {
  if (type == null) return null;
  final price = Money.tryParse(priceText);
  if (price == null) return null;
  final quantity = type == PricingType.fixed
      ? const Quantity(100)
      : Quantity.tryParse(quantityText);
  if (quantity == null) return null;
  final total = Money(lineTotal(quantity, price.cents));
  if (type == PricingType.fixed) {
    return 'Fixed = ${total.format()}';
  }
  return '${quantity.format()} ${type.quantityUnit} × ${price.format()} = ${total.format()}';
}

class _PricingTypeField extends StatelessWidget {
  const _PricingTypeField({
    required this.value,
    required this.enabled,
    required this.wide,
    required this.onChanged,
    this.errorText,
  });

  final PricingType? value;
  final String? errorText;
  final bool enabled;
  final bool wide;
  final ValueChanged<PricingType?> onChanged;

  @override
  Widget build(BuildContext context) {
    if (wide) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SegmentedButton<PricingType>(
              segments: [
                for (final type in PricingType.values)
                  ButtonSegment(value: type, label: Text(type.label)),
              ],
              selected: {?value},
              emptySelectionAllowed: true,
              showSelectedIcon: false,
              onSelectionChanged: enabled
                  ? (selected) =>
                        onChanged(selected.isEmpty ? null : selected.first)
                  : null,
            ),
          ),
          if (errorText != null) ...[
            const SizedBox(height: 8),
            Text(
              errorText!,
              style: TextStyle(
                color: Theme.of(context).colorScheme.error,
                fontSize: 12,
              ),
            ),
          ],
        ],
      );
    }

    return DropdownButtonFormField<PricingType>(
      initialValue: value,
      decoration: InputDecoration(
        labelText: 'Pricing type',
        errorText: errorText,
      ),
      items: [
        for (final type in PricingType.values)
          DropdownMenuItem(value: type, child: Text(type.label)),
      ],
      onChanged: enabled ? onChanged : null,
    );
  }
}
