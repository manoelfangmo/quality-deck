import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:app/core/domain/app_exception.dart';
import 'package:app/core/domain/money.dart';
import 'package:app/core/domain/pricing_type.dart';
import 'package:app/core/domain/quantity.dart';
import 'package:app/core/routing/app_routes.dart';
import 'package:app/core/utils/toasts.dart';
import 'package:app/core/widgets/adaptive_sheet.dart';
import 'package:app/core/widgets/confirm_dialog.dart';
import 'package:app/features/estimates/data/line_items_repository.dart';
import 'package:app/features/estimates/data/models.dart';
import 'package:app/features/estimates/domain/line_math.dart';
import 'package:app/features/estimates/presentation/controllers/project_jobs.dart';
import 'package:app/features/estimates/presentation/validators/estimate_validators.dart';
import 'package:app/features/pricing/data/price_items_repository.dart';
import 'package:app/features/pricing/domain/price_item.dart';

Future<bool> showAddFromPriceListSheet(
  BuildContext context, {
  required String projectId,
  required String jobId,
}) async {
  final result = await showAdaptiveFormSheet<bool>(
    context: context,
    builder: (context) =>
        AddFromPriceListSheet(projectId: projectId, jobId: jobId),
  );
  return result ?? false;
}

class AddFromPriceListSheet extends ConsumerStatefulWidget {
  const AddFromPriceListSheet({
    required this.projectId,
    required this.jobId,
    super.key,
  });

  final String projectId;
  final String jobId;

  @override
  ConsumerState<AddFromPriceListSheet> createState() =>
      _AddFromPriceListSheetState();
}

class _AddFromPriceListSheetState extends ConsumerState<AddFromPriceListSheet> {
  final _search = TextEditingController();
  final _quantity = TextEditingController();
  String _query = '';
  List<PriceItem>? _items;
  PriceItem? _selected;
  String? _quantityError;
  String? _errorMessage;
  bool _submitting = false;
  bool _dirty = false;
  bool _loadFailed = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _load(''));
  }

  @override
  void dispose() {
    _search.dispose();
    _quantity.dispose();
    super.dispose();
  }

  Future<void> _load(String query) async {
    try {
      final items = await ref
          .read(priceItemsRepositoryProvider)
          .search(query, limit: 30);
      if (!mounted) return;
      setState(() {
        _items = items;
        _loadFailed = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _loadFailed = true);
    }
  }

  Future<void> _cancel() async {
    if (_dirty) {
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

  Future<void> _add() async {
    final item = _selected;
    if (item == null) return;
    final quantityError = EstimateValidators.quantity(
      _quantity.text,
      type: item.pricingType,
    );
    if (quantityError != null) {
      setState(() => _quantityError = quantityError);
      return;
    }
    final quantity = item.pricingType == PricingType.fixed
        ? const Quantity(100)
        : Quantity.tryParse(_quantity.text)!;
    setState(() {
      _submitting = true;
      _errorMessage = null;
      _quantityError = null;
    });
    try {
      await ref
          .read(lineItemsRepositoryProvider)
          .addFromPriceList(
            AddPriceListLineCommand(
              jobId: widget.jobId,
              priceItemId: item.id,
              quantity: quantity,
            ),
          );
      ref.invalidate(projectJobsProvider(widget.projectId));
      if (!mounted) return;
      AppSnackbars.show(context, 'Line added');
      Navigator.of(context).pop(true);
    } on AppException catch (error) {
      if (!mounted) return;
      setState(() {
        _submitting = false;
        _errorMessage = error.message;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _submitting = false;
        _errorMessage = 'Something went wrong.';
      });
    }
  }

  String? _preview(PriceItem item) {
    final quantity = item.pricingType == PricingType.fixed
        ? const Quantity(100)
        : Quantity.tryParse(_quantity.text);
    if (quantity == null) return null;
    final total = Money(lineTotal(quantity, item.price.cents));
    if (item.pricingType == PricingType.fixed) {
      return 'Fixed = ${total.format()}';
    }
    return '${quantity.format()} ${item.pricingType.quantityUnit} × ${item.price.format()} = ${total.format()}';
  }

  @override
  Widget build(BuildContext context) {
    return FormSheetScaffold(
      title: 'Add from price list',
      primaryLabel: 'Add',
      isSubmitting: _submitting,
      onCancel: _cancel,
      onPrimary: _selected == null ? null : _add,
      fields: _fields(context, _items, _loadFailed),
    );
  }

  Widget _fields(
    BuildContext context,
    List<PriceItem>? items,
    bool failed,
  ) {
    if (failed) {
      return const Text('Something went wrong.');
    }
    if (items == null) {
      return const Center(child: CircularProgressIndicator());
    }
    if (items.isEmpty && _query.isEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text('Your price list is empty.'),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: () {
              Navigator.of(context).pop(false);
              context.go(AppRoutes.pricing);
            },
            child: const Text('Go to Pricing'),
          ),
        ],
      );
    }

    final selected = _selected;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: _search,
          enabled: !_submitting,
          decoration: const InputDecoration(labelText: 'Search price list'),
          onChanged: (value) {
            setState(() {
              _query = value;
              _dirty = true;
            });
            _load(value);
          },
        ),
        const SizedBox(height: 12),
        if (items.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Text('No matching items.'),
          )
        else
          ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 240),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                final selectedItem = selected?.id == item.id;
                return ListTile(
                  selected: selectedItem,
                  title: Text(item.name),
                  subtitle: Text(item.priceLabel),
                  onTap: _submitting
                      ? null
                      : () {
                          setState(() {
                            _selected = item;
                            _dirty = true;
                            _quantityError = null;
                            if (item.pricingType == PricingType.fixed) {
                              _quantity.clear();
                            }
                          });
                        },
                );
              },
            ),
          ),
        if (selected != null && selected.pricingType != PricingType.fixed) ...[
          const SizedBox(height: 16),
          TextField(
            controller: _quantity,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            enabled: !_submitting,
            decoration: InputDecoration(
              labelText: 'Quantity',
              suffixText: selected.pricingType.quantityUnit,
              errorText: _quantityError,
            ),
            onChanged: (_) {
              setState(() {
                _dirty = true;
                _quantityError = null;
              });
            },
          ),
        ],
        if (selected != null) ...[
          const SizedBox(height: 12),
          Text(
            _preview(selected) ?? selected.priceLabel,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
        if (_errorMessage != null) ...[
          const SizedBox(height: 16),
          Text(
            _errorMessage!,
            style: TextStyle(color: Theme.of(context).colorScheme.error),
          ),
        ],
      ],
    );
  }
}
