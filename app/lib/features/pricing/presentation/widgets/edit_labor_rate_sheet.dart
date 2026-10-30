import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:app/core/constants/breakpoints.dart';
import 'package:app/core/utils/toasts.dart';
import 'package:app/core/widgets/loading_button.dart';
import 'package:app/features/pricing/domain/pricing_settings.dart';
import 'package:app/features/pricing/presentation/controllers/pricing_settings.dart';

Future<bool> showEditLaborRateSheet(
  BuildContext context, {
  PricingSettings? settings,
}) async {
  final wide = MediaQuery.sizeOf(context).width >= Breakpoints.wide;
  if (wide) {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => EditLaborRateSheet(settings: settings),
    );
    return result ?? false;
  }

  final result = await showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (context) => Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: EditLaborRateSheet(settings: settings),
    ),
  );
  return result ?? false;
}

class EditLaborRateSheet extends ConsumerStatefulWidget {
  const EditLaborRateSheet({this.settings, super.key});

  final PricingSettings? settings;

  @override
  ConsumerState<EditLaborRateSheet> createState() => _EditLaborRateSheetState();
}

class _EditLaborRateSheetState extends ConsumerState<EditLaborRateSheet> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    final cents = widget.settings?.laborRate?.cents;
    _controller = TextEditingController(
      text: cents == null ? '' : _moneyInput(cents),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final saved = await ref
        .read(pricingSettingsControllerProvider.notifier)
        .saveLaborRate(_controller.text);
    if (!saved || !mounted) return;
    AppSnackbars.show(context, 'Labor rate updated');
    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    final action = ref.watch(pricingSettingsControllerProvider);
    final body = Padding(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Labor rate',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _controller,
            autofocus: true,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            enabled: !action.isSavingLabor,
            decoration: InputDecoration(
              labelText: 'Hourly rate',
              prefixText: r'$ ',
              suffixText: 'per hour',
              errorText: action.laborRateError ?? action.errorMessage,
            ),
            onSubmitted: (_) => _save(),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: action.isSavingLabor
                      ? null
                      : () => Navigator.of(context).pop(false),
                  child: const Text('Cancel'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: LoadingButton(
                  label: 'Save',
                  isLoading: action.isSavingLabor,
                  onPressed: _save,
                ),
              ),
            ],
          ),
        ],
      ),
    );

    if (MediaQuery.sizeOf(context).width >= Breakpoints.wide) {
      return Dialog(
        insetPadding: const EdgeInsets.all(24),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
          child: body,
        ),
      );
    }
    return body;
  }

  static String _moneyInput(int cents) {
    final dollars = cents ~/ 100;
    final remainder = cents % 100;
    if (remainder == 0) return dollars.toString();
    if (remainder % 10 == 0) return '$dollars.${remainder ~/ 10}';
    return '$dollars.${remainder.toString().padLeft(2, '0')}';
  }
}
