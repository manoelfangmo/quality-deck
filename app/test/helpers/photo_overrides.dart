import 'package:flutter_riverpod/misc.dart';

import 'package:app/features/onsite/data/job_photo_providers.dart';
import 'package:app/features/proposals/data/proposal_export_providers.dart';

import '../features/onsite/fakes.dart';
import '../features/proposals/fakes.dart';

List<Override> jobPhotoTestOverrides({
  FakeJobPhotoRepository? repo,
  FakePhotoStorage? storage,
  FakeLeaveGuard? leaveGuard,
}) {
  return [
    jobPhotoRepositoryProvider.overrideWithValue(
      repo ?? FakeJobPhotoRepository(),
    ),
    photoStorageProvider.overrideWithValue(storage ?? FakePhotoStorage()),
    leaveGuardProvider.overrideWithValue(leaveGuard ?? FakeLeaveGuard()),
    proposalExportsRepositoryProvider.overrideWithValue(
      FakeProposalExportsRepository(),
    ),
    proposalExportServiceProvider.overrideWithValue(
      FakeProposalExportService(),
    ),
    pdfFileHandlerProvider.overrideWithValue(FakePdfFileHandler()),
  ];
}
