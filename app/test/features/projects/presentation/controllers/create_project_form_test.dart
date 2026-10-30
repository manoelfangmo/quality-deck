import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:app/core/domain/app_exception.dart';
import 'package:app/features/projects/data/models.dart';
import 'package:app/features/projects/data/projects_repository.dart';
import 'package:app/features/projects/domain/project_view.dart';
import 'package:app/features/projects/presentation/controllers/create_project_form.dart';
import 'package:app/features/projects/presentation/controllers/projects_table.dart';

import '../../../../helpers/fixtures.dart';
import '../../../../mocks.dart';

void main() {
  late MockProjectsRepository projects;

  ProviderContainer container() {
    return ProviderContainer(
      retry: (count, error) => null,
      overrides: [
        projectsRepositoryProvider.overrideWithValue(projects),
      ],
    );
  }

  setUp(() {
    projects = MockProjectsRepository();
  });

  test('picking a client fills the address and title', () {
    final c = container();
    addTearDown(c.dispose);
    final notifier = c.read(createProjectFormControllerProvider.notifier);

    notifier.pickClient(anaMelgar);

    final state = c.read(createProjectFormControllerProvider);
    expect(state.street, '12 Oak St');
    expect(state.city, 'Bowie');
    expect(state.state, 'MD');
    expect(state.zip, '20715');
    expect(state.title, 'Melgar – 12 Oak St');
  });

  test('editing the title stops it following the street', () {
    final c = container();
    addTearDown(c.dispose);
    final notifier = c.read(createProjectFormControllerProvider.notifier);
    notifier.pickClient(anaMelgar);
    notifier.setTitle('Custom title');
    notifier.setStreet('99 New St');

    expect(c.read(createProjectFormControllerProvider).title, 'Custom title');
  });

  test('editing the address stops a later client change from overwriting it', () {
    final c = container();
    addTearDown(c.dispose);
    final notifier = c.read(createProjectFormControllerProvider.notifier);
    notifier.pickClient(anaMelgar);
    notifier.setStreet('99 New St');
    notifier.pickClient(jamesWhitaker);

    final state = c.read(createProjectFormControllerProvider);
    expect(state.client, jamesWhitaker);
    expect(state.street, '99 New St');
    expect(state.city, 'Bowie');
  });

  test('a client with no address leaves the fields empty', () {
    final c = container();
    addTearDown(c.dispose);
    final notifier = c.read(createProjectFormControllerProvider.notifier);

    notifier.pickClient(jamesWhitaker);

    final state = c.read(createProjectFormControllerProvider);
    expect(state.street, isEmpty);
    expect(state.city, isEmpty);
    expect(state.state, isEmpty);
    expect(state.zip, isEmpty);
    expect(state.clientHasNoAddress, isTrue);
    expect(state.title, 'Whitaker');
  });

  test('invalid draft does not call create', () async {
    final c = container();
    addTearDown(c.dispose);
    final notifier = c.read(createProjectFormControllerProvider.notifier);

    final id = await notifier.submit();

    expect(id, isNull);
    expect(
      c.read(createProjectFormControllerProvider).clientError,
      'Choose a client or add a new one.',
    );
    verifyNever(projects.create(any));
  });

  test('success returns the new id and switches to Active', () async {
    when(projects.create(any)).thenAnswer((_) async => 'new-project');

    final c = container();
    addTearDown(c.dispose);
    c.read(projectsTableControllerProvider.notifier).setView(
      ProjectView.archived,
    );
    final notifier = c.read(createProjectFormControllerProvider.notifier);
    notifier.pickClient(anaMelgar);

    final id = await notifier.submit();

    expect(id, 'new-project');
    final command =
        verify(projects.create(captureAny)).captured.single as CreateProjectCommand;
    expect(command.clientId, anaMelgar.id);
    expect(command.title, 'Melgar – 12 Oak St');
    expect(c.read(projectsTableControllerProvider).view, ProjectView.active);
  });

  test('client_not_found uses the create-form copy', () async {
    when(projects.create(any)).thenThrow(const AppException.clientNotFound());

    final c = container();
    addTearDown(c.dispose);
    final notifier = c.read(createProjectFormControllerProvider.notifier);
    notifier.pickClient(anaMelgar);

    final id = await notifier.submit();

    expect(id, isNull);
    expect(
      c.read(createProjectFormControllerProvider).errorMessage,
      'That client was removed. Choose another client.',
    );
  });
}
