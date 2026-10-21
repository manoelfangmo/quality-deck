import 'package:supabase_flutter/supabase_flutter.dart';

class AppException implements Exception {
  const AppException(this.message, {this.token});

  final String message;
  final String? token;

  static const _copy = <String, String>{
    'invite_not_found':
        "That code doesn't match any invite. Check it and try again.",
    'invite_expired': 'That invite has expired. Ask for a new code.',
    'invite_used': 'That invite has already been used. Ask for a new code.',
    'invite_revoked': 'That invite was cancelled. Ask for a new code.',
    'already_in_business': "You're already part of a business.",
    'invalid_business_name': 'Enter a business name (up to 80 characters).',
    'not_owner': 'Only the business owner can do that.',
    'cannot_remove_owner': "The owner can't be removed.",
    'member_not_found': 'That person is no longer a member.',
    'invite_not_active':
        "That invite can't be revoked because it's no longer active.",
    'client_not_found':
        'This client was removed. Refresh to see the latest list.',
    'invalid_duration': 'Pick a duration between 15 minutes and 10 hours.',
    'appointment_not_found':
        'This appointment was removed. Refresh and try again.',
    'client_has_appointment':
        'This client already has an appointment. Edit or remove it first.',
    'price_item_not_found':
        'That price list item was deleted. Pick another.',
    'project_not_found':
        "This project couldn't be found. Refresh and try again.",
    'project_already_archived': 'This project is already archived.',
    'project_not_archived': "This project isn't archived.",
    'project_archived':
        'This project is archived. Unarchive it to make changes.',
    'job_not_found': 'This job was deleted. Refresh to see the latest.',
    'line_item_not_found':
        'This line was removed. Refresh to see the latest.',
    'invalid_quantity': 'Enter a quantity greater than 0.',
    'field_locked':
        "That field comes from the price list and can't be changed here.",
    'reorder_mismatch': 'The list changed. Refresh and try again.',
    'invalid_overhead': 'Enter a percentage from 0 to 100.',
  };

  const AppException.clientNotFound()
    : message = 'This client was removed. Refresh to see the latest list.',
      token = 'client_not_found';

  const AppException.invalidDuration()
    : message = 'Pick a duration between 15 minutes and 10 hours.',
      token = 'invalid_duration';

  const AppException.appointmentNotFound()
    : message = 'This appointment was removed. Refresh and try again.',
      token = 'appointment_not_found';

  const AppException.clientHasAppointment()
    : message =
          'This client already has an appointment. Edit or remove it first.',
      token = 'client_has_appointment';

  const AppException.priceItemNotFound()
    : message = 'This item was deleted. Refresh to see the latest list.',
      token = 'price_item_not_found';

  const AppException.projectNotFound()
    : message = "This project couldn't be found. Refresh and try again.",
      token = 'project_not_found';

  const AppException.projectAlreadyArchived()
    : message = 'This project is already archived.',
      token = 'project_already_archived';

  const AppException.projectNotArchived()
    : message = "This project isn't archived.",
      token = 'project_not_archived';

  const AppException.projectArchived()
    : message = 'This project is archived. Unarchive it to make changes.',
      token = 'project_archived';

  const AppException.jobNotFound()
    : message = 'This job was deleted. Refresh to see the latest.',
      token = 'job_not_found';

  const AppException.lineItemNotFound()
    : message = 'This line was removed. Refresh to see the latest.',
      token = 'line_item_not_found';

  factory AppException.fromToken(String token) {
    return AppException(_copy[token] ?? 'Something went wrong.', token: token);
  }

  static Never throwFrom(Object error, StackTrace stackTrace) {
    if (error is AppException) {
      Error.throwWithStackTrace(error, stackTrace);
    }
    if (error is PostgrestException && _isQ0(error)) {
      throw AppException.fromToken(error.message);
    }
    Error.throwWithStackTrace(error, stackTrace);
  }

  static bool _isQ0(PostgrestException error) {
    final code = error.code;
    return code != null && code.startsWith('Q0');
  }

  @override
  String toString() => message;
}
