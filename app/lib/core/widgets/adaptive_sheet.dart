import 'package:flutter/material.dart';

import 'package:app/core/constants/breakpoints.dart';
import 'package:app/core/widgets/loading_button.dart';

Future<T?> showAdaptiveFormSheet<T>({
  required BuildContext context,
  required WidgetBuilder builder,
}) async {
  final wide = MediaQuery.sizeOf(context).width >= Breakpoints.wide;
  if (wide) {
    return showDialog<T>(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        insetPadding: const EdgeInsets.all(24),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 560),
          child: builder(context),
        ),
      ),
    );
  }

  final height = MediaQuery.sizeOf(context).height;
  return showModalBottomSheet<T>(
    context: context,
    isScrollControlled: true,
    enableDrag: false,
    isDismissible: false,
    useSafeArea: true,
    builder: (context) => SizedBox(height: height, child: builder(context)),
  );
}

class FormSheetScaffold extends StatelessWidget {
  const FormSheetScaffold({
    required this.title,
    required this.fields,
    required this.primaryLabel,
    required this.isSubmitting,
    required this.onCancel,
    required this.onPrimary,
    this.bottom,
    this.readOnly = false,
    super.key,
  });

  final String title;
  final Widget fields;
  final String primaryLabel;
  final bool isSubmitting;
  final VoidCallback onCancel;
  final VoidCallback? onPrimary;
  final Widget? bottom;
  final bool readOnly;

  @override
  Widget build(BuildContext context) {
    final wide = MediaQuery.sizeOf(context).width >= Breakpoints.wide;

    final actions = Padding(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: isSubmitting ? null : onCancel,
              child: Text(readOnly ? 'Close' : 'Cancel'),
            ),
          ),
          if (!readOnly) ...[
            const SizedBox(width: 12),
            Expanded(
              child: LoadingButton(
                label: primaryLabel,
                isLoading: isSubmitting,
                onPressed: onPrimary,
              ),
            ),
          ],
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

    final scrollable = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        fields,
        if (bottom != null) ...[const SizedBox(height: 24), bottom!],
      ],
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
                  child: scrollable,
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
                  child: scrollable,
                ),
              ),
              actions,
            ],
          );

    return Material(
      color: Theme.of(context).colorScheme.surface,
      child: SafeArea(
        child: PopScope(
          canPop: !isSubmitting,
          onPopInvokedWithResult: (didPop, result) async {
            if (didPop || isSubmitting) return;
            onCancel();
          },
          child: body,
        ),
      ),
    );
  }
}
