import 'package:flutter_test/flutter_test.dart';

import 'package:app/core/database/clients_table.dart';
import 'package:app/features/clients/data/models.dart';

void main() {
  test('CreateClientCommand trims, lower-cases, E.164, upper-cases, empties to null', () {
    final json = const CreateClientCommand(
      fullName: '  Ana Melgar  ',
      email: '  Ana.Melgar@Example.TEST  ',
      phone: '(301) 555-0123',
      street: '  12 Oak St  ',
      city: ' Bowie ',
      state: 'md',
      zip: ' 20715 ',
    ).toJson();

    expect(json[ClientsTable.fullName], 'Ana Melgar');
    expect(json[ClientsTable.email], 'ana.melgar@example.test');
    expect(json[ClientsTable.phone], '+13015550123');
    expect(json[ClientsTable.street], '12 Oak St');
    expect(json[ClientsTable.city], 'Bowie');
    expect(json[ClientsTable.state], 'MD');
    expect(json[ClientsTable.zip], '20715');
    expect(json.containsKey(ClientsTable.businessId), isFalse);
    expect(json.containsKey(ClientsTable.deletedAt), isFalse);
    expect(json.containsKey(ClientsTable.deletedBy), isFalse);
    expect(json.containsKey(ClientsTable.createdBy), isFalse);
  });

  test('empty optional fields become null', () {
    final json = const CreateClientCommand(
      fullName: 'James Whitaker',
      email: '  ',
      phone: '(301) 555-0102',
      street: '',
      city: '',
      state: '',
      zip: '',
    ).toJson();

    expect(json[ClientsTable.email], isNull);
    expect(json[ClientsTable.street], isNull);
    expect(json[ClientsTable.city], isNull);
    expect(json[ClientsTable.state], isNull);
    expect(json[ClientsTable.zip], isNull);
  });

  test('UpdateClientCommand payload has no id, business_id, or delete columns', () {
    final json = const UpdateClientCommand(
      id: 'client-ana',
      fullName: 'Ana Melgar',
      phone: '3015550123',
    ).toJson();

    expect(json.containsKey(ClientsTable.id), isFalse);
    expect(json.containsKey(ClientsTable.businessId), isFalse);
    expect(json.containsKey(ClientsTable.deletedAt), isFalse);
    expect(json.containsKey(ClientsTable.deletedBy), isFalse);
  });
}
