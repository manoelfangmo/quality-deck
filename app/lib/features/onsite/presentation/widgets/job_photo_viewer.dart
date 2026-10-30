import 'package:flutter/material.dart';

import 'package:app/features/onsite/domain/job_photo.dart';
import 'package:app/features/onsite/presentation/widgets/delete_photo_dialog.dart';
import 'package:app/features/onsite/presentation/widgets/job_photo_tile.dart';

class JobPhotoViewer extends StatefulWidget {
  const JobPhotoViewer({
    required this.photos,
    required this.urls,
    required this.initialIndex,
    required this.readOnly,
    required this.onDelete,
    super.key,
  });

  final List<JobPhoto> photos;
  final Map<String, String> urls;
  final int initialIndex;
  final bool readOnly;
  final Future<void> Function(JobPhoto photo) onDelete;

  @override
  State<JobPhotoViewer> createState() => _JobPhotoViewerState();
}

class _JobPhotoViewerState extends State<JobPhotoViewer> {
  late final PageController _controller;
  late int _index;

  @override
  void initState() {
    super.initState();
    _index = widget.initialIndex;
    _controller = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final photos = widget.photos;
    if (photos.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (context.mounted) Navigator.of(context).pop();
      });
      return const SizedBox.shrink();
    }
    final index = _index.clamp(0, photos.length - 1);
    final photo = photos[index];
    final url = widget.urls[photo.id];

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            PageView.builder(
              controller: _controller,
              itemCount: photos.length,
              onPageChanged: (value) => setState(() => _index = value),
              itemBuilder: (context, i) {
                final item = photos[i];
                final src = widget.urls[item.id];
                if (src == null) {
                  return const Center(child: CircularProgressIndicator());
                }
                return InteractiveViewer(
                  child: Image.network(src, fit: BoxFit.contain),
                );
              },
            ),
            Positioned(
              top: 0,
              left: 0,
              child: SizedBox(
                width: photoTileMinSize,
                height: photoTileMinSize,
                child: IconButton(
                  tooltip: 'Close',
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close, color: Colors.white),
                ),
              ),
            ),
            if (!widget.readOnly)
              Positioned(
                top: 0,
                right: 0,
                child: SizedBox(
                  width: photoTileMinSize,
                  height: photoTileMinSize,
                  child: IconButton(
                    tooltip: 'Delete photo',
                    onPressed: () => _delete(photo),
                    icon: const Icon(Icons.delete_outline, color: Colors.white),
                  ),
                ),
              ),
            if (url == null) const Center(child: CircularProgressIndicator()),
          ],
        ),
      ),
    );
  }

  Future<void> _delete(JobPhoto photo) async {
    final confirmed = await showDeletePhotoDialog(context);
    if (!confirmed) return;
    await widget.onDelete(photo);
    if (!mounted) return;
    if (widget.photos.length <= 1) {
      Navigator.of(context).pop();
    }
  }
}

Future<void> showJobPhotoViewer({
  required BuildContext context,
  required List<JobPhoto> photos,
  required Map<String, String> urls,
  required int initialIndex,
  required bool readOnly,
  required Future<void> Function(JobPhoto photo) onDelete,
}) {
  return Navigator.of(context).push(
    MaterialPageRoute<void>(
      builder: (context) => JobPhotoViewer(
        photos: photos,
        urls: urls,
        initialIndex: initialIndex,
        readOnly: readOnly,
        onDelete: onDelete,
      ),
    ),
  );
}
