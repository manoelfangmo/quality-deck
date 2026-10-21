import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:app/core/domain/app_exception.dart';
import 'package:app/features/estimates/data/line_items_repository.dart';
import 'package:app/features/estimates/presentation/controllers/line_reorder.dart';
import 'package:app/features/estimates/presentation/controllers/project_jobs.dart';

import '../../../../helpers/fixtures.dart';
import '../../../../mocks.dart';

void main() {
  late MockLineItemsRepository lines;

  ProviderContainer container() {
    return ProviderContainer(
      retry: (count, error) => null,
      overrides: [
        lineItemsRepositoryProvider.overrideWithValue(lines),
        projectJobsProvider(backDeckJob.projectId).overrideWith(
          (ref) async => [backDeckWithLines],
        ),
      ],
    );
  }

  setUp(() {
    lines = MockLineItemsRepository();
  });

  test('optimistic order, RPC with the full id list, revert on failure', () async {
    when(lines.reorder(any, any)).thenThrow(const AppException('nope'));

    final c = container();
    addTearDown(c.dispose);
    final ids = backDeckWithLines.lines.map((line) => line.id).toList();
    final notifier = c.read(
      lineReorderControllerProvider(
        projectId: backDeckJob.projectId,
        jobId: backDeckJob.id,
      ).notifier,
    );

    await notifier.reorder(
      fullIds: ids,
      hiddenIds: {},
      oldIndex: 0,
      newIndex: 2,
    );

    final sent = verify(lines.reorder(backDeckJob.id, captureAny)).captured.single
        as List<String>;
    expect(sent, [ids[1], ids[2], ids[0]]);
    expect(
      c.read(
        lineReorderControllerProvider(
          projectId: backDeckJob.projectId,
          jobId: backDeckJob.id,
        ),
      ).ids,
      isNull,
    );
    expect(
      c
          .read(
            lineReorderControllerProvider(
              projectId: backDeckJob.projectId,
              jobId: backDeckJob.id,
            ),
          )
          .errorMessage,
      'nope',
    );
  });

  test('successful reorder calls the repository with the new id list', () async {
    when(lines.reorder(any, any)).thenAnswer((_) async {});

    final c = container();
    addTearDown(c.dispose);
    final ids = backDeckWithLines.lines.map((line) => line.id).toList();
    await c
        .read(
          lineReorderControllerProvider(
            projectId: backDeckJob.projectId,
            jobId: backDeckJob.id,
          ).notifier,
        )
        .reorder(
          fullIds: ids,
          hiddenIds: {},
          oldIndex: 2,
          newIndex: 0,
        );

    final sent = verify(lines.reorder(backDeckJob.id, captureAny)).captured.single
        as List<String>;
    expect(sent.first, ids.last);
  });
}
