import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:app/core/utils/toasts.dart';
import 'package:app/features/onsite/domain/job_photo.dart';
import 'package:app/features/onsite/domain/job_photo_limits.dart';
import 'package:app/features/onsite/domain/photo_kind.dart';
import 'package:app/features/onsite/presentation/controllers/job_photos.dart';
import 'package:app/features/onsite/presentation/widgets/delete_photo_dialog.dart';
import 'package:app/features/onsite/presentation/widgets/job_photo_tile.dart';
import 'package:app/features/onsite/presentation/widgets/job_photo_viewer.dart';

class JobPhotoGallery extends ConsumerWidget {
  const JobPhotoGallery({
    required this.jobId,
    required this.kind,
    required this.readOnly,
    super.key,
  });

  final String jobId;
  final PhotoKind kind;
  final bool readOnly;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final view = ref.watch(jobPhotosControllerProvider(jobId));
    final saved = view.savedOf(kind);
    final pending = view.pendingOf(kind);
    final count = saved.length;
    final atLimit = view.remaining(kind) <= 0;
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          '${kind.label} · $count/${JobPhotoLimits.maxPerGallery}',
          style: theme.textTheme.titleSmall,
        ),
        const SizedBox(height: 8),
        if (saved.isEmpty && pending.isEmpty)
          Text(
            kind.emptyMessage,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        if (saved.isNotEmpty || pending.isNotEmpty) ...[
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: saved.length + pending.length,
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 120,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              childAspectRatio: 1,
            ),
            itemBuilder: (context, index) {
              if (index < saved.length) {
                final photo = saved[index];
                final url = view.urls[photo.id];
                return SavedPhotoTile(
                  photo: photo,
                  image: url == null ? null : NetworkImage(url),
                  readOnly: readOnly,
                  onOpen: () => showJobPhotoViewer(
                    context: context,
                    photos: saved,
                    urls: view.urls,
                    initialIndex: index,
                    readOnly: readOnly,
                    onDelete: (item) => _delete(ref, item),
                  ),
                  onDelete: () => _confirmDelete(context, ref, photo),
                );
              }
              final item = pending[index - saved.length];
              return PendingPhotoTile(
                photo: item,
                onCancel: () => ref
                    .read(jobPhotosControllerProvider(jobId).notifier)
                    .cancel(item.localId),
                onRetry: () => ref
                    .read(jobPhotosControllerProvider(jobId).notifier)
                    .retry(item.localId),
                onRemove: () => ref
                    .read(jobPhotosControllerProvider(jobId).notifier)
                    .removeFailed(item.localId),
              );
            },
          ),
        ],
        if (!readOnly) ...[
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              Tooltip(
                message: atLimit
                    ? 'Limit of 10 reached. Delete a photo to add another.'
                    : 'Take photo',
                child: SizedBox(
                  height: photoTileMinSize,
                  child: OutlinedButton.icon(
                    onPressed: atLimit
                        ? null
                        : () => ref
                              .read(jobPhotosControllerProvider(jobId).notifier)
                              .takePhoto(kind),
                    icon: const Icon(Icons.photo_camera_outlined, size: 18),
                    label: const Text('Take photo'),
                  ),
                ),
              ),
              Tooltip(
                message: atLimit
                    ? 'Limit of 10 reached. Delete a photo to add another.'
                    : 'Choose photos',
                child: SizedBox(
                  height: photoTileMinSize,
                  child: OutlinedButton.icon(
                    onPressed: atLimit
                        ? null
                        : () => ref
                              .read(jobPhotosControllerProvider(jobId).notifier)
                              .choosePhotos(kind),
                    icon: const Icon(Icons.photo_library_outlined, size: 18),
                    label: const Text('Choose photos'),
                  ),
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  Future<void> _confirmDelete(
    BuildContext context,
    WidgetRef ref,
    JobPhoto photo,
  ) async {
    final confirmed = await showDeletePhotoDialog(context);
    if (!confirmed || !context.mounted) return;
    await _delete(ref, photo);
  }

  Future<void> _delete(WidgetRef ref, JobPhoto photo) {
    return ref
        .read(jobPhotosControllerProvider(jobId).notifier)
        .deleteSaved(photo);
  }
}

void listenToJobPhotoNotices({
  required BuildContext context,
  required WidgetRef ref,
  required String jobId,
}) {
  ref.listen(jobPhotosControllerProvider(jobId), (previous, next) {
    final notice = next.notice;
    if (notice != null && notice != previous?.notice) {
      AppSnackbars.show(context, notice);
    }
    final deleteError = next.deleteError;
    if (deleteError != null && deleteError != previous?.deleteError) {
      AppSnackbars.show(context, deleteError);
    }
    if (next.cameraDenied && next.cameraDenied != previous?.cameraDenied) {
      showDialog<void>(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Camera access is off'),
            content: const Text('Turn it on in Settings to take photos.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  ref
                      .read(jobPhotosControllerProvider(jobId).notifier)
                      .openSettings();
                },
                child: const Text('Open Settings'),
              ),
            ],
          );
        },
      );
    }
  });
}
