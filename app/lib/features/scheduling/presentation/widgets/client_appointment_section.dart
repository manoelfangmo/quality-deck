import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:app/core/widgets/error_retry.dart';
import 'package:app/features/scheduling/presentation/controllers/client_appointment.dart';
import 'package:app/features/scheduling/presentation/widgets/appointment_tile.dart';

class ClientAppointmentSection extends ConsumerWidget {
  const ClientAppointmentSection({
    required this.clientId,
    required this.addSection,
    super.key,
  });

  final String clientId;
  final Widget addSection;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appointment = ref.watch(clientAppointmentProvider(clientId));
    return appointment.when(
      loading: () => const Padding(
        padding: EdgeInsets.symmetric(vertical: 16),
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (error, stackTrace) => ErrorRetry(
        onRetry: () => ref.invalidate(clientAppointmentProvider(clientId)),
      ),
      data: (value) {
        if (value == null) return addSection;
        return AppointmentTile(appointment: value, clientId: clientId);
      },
    );
  }
}
