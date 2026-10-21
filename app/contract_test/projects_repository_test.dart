@Tags(<String>['contract'])
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:app/core/domain/app_exception.dart';
import 'package:app/core/domain/percent.dart';
import 'package:app/features/clients/data/clients_repository.dart';
import 'package:app/features/projects/data/models.dart';
import 'package:app/features/projects/data/projects_repository.dart';
import 'package:app/features/projects/domain/project_view.dart';

import 'clean_up.dart';
import 'helpers.dart';

void main() {
  SupabaseClient? supabase;
  late ProjectsRepository repository;
  late ClientsRepository clients;
  late ContractCleanup cleanup;

  setUpAll(() async {
    supabase = await signInAsSeededOwner();
    repository = ProjectsRepository(supabase!);
    clients = ClientsRepository(supabase!);
    cleanup = ContractCleanup();
  });

  tearDown(() async {
    await cleanup.teardown();
  });

  tearDownAll(() async {
    await cleanup.dispose();
    await supabase?.auth.signOut();
    await supabase?.dispose();
  });

  group('ProjectsRepository.fetchAll', () {
    test('returns Quality Deck projects and hides other businesses', () async {
      final active = await repository.fetchAll(view: ProjectView.active);

      expect(active, isNotEmpty);
      expect(active.any((row) => row.id == SeedProjects.anaOakId), isTrue);
      expect(
        active.any((row) => row.title == 'A – 10 Main St'),
        isFalse,
      );
      expect(
        active.any((row) => row.id == SeedProjects.archivedBarkerId),
        isFalse,
      );
    });

    test('archived view returns archived projects newest-archived first', () async {
      final archived = await repository.fetchAll(view: ProjectView.archived);

      expect(archived, isNotEmpty);
      expect(
        archived.any((row) => row.id == SeedProjects.archivedBarkerId),
        isTrue,
      );
      expect(archived.any((row) => row.id == SeedProjects.anaOakId), isFalse);
      expect(archived.every((row) => row.isArchived), isTrue);
    });
  });

  group('ProjectsRepository.fetchPage', () {
    test('returns a page of active projects and the total count', () async {
      final page = await repository.fetchPage(
        view: ProjectView.active,
        page: 0,
        pageSize: 10,
      );

      expect(page.projects, hasLength(10));
      expect(page.total, greaterThanOrEqualTo(25));
      expect(page.projects.every((row) => !row.isArchived), isTrue);
    });
  });

  group('ProjectsRepository.fetchOne', () {
    test('returns the client, appointment, and site', () async {
      final row = await repository.fetchOne(SeedProjects.anaOakId);

      expect(row, isNotNull);
      expect(row!.title, 'Melgar – 12 Oak St');
      expect(row.clientName, 'Ana Melgar');
      expect(row.clientRemoved, isFalse);
      expect(row.appointmentStartsAt, isNotNull);
      expect(row.siteAddress.city, 'Bowie');
      expect(row.overhead, const Percent(1250));
    });

    test('marks a removed client and hides their appointment', () async {
      final row = await repository.fetchOne(SeedProjects.removedClientProjectId);

      expect(row, isNotNull);
      expect(row!.clientRemoved, isTrue);
      expect(row.clientName, 'Old Client One');
      expect(row.appointmentStartsAt, isNull);
    });
  });

  group('ProjectsRepository.create', () {
    test('inserts an active project the next fetch returns', () async {
      final client = await createUniqueClient(clients);
      cleanup.trackClient(client.id);
      final stamp = uniqueStamp();

      final id = await repository.create(
        CreateProjectCommand(
          clientId: client.id,
          title: '  CT Project $stamp  ',
          siteStreet: '  99 Test St  ',
          siteCity: '  Bowie  ',
          siteState: 'md',
          siteZip: '20715',
        ),
      );
      cleanup.trackProject(id);

      expect(id, isUuid);
      final fetched = await repository.fetchOne(id);
      expect(fetched, isNotNull);
      expect(fetched!.title, 'CT Project $stamp');
      expect(fetched.siteAddress.state, 'MD');
      expect(fetched.isArchived, isFalse);
      expect(fetched.clientId, client.id);
    });
  });

  group('ProjectsRepository.update', () {
    test('persists title and site on the next fetch', () async {
      final created = await createUniqueProject(
        projects: repository,
        clients: clients,
      );
      cleanup.trackClient(created.clientId);
      cleanup.trackProject(created.projectId);
      final stamp = uniqueStamp();

      await repository.update(
        UpdateProjectCommand(
          id: created.projectId,
          title: '  CT Edited $stamp  ',
          siteStreet: '  88 Pine St  ',
          siteCity: '  Bowie  ',
          siteState: 'md',
          siteZip: '20715',
        ),
      );

      final fetched = await repository.fetchOne(created.projectId);
      expect(fetched, isNotNull);
      expect(fetched!.title, 'CT Edited $stamp');
      expect(fetched.siteAddress.street, '88 Pine St');
      expect(fetched.siteAddress.city, 'Bowie');
      expect(fetched.siteAddress.state, 'MD');
      expect(fetched.siteAddress.zip, '20715');
    });
  });

  group('ProjectsRepository.setOverhead', () {
    test('sets and clears overhead on the next fetch', () async {
      final created = await createUniqueProject(
        projects: repository,
        clients: clients,
      );
      cleanup.trackClient(created.clientId);
      cleanup.trackProject(created.projectId);

      await repository.setOverhead(created.projectId, const Percent(1250));
      var fetched = await repository.fetchOne(created.projectId);
      expect(fetched!.overhead, const Percent(1250));

      await repository.setOverhead(created.projectId, null);
      fetched = await repository.fetchOne(created.projectId);
      expect(fetched!.overhead, isNull);
    });

    test('raises project_archived when the project is archived', () async {
      final created = await createUniqueProject(
        projects: repository,
        clients: clients,
      );
      cleanup.trackClient(created.clientId);
      cleanup.trackProject(created.projectId);
      await repository.archive(created.projectId);

      try {
        await repository.setOverhead(created.projectId, const Percent(1250));
        fail('expected AppException');
      } on AppException catch (error) {
        expect(error.token, 'project_archived');
      }
    });
  });

  group('ProjectsRepository.archive', () {
    test('hides the project from Active and Undo restores it', () async {
      final client = await createUniqueClient(clients);
      cleanup.trackClient(client.id);
      final id = await repository.create(
        CreateProjectCommand(
          clientId: client.id,
          title: 'CT Archive ${uniqueStamp()}',
          siteStreet: '1 Oak St',
          siteCity: 'Bowie',
          siteState: 'MD',
          siteZip: '20715',
        ),
      );
      cleanup.trackProject(id);

      await repository.archive(id);

      final active = await repository.fetchAll(view: ProjectView.active);
      expect(active.any((row) => row.id == id), isFalse);
      final archived = await repository.fetchOne(id);
      expect(archived!.isArchived, isTrue);

      await repository.unarchive(id);
      final restored = await repository.fetchAll(view: ProjectView.active);
      expect(restored.any((row) => row.id == id), isTrue);
    });
  });

  group('ProjectsRepository errors', () {
    test('create for a removed client raises client_not_found', () async {
      try {
        await repository.create(
          CreateProjectCommand(
            clientId: '00000000-0000-4000-8000-000000000131',
            title: 'Should fail',
            siteStreet: '1 Oak St',
            siteCity: 'Bowie',
            siteState: 'MD',
            siteZip: '20715',
          ),
        );
        fail('expected AppException');
      } on AppException catch (error) {
        expect(error.token, 'client_not_found');
      }
    });
  });
}
