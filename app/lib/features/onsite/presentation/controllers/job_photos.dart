import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:app/core/domain/app_exception.dart';
import 'package:app/features/auth/presentation/controllers/current_user.dart';
import 'package:app/features/onsite/application/add_job_photos.dart';
import 'package:app/features/onsite/application/camera_permission.dart';
import 'package:app/features/onsite/application/photo_picker.dart';
import 'package:app/features/onsite/data/job_photo_providers.dart';
import 'package:app/features/onsite/domain/compressed_photo.dart';
import 'package:app/features/onsite/domain/job_photo.dart';
import 'package:app/features/onsite/domain/job_photo_limits.dart';
import 'package:app/features/onsite/domain/photo_kind.dart';
import 'package:app/features/onsite/domain/picked_photo.dart';
import 'package:app/features/onsite/presentation/models/job_photos_view.dart';
import 'package:app/features/onsite/presentation/models/pending_photo.dart';

part 'job_photos.g.dart';

@Riverpod(keepAlive: true)
class PhotoUploadsInProgress extends _$PhotoUploadsInProgress {
  @override
  int build() => 0;

  void setCount(int count) => state = count;
}

@riverpod
class JobPhotosController extends _$JobPhotosController {
  final _cancelled = <String>{};
  final _process = _SerialQueue();
  final _uploads = _Semaphore(JobPhotoLimits.maxConcurrentUploads);
  var _localSeq = 0;
  var _hiddenIds = <String>{};

  @override
  JobPhotosView build(String jobId) {
    final guard = ref.watch(leaveGuardProvider);
    guard.onBackgrounded = _onBackgrounded;
    ref.onDispose(() {
      guard.setUploadsInProgress(false);
      guard.onBackgrounded = null;
    });
    Future.microtask(_load);
    return const JobPhotosView();
  }

  Future<void> _load() async {
    try {
      final photos = await ref
          .read(jobPhotoRepositoryProvider)
          .listByJob(jobId);
      if (!ref.mounted) return;
      final urls = <String, String>{};
      for (final photo in photos) {
        try {
          urls[photo.id] = await ref
              .read(photoStorageProvider)
              .signedUrl(photo.storagePath, JobPhotoLimits.signedUrlTtl);
        } catch (_) {}
      }
      if (!ref.mounted) return;
      state = state.copyWith(saved: photos, urls: urls, loading: false);
    } catch (_) {
      if (!ref.mounted) return;
      state = state.copyWith(loading: false);
    }
  }

  Future<void> takePhoto(PhotoKind kind) => _pick(kind, PhotoPickSource.camera);

  Future<void> choosePhotos(PhotoKind kind) =>
      _pick(kind, PhotoPickSource.library);

  Future<void> _pick(PhotoKind kind, PhotoPickSource source) async {
    state = state.copyWith(notice: null, cameraDenied: false);
    if (source == PhotoPickSource.camera) {
      final access = await ref.read(cameraPermissionProvider).check();
      if (access == CameraAccess.denied) {
        state = state.copyWith(cameraDenied: true);
        return;
      }
    }

    final remaining = state.remaining(kind);
    if (remaining <= 0) {
      state = state.copyWith(notice: AppException.photoLimitReached().message);
      return;
    }

    final picked = await ref
        .read(photoPickerProvider)
        .pick(source, limit: remaining);
    if (picked.isEmpty) return;

    var skipped = 0;
    var files = picked;
    if (files.length > remaining) {
      skipped += files.length - remaining;
      files = files.take(remaining).toList();
    }

    state = state.copyWith(
      batchSize: state.hasActiveUploads
          ? state.batchSize + files.length
          : files.length,
      batchFinished: state.hasActiveUploads ? state.batchFinished : 0,
    );
    for (final file in files) {
      unawaited(_addOne(kind, file));
    }
    if (skipped > 0) {
      state = state.copyWith(
        notice: skipped == 1
            ? '1 photo was skipped because this gallery is limited to 10.'
            : '$skipped photos were skipped because this gallery is limited to 10.',
      );
    }
  }

