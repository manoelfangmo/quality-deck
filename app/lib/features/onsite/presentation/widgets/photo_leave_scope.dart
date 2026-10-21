import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:app/features/onsite/presentation/controllers/job_photos.dart';

class PhotoLeaveScope extends ConsumerWidget {
  const PhotoLeaveScope({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final inProgress = ref.watch(photoUploadsInProgressProvider) > 0;
    return PopScope(
      canPop: !inProgress,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop || !inProgress) return;
        final leave = await showDialog<bool>(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Photos are still uploading'),
              content: const Text(
                'Leave anyway? Uploads in progress will be lost.',
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('Stay'),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Text('Leave'),
                ),
              ],
            );
          },
        );
        if (leave == true && context.mounted) {
          Navigator.of(context).pop();
        }
      },
      child: child,
    );
  }
}
