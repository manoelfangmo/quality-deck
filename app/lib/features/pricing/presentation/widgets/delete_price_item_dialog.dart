import 'package:flutter/material.dart';

class DeletePriceItemDialog extends StatelessWidget {
  const DeletePriceItemDialog({required this.name, super.key});

  final String name;

  @override
  Widget build(BuildContext context) {
    final error = Theme.of(context).colorScheme.error;
    return AlertDialog(
      title: Text('Delete $name?'),
      content: const Text(
        "This can't be undone. Estimates that already use it won't change.",
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          style: TextButton.styleFrom(foregroundColor: error),
          child: const Text('Delete'),
        ),
      ],
    );
  }
}

Future<bool> showDeletePriceItemDialog({
  required BuildContext context,
  required String name,
}) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (context) => DeletePriceItemDialog(name: name),
  );
  return result ?? false;
}
