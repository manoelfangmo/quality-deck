import 'package:flutter/material.dart';

class RemoveClientDialog extends StatelessWidget {
  const RemoveClientDialog({
    required this.name,
    this.hasAppointment = false,
    super.key,
  });

  final String name;
  final bool hasAppointment;

  @override
  Widget build(BuildContext context) {
    final error = Theme.of(context).colorScheme.error;
    final body = hasAppointment
        ? "They'll be hidden from your client list. Their past projects and appointments are kept.\n\nTheir appointment will be removed too."
        : "They'll be hidden from your client list. Their past projects and appointments are kept.";
    return AlertDialog(
      title: Text('Remove $name?'),
      content: Text(body),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          style: TextButton.styleFrom(foregroundColor: error),
          child: const Text('Remove'),
        ),
      ],
    );
  }
}

Future<bool> showRemoveClientDialog({
  required BuildContext context,
  required String name,
  bool hasAppointment = false,
}) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (context) =>
        RemoveClientDialog(name: name, hasAppointment: hasAppointment),
  );
  return result ?? false;
}
