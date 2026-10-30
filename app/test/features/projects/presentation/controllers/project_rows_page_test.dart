import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:app/features/projects/data/models.dart';
import 'package:app/features/projects/data/projects_repository.dart';
import 'package:app/features/projects/domain/project_view.dart';
import 'package:app/features/projects/presentation/controllers/projects_table.dart';

import '../../../../helpers/fixtures.dart';
import '../../../../mocks.dart';

void main() {
  late MockProjectsRepository projects;

  setUp(() {
    projects = MockProjectsRepository();
  });

  test('passes the view, range, and total', () async {
    when(
      projects.fetchPage(
        view: ProjectView.archived,
        page: 1,
        pageSize: 10,
      ),
    ).thenAnswer(
      (_) async => ProjectPage(projects: [archivedMelgar], total: 25),
    );

    final c = ProviderContainer(
      retry: (count, error) => null,
      overrides: [projectsRepositoryProvider.overrideWithValue(projects)],
    );
    addTearDown(c.dispose);
    c.listen(projectRowsPageProvider((view: ProjectView.archived, page: 1)), (
      _,
      _,
    ) {});

    final page = await c.read(
      projectRowsPageProvider((view: ProjectView.archived, page: 1)).future,
    );

    expect(page.projects, hasLength(1));
    expect(page.projects.single.id, archivedMelgar.id);
    expect(page.total, 25);
    verify(
      projects.fetchPage(view: ProjectView.archived, page: 1, pageSize: 10),
    ).called(1);
  });
}
