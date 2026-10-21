import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:app/core/constants/breakpoints.dart';
import 'package:app/core/domain/money.dart';
import 'package:app/core/domain/pricing_type.dart';
import 'package:app/core/utils/toasts.dart';
import 'package:app/core/widgets/confirm_dialog.dart';
import 'package:app/core/widgets/loading_button.dart';
import 'package:app/features/pricing/domain/price_item.dart';
import 'package:app/features/pricing/presentation/controllers/price_item_form.dart';
import 'package:app/features/pricing/presentation/models/price_item_form_state.dart';
import 'package:app/features/pricing/presentation/validators/pricing_validators.dart';

Future<bool> showPriceItemForm(BuildContext context, {PriceItem? item}) async {
  final wide = MediaQuery.sizeOf(context).width >= Breakpoints.wide;
  if (wide) {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => PriceItemFormSheet(item: item),
    );
    return result ?? false;
  }

  final height = MediaQuery.sizeOf(context).height;
  final result = await showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    enableDrag: false,
    isDismissible: false,
    useSafeArea: true,
    builder: (context) => SizedBox(
      height: height,
      child: PriceItemFormSheet(item: item),
    ),
  );
  return result ?? false;
}

class PriceItemFormSheet extends ConsumerStatefulWidget {
  const PriceItemFormSheet({this.item, super.key});

  final PriceItem? item;

  @override
  ConsumerState<PriceItemFormSheet> createState() => _PriceItemFormSheetState();
}

class _PriceItemFormSheetState extends ConsumerState<PriceItemFormSheet> {
  late final TextEditingController _name;
  late final TextEditingController _description;
  late final TextEditingController _price;

  @override
  void initState() {
    super.initState();
    final initial = widget.item == null
        ? const PriceItemFormState()
        : PriceItemFormState.fromItem(widget.item!);
    _name = TextEditingController(text: initial.name);
    _description = TextEditingController(text: initial.description);
    _price = TextEditingController(text: initial.price);
  }

  @override
  void dispose() {
    _name.dispose();
    _description.dispose();
    _price.dispose();
    super.dispose();
  }

  PriceItemFormController get _form =>
      ref.read(priceItemFormControllerProvider(item: widget.item).notifier);

  Future<void> _cancel() async {
    if (_form.isDirty) {
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
    final adding = ref
        .read(priceItemFormControllerProvider(item: widget.item))
        .isAdd;
    final saved = await _form.submit();
    if (!saved || !mounted) return;
    AppSnackbars.show(context, adding ? 'Item added' : 'Item updated');
    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    final form = ref.watch(priceItemFormControllerProvider(item: widget.item));
    final wide = MediaQuery.sizeOf(context).width >= Breakpoints.wide;
    final title = form.isAdd ? 'Add item' : 'Edit item';
    final type = form.pricingType;
    final parsedPrice = Money.tryParse(form.price);
    final preview = type == null || parsedPrice == null
        ? null
        : 'Shows as ${type.formatPrice(parsedPrice)}';
    final descriptionLength = form.description.length;
    final showCount =
        descriptionLength >= 800 ||
        descriptionLength > PricingValidators.maxDescriptionLength;

    final fields = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: _name,
          textInputAction: TextInputAction.next,
          textCapitalization: TextCapitalization.sentences,
          enabled: !form.isSubmitting,
          decoration: InputDecoration(
            labelText: 'Name',
            errorText: form.nameError,
          ),
          onChanged: _form.setName,
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _description,
          minLines: 2,
          maxLines: 4,
          textCapitalization: TextCapitalization.sentences,
          enabled: !form.isSubmitting,
          decoration: InputDecoration(
            labelText: 'Description',
            errorText: form.descriptionError,
            helperText: showCount
                ? '$descriptionLength / ${PricingValidators.maxDescriptionLength}'
                : null,
          ),
          onChanged: _form.setDescription,
        ),
        const SizedBox(height: 16),
        _PricingTypeField(
          value: form.pricingType,
          errorText: form.pricingTypeError,
          enabled: !form.isSubmitting,
          wide: wide,
          onChanged: _form.setPricingType,
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _price,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          textInputAction: TextInputAction.done,
          enabled: !form.isSubmitting,
          decoration: InputDecoration(
            labelText: type?.priceFieldLabel ?? 'Price',
            errorText: form.priceError,
          ),
          onChanged: _form.setPrice,
          onSubmitted: (_) => _save(),
        ),
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
    );

    final actions = Padding(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: form.isSubmitting ? null : _cancel,
              child: const Text('Cancel'),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: LoadingButton(
              label: 'Save',
              isLoading: form.isSubmitting,
              onPressed: _save,
            ),
          ),
        ],
      ),
    );

    final titleWidget = Padding(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 8),
      child: Text(
        title,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.titleLarge,
      ),
    );

    final body = wide
        ? Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              titleWidget,
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.sizeOf(context).height * 0.7,
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(24, 8, 24, 8),
                  child: fields,
                ),
              ),
              actions,
            ],
          )
        : Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              titleWidget,
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(24, 8, 24, 8),
                  child: fields,
                ),
              ),
              actions,
            ],
          );

    final material = Material(
      color: Theme.of(context).colorScheme.surface,
      child: SafeArea(
        child: PopScope(
          canPop: !form.isSubmitting,
          onPopInvokedWithResult: (didPop, result) async {
            if (didPop || form.isSubmitting) return;
            await _cancel();
          },
          child: body,
        ),
      ),
    );

    if (wide) {
      return Dialog(
        insetPadding: const EdgeInsets.all(24),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 560),
          child: material,
        ),
      );
    }
    return material;
  }
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
