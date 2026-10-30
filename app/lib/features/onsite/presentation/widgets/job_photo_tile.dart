import 'dart:typed_data';

import 'package:flutter/material.dart';

import 'package:app/features/onsite/domain/job_photo.dart';
import 'package:app/features/onsite/presentation/models/pending_photo.dart';

const photoTileMinSize = 44.0;

class SavedPhotoTile extends StatelessWidget {
  const SavedPhotoTile({
    required this.photo,
    this.image,
    required this.readOnly,
    required this.onOpen,
    required this.onDelete,
    super.key,
  });

  final JobPhoto photo;
  final ImageProvider? image;
  final bool readOnly;
  final VoidCallback onOpen;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Photo, ${photo.kind.label}',
      button: true,
      child: Stack(
        fit: StackFit.expand,
        children: [
          InkWell(
            onTap: onOpen,
            child: _Thumb(image: image),
          ),
          if (!readOnly)
            Positioned(
              top: 0,
              right: 0,
              child: _TileIconButton(
                tooltip: 'Delete photo',
                icon: Icons.delete_outline,
                onPressed: onDelete,
              ),
            ),
        ],
      ),
    );
  }
}

class PendingPhotoTile extends StatelessWidget {
  const PendingPhotoTile({
    required this.photo,
    required this.onCancel,
    required this.onRetry,
    required this.onRemove,
    super.key,
  });

  final PendingPhoto photo;
  final VoidCallback onCancel;
  final VoidCallback onRetry;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final failed = photo.status == PendingPhotoStatus.failed;
    final label = failed
        ? 'Upload failed'
        : photo.status == PendingPhotoStatus.uploading
        ? 'Uploading photo'
        : 'Processing photo';
    return Semantics(
      label: label,
      liveRegion: true,
      child: Stack(
        fit: StackFit.expand,
        children: [
          _Thumb(
            memory: photo.preview,
            overlay: failed
                ? _FailedOverlay(onRetry: onRetry, onRemove: onRemove)
                : const ColoredBox(
                    color: Color(0x66000000),
                    child: Center(
                      child: SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    ),
                  ),
          ),
          if (!failed)
            Positioned(
              top: 0,
              right: 0,
              child: _TileIconButton(
                tooltip: 'Cancel upload',
                icon: Icons.close,
                onPressed: onCancel,
              ),
            ),
        ],
      ),
    );
  }
}

class _FailedOverlay extends StatelessWidget {
  const _FailedOverlay({required this.onRetry, required this.onRemove});

  final VoidCallback onRetry;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return ColoredBox(
      color: const Color(0x99000000),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Upload failed',
            style: Theme.of(context).textTheme.labelMedium
                ?.copyWith(color: scheme.onError),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Wrap(
            spacing: 4,
            alignment: WrapAlignment.center,
            children: [
              _TileTextButton(label: 'Retry', onPressed: onRetry),
              _TileTextButton(label: 'Remove', onPressed: onRemove),
            ],
          ),
        ],
      ),
    );
  }
}

class _Thumb extends StatelessWidget {
  const _Thumb({this.image, this.memory, this.overlay});

  final ImageProvider? image;
  final Uint8List? memory;
  final Widget? overlay;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    Widget child;
    if (memory != null) {
      child = Image.memory(memory!, fit: BoxFit.cover);
    } else if (image != null) {
      child = Image(image: image!, fit: BoxFit.cover);
    } else {
      child = ColoredBox(color: scheme.surfaceContainerHighest);
    }
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Stack(
        fit: StackFit.expand,
        children: [child, ?overlay],
      ),
    );
  }
}

class _TileIconButton extends StatelessWidget {
  const _TileIconButton({
    required this.tooltip,
    required this.icon,
    required this.onPressed,
  });

  final String tooltip;
  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: photoTileMinSize,
      height: photoTileMinSize,
      child: IconButton(
        tooltip: tooltip,
        onPressed: onPressed,
        icon: Icon(icon, size: 20),
        style: IconButton.styleFrom(
          backgroundColor: Colors.black54,
          foregroundColor: Colors.white,
          minimumSize: const Size(photoTileMinSize, photoTileMinSize),
          tapTargetSize: MaterialTapTargetSize.padded,
        ),
      ),
    );
  }
}

class _TileTextButton extends StatelessWidget {
  const _TileTextButton({required this.label, required this.onPressed});

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: photoTileMinSize,
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          foregroundColor: Colors.white,
          minimumSize: const Size(photoTileMinSize, photoTileMinSize),
          padding: const EdgeInsets.symmetric(horizontal: 8),
        ),
        child: Text(label),
      ),
    );
  }
}