  Future<void> _addOne(PhotoKind kind, PickedPhoto file) async {
    final localId = 'local-${_localSeq++}';
    state = state.copyWith(
      pending: [
        ...state.pending,
        PendingPhoto(
          localId: localId,
          kind: kind,
          status: PendingPhotoStatus.processing,
        ),
      ],
      loading: false,
    );
    _syncLeaveGuard();

    CompressedPhoto? compressed;
    try {
      compressed = await _process.enqueue(
        () => ref.read(addJobPhotosProvider).process(file),
      );
    } on AppException catch (error) {
      if (error.token == 'invalid_photo_type' ||
          error.token == 'photo_too_large') {
        _removePending(localId);
        _finishBatchItem();
        if (ref.mounted) state = state.copyWith(notice: error.message);
        return;
      }
      _fail(localId, error.message);
      return;
    } catch (_) {
      _fail(localId, const AppException.invalidPhotoType().message);
      return;
    }

    if (_cancelled.contains(localId) || !ref.mounted) return;
    _updatePending(
      localId,
      (pending) => pending.copyWith(
        status: PendingPhotoStatus.uploading,
        preview: compressed!.bytes,
        compressed: compressed,
        error: null,
      ),
    );

    await _uploads.acquire();
    try {
      if (_cancelled.contains(localId) || !ref.mounted) return;
      final businessId = ref
          .read(currentUserProvider)
          .value
          ?.membership
          ?.businessId;
      if (businessId == null) {
        _fail(localId, const AppException.uploadFailed().message);
        return;
      }
      final saved = await ref
          .read(addJobPhotosProvider)
          .save(
            jobId: jobId,
            businessId: businessId,
            kind: kind,
            compressed: compressed!,
            isCancelled: () => _cancelled.contains(localId),
          );
      if (!ref.mounted) return;
      await _attachSaved(localId, saved.photo);
    } on CancelledUpload {
      _removePending(localId);
      _finishBatchItem();
    } on AppException catch (error) {
      _fail(localId, error.message, compressed: compressed);
    } catch (_) {
      _fail(
        localId,
        const AppException.uploadFailed().message,
        compressed: compressed,
      );
    } finally {
      _uploads.release();
      _syncLeaveGuard();
    }
  }

  Future<void> retry(String localId) async {
    PendingPhoto? pending;
    for (final photo in state.pending) {
      if (photo.localId == localId) pending = photo;
    }
    if (pending == null || pending.compressed == null) return;
    _cancelled.remove(localId);
    _updatePending(
      localId,
      (photo) =>
          photo.copyWith(status: PendingPhotoStatus.uploading, error: null),
    );
    _syncLeaveGuard();

    await _uploads.acquire();
    try {
      final businessId = ref
          .read(currentUserProvider)
          .value
          ?.membership
          ?.businessId;
      if (businessId == null) {
        _fail(localId, const AppException.uploadFailed().message);
        return;
      }
      final saved = await ref
          .read(addJobPhotosProvider)
          .save(
            jobId: jobId,
            businessId: businessId,
            kind: pending.kind,
            compressed: pending.compressed!,
            isCancelled: () => _cancelled.contains(localId),
          );
      if (!ref.mounted) return;
      await _attachSaved(localId, saved.photo);
    } on CancelledUpload {
      _removePending(localId);
      _finishBatchItem();
    } on AppException catch (error) {
      _fail(localId, error.message, compressed: pending.compressed);
    } catch (_) {
      _fail(
        localId,
        const AppException.uploadFailed().message,
        compressed: pending.compressed,
      );
    } finally {
      _uploads.release();
      _syncLeaveGuard();
    }
  }

  void cancel(String localId) {
    _cancelled.add(localId);
    _removePending(localId);
    _finishBatchItem();
    _syncLeaveGuard();
  }

  void removeFailed(String localId) {
    _removePending(localId);
  }

