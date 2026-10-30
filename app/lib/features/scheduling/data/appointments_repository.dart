import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:app/core/database/appointments_table.dart';
import 'package:app/core/database/rpc.dart';
import 'package:app/core/domain/app_exception.dart';
import 'package:app/core/utils/providers.dart';
import 'package:app/features/scheduling/data/models.dart';
import 'package:app/features/scheduling/domain/appointment.dart';

part 'appointments_repository.g.dart';

@riverpod
AppointmentsRepository appointmentsRepository(Ref ref) {
  return AppointmentsRepository(ref.watch(supabaseProvider));
}

class AppointmentsRepository {
  AppointmentsRepository(this._supabase);

  final SupabaseClient _supabase;

  /// The client's active appointment, or null.
  Future<Appointment?> fetchForClient(String clientId) async {
    final row = await _supabase
        .from(AppointmentsTable.name)
        .select()
        .eq(AppointmentsTable.clientId, clientId)
        .isFilter(AppointmentsTable.deletedAt, null)
        .maybeSingle();
    if (row == null) return null;
    return Appointment.fromJson(row);
  }

  Future<String> add(AddAppointmentCommand command) async {
    try {
      final result = await _supabase.rpc(
        Rpc.addAppointment,
        params: command.toJson(),
      );
      return result as String;
    } catch (error, stackTrace) {
      AppException.throwFrom(error, stackTrace);
    }
  }

  Future<void> update(UpdateAppointmentCommand command) async {
    try {
      await _supabase.rpc(Rpc.updateAppointment, params: command.toJson());
    } catch (error, stackTrace) {
      AppException.throwFrom(error, stackTrace);
    }
  }

  Future<void> remove(String appointmentId) async {
    try {
      await _supabase.rpc(
        Rpc.removeAppointment,
        params: {Rpc.pId: appointmentId},
      );
    } catch (error, stackTrace) {
      AppException.throwFrom(error, stackTrace);
    }
  }
}
