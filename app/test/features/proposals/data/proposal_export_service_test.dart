import 'package:flutter_test/flutter_test.dart';

import 'package:app/features/proposals/data/supabase_proposal_export_service.dart';
import 'package:app/features/proposals/domain/proposal_export_failure.dart';

void main() {
  test('maps 422 to missing data with the full list', () {
    final failure = mapFunctionError(
      status: 422,
      details: {
        'error': 'missing_data',
        'missing': ['client.name', 'jobs[2].lineItems'],
      },
    );
    expect(failure, isA<MissingDataFailure>());
    expect((failure as MissingDataFailure).missing, [
      'client.name',
      'jobs[2].lineItems',
    ]);
  });

  test('maps 502 to the PDF service failure', () {
    expect(
      mapFunctionError(status: 502, details: {'error': 'pdf_service_failed'}),
      isA<PdfServiceFailure>(),
    );
  });

  test('maps 404 without revealing whether the project exists', () {
    expect(
      mapFunctionError(status: 404, details: {'error': 'not_found'}),
      isA<ExportNotFoundFailure>(),
    );
  });

  test('maps 401 and 400', () {
    expect(
      mapFunctionError(status: 401, details: {'error': 'unauthorized'}),
      isA<ExportUnauthorizedFailure>(),
    );
    expect(
      mapFunctionError(status: 400, details: {'error': 'invalid_request'}),
      isA<InvalidExportRequestFailure>(),
    );
  });

  test('missing-item copy is in plain words', () {
    expect(missingItemLabel('client.name'), 'Client name is missing');
    expect(missingItemLabel('jobs[2].lineItems'), 'Job 2 has no line items');
    expect(missingItemLabel('jobs'), 'Add at least one job');
  });
}