  Future<void> deleteSaved(JobPhoto photo) async {
    _hiddenIds = {..._hiddenIds, photo.id};
    state = state.copyWith(
      saved: state.saved.where((row) => row.id != photo.id).toList(),
      deleteError: null,
    );
    try {
      await ref.read(deleteJobPhotoProvider).call(photo);
      _hiddenIds.remove(photo.id);
    } on AppException catch (error) {
      _hiddenIds.remove(photo.id);
      if (!ref.mounted) return;
      state = state.copyWith(
        saved: [...state.saved, photo]
          ..sort((a, b) => a.createdAt.compareTo(b.createdAt)),
        deleteError: error.message,
      );
    } catch (_) {
      _hiddenIds.remove(photo.id);
      if (!ref.mounted) return;
      state = state.copyWith(
        saved: [...state.saved, photo]
          ..sort((a, b) => a.createdAt.compareTo(b.createdAt)),
        deleteError: 'Something went wrong.',
      );
    }
  }

  Future<void> openSettings() {
    return ref.read(cameraPermissionProvider).openSettings();
  }

  void _onBackgrounded() {
    final failed = [
      for (final photo in state.pending)
        if (photo.status == PendingPhotoStatus.processing ||
            photo.status == PendingPhotoStatus.uploading)
          photo.copyWith(
            status: PendingPhotoStatus.failed,
            error: const AppException.uploadFailed().message,
          )
        else
          photo,
    ];
    for (final photo in state.pending) {
      if (photo.status != PendingPhotoStatus.failed) {
        _cancelled.add(photo.localId);
      }
    }
    state = state.copyWith(pending: failed);
    _syncLeaveGuard();
  }

  Future<void> _attachSaved(String localId, JobPhoto photo) async {
    String? url;
    try {
      url = await ref
          .read(photoStorageProvider)
          .signedUrl(photo.storagePath, JobPhotoLimits.signedUrlTtl);
    } catch (_) {}
    if (!ref.mounted) return;
    _removePending(localId);
    state = state.copyWith(
      saved: [...state.saved, photo],
      urls: url == null ? state.urls : {...state.urls, photo.id: url},
    );
    _finishBatchItem();
  }

  void _fail(String localId, String message, {CompressedPhoto? compressed}) {
    if (!ref.mounted) return;
    _updatePending(
      localId,
      (photo) => photo.copyWith(
        status: PendingPhotoStatus.failed,
        error: message,
        compressed: compressed,
        preview: compressed?.bytes ?? photo.preview,
      ),
    );
    _finishBatchItem();
    _syncLeaveGuard();
  }

  void _finishBatchItem() {
    if (!ref.mounted) return;
    final finished = state.batchFinished + 1;
    if (!state.hasActiveUploads) {
      state = state.copyWith(batchSize: 0, batchFinished: 0);
    } else {
      state = state.copyWith(batchFinished: finished);
    }
  }

  void _removePending(String localId) {
    if (!ref.mounted) return;
    state = state.copyWith(
      pending: state.pending
          .where((photo) => photo.localId != localId)
          .toList(),
    );
  }

  void _updatePending(
    String localId,
    PendingPhoto Function(PendingPhoto photo) update,
  ) {
    if (!ref.mounted) return;
    state = state.copyWith(
      pending: [
        for (final photo in state.pending)
          if (photo.localId == localId) update(photo) else photo,
      ],
    );
  }

  void _syncLeaveGuard() {
    if (!ref.mounted) return;
    final count = state.activeUploadCount;
    ref.read(photoUploadsInProgressProvider.notifier).setCount(count);
    ref.read(leaveGuardProvider).setUploadsInProgress(count > 0);
  }
}

class _SerialQueue {
  Future<void> _tail = Future.value();

  Future<T> enqueue<T>(Future<T> Function() work) {
    final done = Completer<T>();
    _tail = _tail.then((_) async {
      try {
        done.complete(await work());
      } catch (error, stackTrace) {
        done.completeError(error, stackTrace);
      }
    });
    return done.future;
  }
}

class _Semaphore {
  _Semaphore(this._max);

  final int _max;
  var _inUse = 0;
  final _waiters = <Completer<void>>[];

  Future<void> acquire() async {
    if (_inUse < _max) {
      _inUse++;
      return;
    }
    final waiter = Completer<void>();
    _waiters.add(waiter);
    await waiter.future;
  }

  void release() {
    if (_waiters.isNotEmpty) {
      _waiters.removeAt(0).complete();
    } else {
      _inUse--;
    }
  }
}
