import 'package:freezed_annotation/freezed_annotation.dart';

part 'appointment_draft.freezed.dart';

@freezed
abstract class AppointmentDraft with _$AppointmentDraft {
  const factory AppointmentDraft({
    required DateTime date,
    required int startHour,
    required int startMinute,
    required int durationMinutes,
    @Default('') String notes,
  }) = _AppointmentDraft;
}
