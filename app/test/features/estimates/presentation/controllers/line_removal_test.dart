import 'package:fake_async/fake_async.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:app/core/domain/app_exception.dart';
import 'package:app/features/estimates/data/line_items_repository.dart';
import 'package:app/features/estimates/presentation/controllers/line_removal.dart';
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

  test('hides at once and Undo restores without calling the repository', () {
    fakeAsync((async) {
      when(lines.delete(any)).thenAnswer((_) async {});
      final c = container();
      addTearDown(c.dispose);
      c.listen(lineRemovalControllerProvider(backDeckJob.projectId), (_, _) {});
      final notifier = c.read(
        lineRemovalControllerProvider(backDeckJob.projectId).notifier,
      );

      notifier.hide(compositeLine.id);
      expect(
        c.read(lineRemovalControllerProvider(backDeckJob.projectId)).hiddenIds,
        contains(compositeLine.id),
      );

      notifier.undo(compositeLine.id);
      async.elapse(const Duration(seconds: 5));
      verifyNever(lines.delete(any));
      expect(
        c.read(lineRemovalControllerProvider(backDeckJob.projectId)).hiddenIds,
        isEmpty,
      );
    });
  });

  test('after 5 seconds calls delete', () {
    fakeAsync((async) {
      when(lines.delete(any)).thenAnswer((_) async {});
      final c = container();
      addTearDown(c.dispose);
      c.listen(lineRemovalControllerProvider(backDeckJob.projectId), (_, _) {});
      c
          .read(lineRemovalControllerProvider(backDeckJob.projectId).notifier)
          .hide(compositeLine.id);

      async.elapse(const Duration(seconds: 5));
      async.flushMicrotasks();
      verify(lines.delete(compositeLine.id)).called(1);
    });
  });

  test('dispose calls delete', () {
    fakeAsync((async) {
      when(lines.delete(any)).thenAnswer((_) async {});
      final c = container();
      c.listen(lineRemovalControllerProvider(backDeckJob.projectId), (_, _) {});
      c
          .read(lineRemovalControllerProvider(backDeckJob.projectId).notifier)
          .hide(compositeLine.id);
      c.dispose();
      async.flushMicrotasks();
      verify(lines.delete(compositeLine.id)).called(1);
    });
  });

  test('failure restores the line', () {
    fakeAsync((async) {
      when(lines.delete(any)).thenThrow(const AppException('nope'));
      final c = container();
      addTearDown(c.dispose);
      c.listen(lineRemovalControllerProvider(backDeckJob.projectId), (_, _) {});
      c
          .read(lineRemovalControllerProvider(backDeckJob.projectId).notifier)
          .hide(compositeLine.id);

      async.elapse(const Duration(seconds: 5));
      async.flushMicrotasks();
      final state = c.read(lineRemovalControllerProvider(backDeckJob.projectId));
      expect(state.hiddenIds, isEmpty);
      expect(state.errorMessage, 'nope');
    });
  });
}
