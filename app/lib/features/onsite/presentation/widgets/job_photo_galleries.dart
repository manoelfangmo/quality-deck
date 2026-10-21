import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:app/features/onsite/domain/photo_kind.dart';
import 'package:app/features/onsite/presentation/controllers/job_photos.dart';
import 'package:app/features/onsite/presentation/widgets/job_photo_gallery.dart';

class JobPhotoGalleries extends ConsumerWidget {
  const JobPhotoGalleries({
    required this.jobId,
    required this.readOnly,
    super.key,
  });

  final String jobId;
  final bool readOnly;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    listenToJobPhotoNotices(context: context, ref: ref, jobId: jobId);
    final view = ref.watch(jobPhotosControllerProvider(jobId));
    final status = view.uploadStatus;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (status != null) ...[
          Semantics(
            liveRegion: true,
            child: Text(status, style: Theme.of(context).textTheme.bodySmall),
          ),
          const SizedBox(height: 12),
        ],
        for (final kind in PhotoKind.values) ...[
          JobPhotoGallery(jobId: jobId, kind: kind, readOnly: readOnly),
          const SizedBox(height: 16),
        ],
      ],
    );
  }
}
