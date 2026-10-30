import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:app/features/projects/domain/project_view.dart';
import 'package:app/features/projects/presentation/controllers/project.dart';
import 'package:app/features/projects/presentation/controllers/projects_table.dart';

void main() {
  ProviderContainer container() {
    return ProviderContainer(retry: (count, error) => null);
  }

  test('defaults to Active', () {
    final c = container();
    addTearDown(c.dispose);
    expect(c.read(projectsTableControllerProvider).view, ProjectView.active);
    expect(c.read(projectsTableControllerProvider).pageIndex, 0);
  });

  test('switching view resets the page', () {
    final c = container();
    addTearDown(c.dispose);
    final notifier = c.read(projectsTableControllerProvider.notifier);
    notifier.goToPage(2);
    notifier.setView(ProjectView.archived);

    expect(c.read(projectsTableControllerProvider).view, ProjectView.archived);
    expect(c.read(projectsTableControllerProvider).pageIndex, 0);
  });

  test('the view survives a round trip to the project page', () {
    final c = container();
    addTearDown(c.dispose);
    c.read(projectsTableControllerProvider.notifier).setView(
      ProjectView.archived,
    );

    c.invalidate(projectProvider('project-melgar'));

    expect(c.read(projectsTableControllerProvider).view, ProjectView.archived);
  });
}
