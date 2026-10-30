import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:app/core/domain/phone.dart';
import 'package:app/features/clients/data/clients_repository.dart';
import 'package:app/features/clients/domain/client.dart';
import 'package:app/features/clients/presentation/widgets/client_form_sheet.dart';

part 'client_picker.g.dart';

@riverpod
Future<List<Client>> clientPickerResults(Ref ref, String query) {
  return ref.watch(clientsRepositoryProvider).search(query);
}

class ClientPicker extends ConsumerStatefulWidget {
  const ClientPicker({
    required this.client,
    required this.onPicked,
    required this.onCleared,
    this.enabled = true,
    this.errorText,
    super.key,
  });

  final Client? client;
  final ValueChanged<Client> onPicked;
  final VoidCallback onCleared;
  final bool enabled;
  final String? errorText;

  @override
  ConsumerState<ClientPicker> createState() => _ClientPickerState();
}

class _ClientPickerState extends ConsumerState<ClientPicker> {
  final _search = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  Future<void> _addNewClient() async {
    final created = await showClientForm(context);
    if (created != null) widget.onPicked(created);
  }

  @override
  Widget build(BuildContext context) {
    final selected = widget.client;
    if (selected != null) {
      return _SelectedClient(
        client: selected,
        enabled: widget.enabled,
        onChange: widget.enabled
            ? () {
                _search.clear();
                setState(() => _query = '');
                widget.onCleared();
              }
            : null,
      );
    }

    final results = ref.watch(clientPickerResultsProvider(_query));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: _search,
          enabled: widget.enabled,
          textInputAction: TextInputAction.search,
          decoration: InputDecoration(
            labelText: 'Client',
            hintText: 'Search by name or phone',
            errorText: widget.errorText,
          ),
          onChanged: (value) => setState(() => _query = value),
        ),
        const SizedBox(height: 8),
        results.when(
          loading: () => const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Center(child: CircularProgressIndicator()),
          ),
          error: (_, _) => const Text('Could not load clients.'),
          data: (clients) => _ResultsList(
            clients: clients,
            enabled: widget.enabled,
            onAddNew: widget.enabled ? _addNewClient : null,
            onPicked: widget.onPicked,
          ),
        ),
      ],
    );
  }
}

class _SelectedClient extends StatelessWidget {
  const _SelectedClient({
    required this.client,
    required this.enabled,
    required this.onChange,
  });

  final Client client;
  final bool enabled;
  final VoidCallback? onChange;

  @override
  Widget build(BuildContext context) {
    final phone = client.phone;
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(client.fullName, style: Theme.of(context).textTheme.titleSmall),
              if (phone != null)
                Text(
                  Phone.format(phone),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
            ],
          ),
        ),
        TextButton(
          onPressed: enabled ? onChange : null,
          child: const Text('Change'),
        ),
      ],
    );
  }
}

class _ResultsList extends StatelessWidget {
  const _ResultsList({
    required this.clients,
    required this.enabled,
    required this.onAddNew,
    required this.onPicked,
  });

  final List<Client> clients;
  final bool enabled;
  final VoidCallback? onAddNew;
  final ValueChanged<Client> onPicked;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ListTile(
          leading: const Icon(Icons.add),
          title: const Text('+ New client'),
          enabled: enabled,
          onTap: onAddNew,
        ),
        for (final client in clients)
          ListTile(
            title: Text(client.fullName),
            subtitle: client.phone == null ? null : Text(Phone.format(client.phone!)),
            enabled: enabled,
            onTap: () => onPicked(client),
          ),
      ],
    );
  }
}
