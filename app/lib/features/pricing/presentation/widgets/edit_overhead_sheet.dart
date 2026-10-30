import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:app/core/constants/breakpoints.dart';
import 'package:app/core/utils/toasts.dart';
import 'package:app/core/widgets/loading_button.dart';
import 'package:app/features/pricing/domain/pricing_settings.dart';
import 'package:app/features/pricing/presentation/controllers/pricing_settings.dart';

Future<bool> showEditOverheadSheet(
  BuildContext context, {
  PricingSettings? settings,
}) async {
  final wide = MediaQuery.sizeOf(context).width >= Breakpoints.wide;
  if (wide) {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => EditOverheadSheet(settings: settings),
    );
    return result ?? false;
  }

  final result = await showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (context) => Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: EditOverheadSheet(settings: settings),
    ),
  );
  return result ?? false;
}

class EditOverheadSheet extends ConsumerStatefulWidget {
  const EditOverheadSheet({this.settings, super.key});

  final PricingSettings? settings;

  @override
  ConsumerState<EditOverheadSheet> createState() => _EditOverheadSheetState();
}

class _EditOverheadSheetState extends ConsumerState<EditOverheadSheet> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    final bps = widget.settings?.overhead?.basisPoints;
    _controller = TextEditingController(
      text: bps == null ? '' : _percentInput(bps),
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
        .saveOverhead(_controller.text);
    if (!saved || !mounted) return;
    AppSnackbars.show(context, 'Overhead updated');
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
            'Project overhead',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _controller,
            autofocus: true,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            enabled: !action.isSavingOverhead,
            decoration: InputDecoration(
              labelText: 'Overhead',
              suffixText: '%',
              errorText: action.overheadError ?? action.errorMessage,
            ),
            onSubmitted: (_) => _save(),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: action.isSavingOverhead
                      ? null
                      : () => Navigator.of(context).pop(false),
                  child: const Text('Cancel'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: LoadingButton(
                  label: 'Save',
                  isLoading: action.isSavingOverhead,
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

  static String _percentInput(int basisPoints) {
    final whole = basisPoints ~/ 100;
    final fraction = basisPoints % 100;
    if (fraction == 0) return whole.toString();
    if (fraction % 10 == 0) return '$whole.${fraction ~/ 10}';
    return '$whole.${fraction.toString().padLeft(2, '0')}';
  }
}
