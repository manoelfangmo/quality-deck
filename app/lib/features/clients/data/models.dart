import 'package:app/core/database/clients_table.dart';
import 'package:app/core/domain/phone.dart';
import 'package:app/features/clients/domain/client.dart';

class ClientPage {
  const ClientPage({required this.clients, required this.total});

  final List<Client> clients;
  final int total;
}

class CreateClientCommand {
  const CreateClientCommand({
    required this.fullName,
    this.email,
    this.phone,
    this.street,
    this.city,
    this.state,
    this.zip,
  });

  final String fullName;
  final String? email;
  final String? phone;
  final String? street;
  final String? city;
  final String? state;
  final String? zip;

  Map<String, dynamic> toJson() => _clientPayload(
    fullName: fullName,
    email: email,
    phone: phone,
    street: street,
    city: city,
    state: state,
    zip: zip,
  );
}

class UpdateClientCommand {
  const UpdateClientCommand({
    required this.id,
    required this.fullName,
    this.email,
    this.phone,
    this.street,
    this.city,
    this.state,
    this.zip,
  });

  final String id;
  final String fullName;
  final String? email;
  final String? phone;
  final String? street;
  final String? city;
  final String? state;
  final String? zip;

  Map<String, dynamic> toJson() => _clientPayload(
    fullName: fullName,
    email: email,
    phone: phone,
    street: street,
    city: city,
    state: state,
    zip: zip,
  );
}

Map<String, dynamic> _clientPayload({
  required String fullName,
  String? email,
  String? phone,
  String? street,
  String? city,
  String? state,
  String? zip,
}) {
  return {
    ClientsTable.fullName: fullName.trim(),
    ClientsTable.email: _blankToNull(email)?.toLowerCase(),
    ClientsTable.phone: Phone.normalize(_blankToNull(phone)),
    ClientsTable.street: _blankToNull(street),
    ClientsTable.city: _blankToNull(city),
    ClientsTable.state: _blankToNull(state)?.toUpperCase(),
    ClientsTable.zip: _blankToNull(zip),
  };
}

String? _blankToNull(String? value) {
  final trimmed = value?.trim();
  if (trimmed == null || trimmed.isEmpty) return null;
  return trimmed;
}
