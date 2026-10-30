import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:app/features/projects/data/models.dart';
import 'package:app/features/projects/data/projects_repository.dart';
import 'package:app/features/projects/domain/project_view.dart';
import 'package:app/features/projects/presentation/controllers/project.dart';
import 'package:app/features/projects/presentation/controllers/project_actions.dart';
import 'package:app/features/projects/presentation/controllers/projects_table.dart';

import '../../../../helpers/fixtures.dart';
import '../../../../mocks.dart';

void main() {
  late MockProjectsRepository projects;

  List<ProjectRow> elevenActive() {
    return [
      melgarOak,
      ...List.generate(10, (i) {
        return ProjectRow(
          id: 'project-$i',
          title: 'Project $i',
          createdAt: DateTime.utc(2026, 10, 15),
          siteAddress: noAppointmentRow.siteAddress,
          clientId: 'client-$i',
          clientName: 'Client $i',
          clientRemoved: false,
        );
      }),
    ];
  }

  ProviderContainer containerWith(List<ProjectRow> list) {
    return ProviderContainer(
      retry: (count, error) => null,
      overrides: [
        projectsRepositoryProvider.overrideWithValue(projects),
        projectRowsProvider(ProjectView.active).overrideWith((ref) async => list),
        projectRowsProvider(
          ProjectView.archived,
        ).overrideWith((ref) async => <ProjectRow>[]),
      ],
    );
  }

  setUp(() {
    projects = MockProjectsRepository();
  });

  test('archive calls the repository and invalidates both views and the project', () async {
    when(projects.archive(melgarOak.id)).thenAnswer((_) async {});
    when(projects.fetchOne(melgarOak.id)).thenAnswer((_) async => archivedMelgar);

    final c = containerWith([melgarOak, whitakerPast]);
    addTearDown(c.dispose);
    c.listen(projectRowsProvider(ProjectView.active), (_, _) {});
    c.listen(projectProvider(melgarOak.id), (_, _) {});
    await c.read(projectRowsProvider(ProjectView.active).future);

    final ok = await c
        .read(projectActionsControllerProvider(melgarOak.id).notifier)
        .archive();

    expect(ok, isTrue);
    verify(projects.archive(melgarOak.id)).called(1);
  });

  test('Undo after archive calls unarchive', () async {
    when(projects.archive(melgarOak.id)).thenAnswer((_) async {});
    when(projects.unarchive(melgarOak.id)).thenAnswer((_) async {});

    final c = containerWith([melgarOak]);
    addTearDown(c.dispose);
    c.listen(projectRowsProvider(ProjectView.active), (_, _) {});
    await c.read(projectRowsProvider(ProjectView.active).future);

    final notifier = c.read(
      projectActionsControllerProvider(melgarOak.id).notifier,
    );
    await notifier.archive();
    await notifier.undoArchive();

    verify(projects.unarchive(melgarOak.id)).called(1);
  });

  test('steps back a page when the page empties', () async {
    when(projects.archive(melgarOak.id)).thenAnswer((_) async {});

    final c = containerWith(elevenActive());
    addTearDown(c.dispose);
    c.listen(projectRowsProvider(ProjectView.active), (_, _) {});
    await c.read(projectRowsProvider(ProjectView.active).future);
    c.read(projectsTableControllerProvider.notifier).goToPage(1);
    expect(c.read(projectsTableControllerProvider).pageIndex, 1);

    await c
        .read(projectActionsControllerProvider(melgarOak.id).notifier)
        .archive();

    expect(c.read(projectsTableControllerProvider).pageIndex, 0);
  });
}
