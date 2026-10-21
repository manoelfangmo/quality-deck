import 'package:flutter_test/flutter_test.dart';

import 'package:app/core/database/rpc.dart';
import 'package:app/features/projects/data/models.dart';

void main() {
  test('toJson uses RPC argument names, trims, and upper-cases state', () {
    const command = CreateProjectCommand(
      clientId: 'client-1',
      title: '  Melgar – 12 Oak St  ',
      siteStreet: '  12 Oak St  ',
      siteCity: '  Bowie  ',
      siteState: 'md',
      siteZip: '  20715  ',
    );

    expect(command.toJson(), {
      Rpc.pClientId: 'client-1',
      Rpc.pTitle: 'Melgar – 12 Oak St',
      Rpc.pSiteStreet: '12 Oak St',
      Rpc.pSiteCity: 'Bowie',
      Rpc.pSiteState: 'MD',
      Rpc.pSiteZip: '20715',
    });
    expect(command.toJson().containsKey('business_id'), isFalse);
  });
}
