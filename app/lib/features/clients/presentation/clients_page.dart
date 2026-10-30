import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:app/core/constants/breakpoints.dart';
import 'package:app/core/utils/toasts.dart';
import 'package:app/core/widgets/contact_link.dart';
import 'package:app/core/widgets/error_retry.dart';
import 'package:app/core/widgets/paginated_table_component.dart';
import 'package:app/core/widgets/table_dropdown_button.dart';
import 'package:app/features/clients/domain/client.dart';
import 'package:app/features/clients/presentation/controllers/client_actions.dart';
import 'package:app/features/clients/presentation/controllers/clients_table.dart';
import 'package:app/core/utils/providers.dart';
import 'package:app/features/business/presentation/controllers/current_business.dart';
import 'package:app/features/clients/presentation/widgets/client_form_sheet.dart';
import 'package:app/features/clients/presentation/widgets/remove_client_dialog.dart';
import 'package:app/features/scheduling/presentation/widgets/appointment_table_cell.dart';

class ClientsPage extends ConsumerWidget {
  const ClientsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final clients = ref.watch(allClientsProvider);
    final compact = MediaQuery.sizeOf(context).width < Breakpoints.phone;
    final now = ref.watch(clockProvider).now();
    final timeZone =
        ref.watch(currentBusinessProvider).value?.timezone ??
        'America/New_York';

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Clients',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ),
                _AddClientButton(
                  compact: compact,
                  onPressed: () => _openForm(context, ref),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: clients.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stackTrace) => ErrorRetry(
                  onRetry: () => ref.invalidate(allClientsProvider),
                ),
                data: (list) {
                  if (list.isEmpty) {
                    return _EmptyClients(
                      compact: compact,
                      onAdd: () => _openForm(context, ref),
                    );
                  }
                  return PaginatedTableComponent<Client>(
                    showSearchField: false,
                    columns: _columns(
                      context,
                      ref,
                      compact: compact,
                      now: now,
                      timeZone: timeZone,
                    ),
                    data: list,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<TableColumn<Client>> _columns(
    BuildContext context,
    WidgetRef ref, {
    required bool compact,
    required DateTime now,
    required String timeZone,
  }) {
    return [
      TableColumn(
        columnName: 'Name',
        onBuild: (client) => Text(client.fullName),
      ),
      TableColumn(
        columnName: 'Appointment',
        onBuild: (client) => AppointmentTableCell(
          startsAt: client.appointmentStartsAt,
          now: now,
          timeZone: timeZone,
        ),
      ),
      if (!compact)
        TableColumn(
          columnName: 'Phone',
          onBuild: (client) {
            final phone = client.phone;
            if (phone == null) return const SizedBox.shrink();
            return ContactLink.phone(phone);
          },
        ),
      if (!compact)
        TableColumn(
          columnName: 'Email',
          onBuild: (client) {
            final email = client.email;
            if (email == null) return const SizedBox.shrink();
            return ContactLink.email(email);
          },
        ),
      if (!compact)
        TableColumn(
          columnName: 'Address',
          onBuild: (client) => Text(client.address?.cityState ?? ''),
        ),
      TableColumn(
        columnName: '',
        onBuild: (client) => TableDropdownButton(
          actions: [
            DropDownAction(
              actionName: 'Edit',
              onClick: () => _openForm(context, ref, client: client),
            ),
            DropDownAction(
              actionName: 'Remove',
              isDestructive: true,
              onClick: () => _remove(context, ref, client),
            ),
          ],
        ),
      ),
    ];
  }

  Future<void> _openForm(
    BuildContext context,
    WidgetRef ref, {
    Client? client,
  }) async {
    await showClientForm(context, client: client);
  }

  Future<void> _remove(
    BuildContext context,
    WidgetRef ref,
    Client client,
  ) async {
    final confirmed = await showRemoveClientDialog(
      context: context,
      name: client.fullName,
      hasAppointment: client.hasAppointment,
    );
    if (!confirmed) return;
    final removed = await ref
        .read(clientActionsControllerProvider(client.id).notifier)
        .remove();
    if (removed && context.mounted) {
      AppSnackbars.show(context, 'Client removed');
    }
  }
}

class _AddClientButton extends StatelessWidget {
  const _AddClientButton({required this.compact, required this.onPressed});

  final bool compact;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    if (compact) {
      return IconButton.filled(
        tooltip: 'Add client',
        onPressed: onPressed,
        icon: const Icon(Icons.add),
      );
    }
    return FilledButton.icon(
      onPressed: onPressed,
      style: FilledButton.styleFrom(minimumSize: const Size(44, 48)),
      icon: const Icon(Icons.add),
      label: const Text('Add client'),
    );
  }
}

class _EmptyClients extends StatelessWidget {
  const _EmptyClients({required this.compact, required this.onAdd});

  final bool compact;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'No clients yet',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 16),
          _AddClientButton(compact: compact, onPressed: onAdd),
        ],
      ),
    );
  }
}
