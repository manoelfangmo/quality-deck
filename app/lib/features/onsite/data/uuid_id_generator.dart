import 'package:uuid/uuid.dart';

import 'package:app/features/onsite/application/id_generator.dart';

class UuidIdGenerator implements IdGenerator {
  const UuidIdGenerator();

  static const _uuid = Uuid();

  @override
  String next() => _uuid.v4();
}
