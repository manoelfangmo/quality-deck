import 'package:flutter/material.dart';

class DeleteJobDialog extends StatelessWidget {
  const DeleteJobDialog({
    required this.title,
    required this.lineCount,
    super.key,
  });

  final String title;
  final int lineCount;

  @override
  Widget build(BuildContext context) {
    final error = Theme.of(context).colorScheme.error;
    final lines = lineCount == 1 ? '1 line item' : '$lineCount line items';
    return AlertDialog(
      title: Text('Delete $title?'),
      content: Text("Delete $title and its $lines? This can't be undone."),
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

Future<bool> showDeleteJobDialog({
  required BuildContext context,
  required String title,
  required int lineCount,
}) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (context) => DeleteJobDialog(title: title, lineCount: lineCount),
  );
  return result ?? false;
}
