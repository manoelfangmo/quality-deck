import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:app/core/domain/app_exception.dart';
import 'package:app/features/estimates/data/jobs_repository.dart';
import 'package:app/features/estimates/data/models.dart';
import 'package:app/features/estimates/domain/job.dart';
import 'package:app/features/estimates/domain/job_type.dart';
import 'package:app/features/estimates/presentation/controllers/project_jobs.dart';
import 'package:app/features/estimates/presentation/models/job_form_state.dart';
import 'package:app/features/estimates/presentation/validators/estimate_validators.dart';

part 'job_form.g.dart';

@riverpod
class JobFormController extends _$JobFormController {
  late JobFormState _initial;

  @override
  JobFormState build({required String projectId, Job? job}) {
    _initial = job == null ? const JobFormState() : JobFormState.fromJob(job);
    return _initial;
  }

  bool get isDirty =>
      state.title != _initial.title ||
      state.jobType != _initial.jobType ||
      state.description != _initial.description ||
      state.isAlternate != _initial.isAlternate ||
      state.alternateOfJobId != _initial.alternateOfJobId;

  void setTitle(String value) {
    state = state.copyWith(title: value);
    _revalidate();
  }

  void setJobType(JobType? value) {
    state = state.copyWith(jobType: value);
    _revalidate();
  }

  void setDescription(String value) {
    state = state.copyWith(description: value);
    _revalidate();
  }

  void setIsAlternate(bool value) {
    state = state.copyWith(
      isAlternate: value,
      alternateOfJobId: value ? state.alternateOfJobId : null,
      alternateOfJobIdError: value ? state.alternateOfJobIdError : null,
    );
    _revalidate();
  }

  void setAlternateOfJobId(String? value) {
    state = state.copyWith(alternateOfJobId: value);
    _revalidate();
  }

  Future<bool> submit() async {
    final errors = _fieldErrors();
    if (errors.hasAny) {
      state = state.copyWith(
        submitted: true,
        isSubmitting: false,
        titleError: errors.title,
        jobTypeError: errors.jobType,
        descriptionError: errors.description,
        alternateOfJobIdError: errors.alternateOfJobId,
      );
      return false;
    }

    state = state.copyWith(
      submitted: true,
      isSubmitting: true,
      errorMessage: null,
    );
    try {
      final alternateOfJobId = state.isAlternate
          ? state.alternateOfJobId
          : null;
      if (state.isAdd) {
        await ref
            .read(jobsRepositoryProvider)
            .create(
              CreateJobCommand(
                projectId: projectId,
                title: state.title,
                jobType: state.jobType!,
                description: state.description,
                alternateOfJobId: alternateOfJobId,
              ),
            );
      } else {
        await ref
            .read(jobsRepositoryProvider)
            .update(
              UpdateJobCommand(
                id: state.jobId!,
                title: state.title,
                jobType: state.jobType!,
                description: state.description,
                alternateOfJobId: alternateOfJobId,
              ),
            );
      }
      ref.invalidate(projectJobsProvider(projectId));
      return true;
    } on AppException catch (error) {
      state = state.copyWith(isSubmitting: false, errorMessage: error.message);
      return false;
    } catch (_) {
      state = state.copyWith(
        isSubmitting: false,
        errorMessage: 'Something went wrong.',
      );
      return false;
    }
  }

  void _revalidate() {
    if (!state.submitted) return;
    final errors = _fieldErrors();
    state = state.copyWith(
      titleError: errors.title,
      jobTypeError: errors.jobType,
      descriptionError: errors.description,
      alternateOfJobIdError: errors.alternateOfJobId,
    );
  }

  _FieldErrors _fieldErrors() {
    return _FieldErrors(
      title: EstimateValidators.jobTitle(state.title),
      jobType: EstimateValidators.jobType(state.jobType),
      description: EstimateValidators.jobDescription(state.description),
      alternateOfJobId: EstimateValidators.alternateOfJobId(
        isAlternate: state.isAlternate,
        alternateOfJobId: state.alternateOfJobId,
      ),
    );
  }
}

class _FieldErrors {
  const _FieldErrors({
    this.title,
    this.jobType,
    this.description,
    this.alternateOfJobId,
  });

  final String? title;
  final String? jobType;
  final String? description;
  final String? alternateOfJobId;

  bool get hasAny =>
      title != null ||
      jobType != null ||
      description != null ||
      alternateOfJobId != null;
}
