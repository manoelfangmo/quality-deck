import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:app/features/estimates/domain/job.dart';
import 'package:app/features/estimates/domain/job_type.dart';

part 'job_form_state.freezed.dart';

@freezed
abstract class JobFormState with _$JobFormState {
  const JobFormState._();

  const factory JobFormState({
    String? jobId,
    @Default('') String title,
    JobType? jobType,
    @Default('') String description,
    @Default(false) bool isSubmitting,
    @Default(false) bool submitted,
    String? errorMessage,
    String? titleError,
    String? jobTypeError,
    String? descriptionError,
  }) = _JobFormState;

  factory JobFormState.fromJob(Job job) {
    return JobFormState(
      jobId: job.id,
      title: job.title,
      jobType: job.jobType,
      description: job.description ?? '',
    );
  }

  bool get isAdd => jobId == null;
}
