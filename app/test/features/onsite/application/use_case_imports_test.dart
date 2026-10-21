import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  const forbidden = [
    'package:supabase_flutter',
    'package:web',
    'dart:js_interop',
    'dart:html',
  ];

  test(
    'AddJobPhotos and DeleteJobPhoto import no platform or Supabase code',
    () {
      const files = [
        'lib/features/onsite/application/add_job_photos.dart',
        'lib/features/onsite/application/delete_job_photo.dart',
      ];
      for (final path in files) {
        final text = File(path).readAsStringSync();
        for (final needle in forbidden) {
          expect(
            text.contains(needle),
            isFalse,
            reason: '$path must not import $needle',
          );
        }
      }
    },
  );
}
