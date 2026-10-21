@Tags(<String>['contract'])
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:app/core/domain/money.dart';
import 'package:app/core/domain/quantity.dart';
import 'package:app/features/clients/data/clients_repository.dart';
import 'package:app/features/estimates/data/jobs_repository.dart';
import 'package:app/features/estimates/data/models.dart';
import 'package:app/features/estimates/domain/job_type.dart';
import 'package:app/features/estimates/domain/labor.dart';
import 'package:app/features/projects/data/projects_repository.dart';

import 'clean_up.dart';
import 'helpers.dart';

void main() {
  SupabaseClient? supabase;
  late JobsRepository repository;
  late ProjectsRepository projects;
  late ClientsRepository clients;
  late ContractCleanup cleanup;

  setUpAll(() async {
    supabase = await signInAsSeededOwner();
    repository = JobsRepository(supabase!);
    projects = ProjectsRepository(supabase!);
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

  Future<String> arrangeProject() async {
    final created = await createUniqueProject(
      projects: projects,
      clients: clients,
    );
    cleanup.trackClient(created.clientId);
    cleanup.trackProject(created.projectId);
    return created.projectId;
  }

  group('JobsRepository.fetchForProject', () {
    test('returns Quality Deck jobs with lines and hides other businesses', () async {
      final jobs = await repository.fetchForProject(SeedProjects.anaOakId);

      expect(jobs, isNotEmpty);
      expect(jobs.map((row) => row.job.id), contains(SeedJobs.backDeckId));
      expect(jobs.first.job.id, SeedJobs.backDeckId);
      expect(jobs.first.job.number, 1);
      expect(jobs.first.job.title, 'Back deck');
      expect(jobs.first.job.jobType, JobType.deck);
      expect(jobs.first.job.labor?.hours, const Quantity(1250));
      expect(jobs.first.job.labor?.rate, const Money(6500));
      expect(jobs[1].job.id, SeedJobs.frontStepsId);
      expect(jobs[1].job.number, 2);
      expect(jobs[1].job.labor?.rate, const Money(7000));
      expect(
        jobs.first.lines.any((line) => line.id == SeedLineItems.compositeId),
        isTrue,
      );
      expect(
        jobs.first.lines.any(
          (line) => line.id == SeedLineItems.deletedPriceItemLineId,
        ),
        isTrue,
      );
      final deleted = jobs.first.lines.firstWhere(
        (line) => line.id == SeedLineItems.deletedPriceItemLineId,
      );
      expect(deleted.priceItemDeleted, isTrue);
      expect(deleted.savedPrice, const Money(600));

      final other = await repository.fetchForProject(
        SeedProjects.otherCoProjectId,
      );
      expect(other, isEmpty);
    });

    test('returns an empty list when the project has no jobs', () async {
      final projectId = await arrangeProject();

      expect(await repository.fetchForProject(projectId), isEmpty);
    });
  });

  group('JobsRepository.create', () {
    test('inserts a job that the next fetch returns, numbered in add order', () async {
      final projectId = await arrangeProject();
      final stamp = uniqueStamp();

      final created = await repository.create(
        CreateJobCommand(
          projectId: projectId,
          title: '  CT Stair rebuild $stamp  ',
          jobType: JobType.deck,
          description: 'Rebuild the stairs',
        ),
      );

      expect(created.id, isUuid);
      expect(created.title, 'CT Stair rebuild $stamp');
      expect(created.jobType, JobType.deck);
      expect(created.description, 'Rebuild the stairs');
      expect(created.labor, isNull);

      await repository.create(
        CreateJobCommand(
          projectId: projectId,
          title: 'CT Patio $stamp',
          jobType: JobType.patio,
        ),
      );

      final fetched = await repository.fetchForProject(projectId);
      expect(fetched, hasLength(2));
      expect(fetched[0].job.number, 1);
      expect(fetched[0].job.title, 'CT Stair rebuild $stamp');
      expect(fetched[1].job.number, 2);
      expect(fetched[1].job.jobType, JobType.patio);
      expect(fetched[1].lines, isEmpty);
    });
  });

  group('JobsRepository.update', () {
    test('persists edits that the next fetch returns', () async {
      final projectId = await arrangeProject();
      final stamp = uniqueStamp();
      final created = await repository.create(
        CreateJobCommand(
          projectId: projectId,
          title: 'CT before $stamp',
          jobType: JobType.deck,
          description: 'Before',
        ),
      );

      await repository.update(
        UpdateJobCommand(
          id: created.id,
          title: 'CT after $stamp',
          jobType: JobType.hardscaping,
          description: 'After',
        ),
      );

      final fetched = (await repository.fetchForProject(projectId)).single;
      expect(fetched.job.title, 'CT after $stamp');
      expect(fetched.job.jobType, JobType.hardscaping);
      expect(fetched.job.description, 'After');
    });
  });

  group('JobsRepository.delete', () {
    test('removes the job and renumbers the rest', () async {
      final projectId = await arrangeProject();
      final first = await repository.create(
        CreateJobCommand(
          projectId: projectId,
          title: 'CT first ${uniqueStamp()}',
          jobType: JobType.deck,
        ),
      );
      await repository.create(
        CreateJobCommand(
          projectId: projectId,
          title: 'CT second ${uniqueStamp()}',
          jobType: JobType.patio,
        ),
      );

      await repository.delete(first.id);

      final fetched = await repository.fetchForProject(projectId);
      expect(fetched, hasLength(1));
      expect(fetched.single.job.number, 1);
      expect(fetched.single.job.title, startsWith('CT second'));
    });
  });

  group('JobsRepository.setLabor', () {
    test('adds labor and clearing it removes the row', () async {
      final projectId = await arrangeProject();
      final job = await repository.create(
        CreateJobCommand(
          projectId: projectId,
          title: 'CT labor ${uniqueStamp()}',
          jobType: JobType.deck,
        ),
      );

      await repository.setLabor(
        job.id,
        const Labor(hours: Quantity(1250), rate: Money(6500)),
      );

      var fetched = (await repository.fetchForProject(projectId)).single;
      expect(fetched.job.labor?.hours, const Quantity(1250));
      expect(fetched.job.labor?.rate, const Money(6500));
      expect(fetched.job.labor?.total, const Money(81250));

      await repository.setLabor(job.id, null);

      fetched = (await repository.fetchForProject(projectId)).single;
      expect(fetched.job.labor, isNull);
    });
  });
}
