import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:app/core/domain/money.dart';
import 'package:app/core/domain/quantity.dart';

part 'labor.freezed.dart';

@freezed
abstract class Labor with _$Labor {
  const Labor._();

  const factory Labor({
    required Quantity hours,
    required Money rate,
  }) = _Labor;

  Money get total =>
      Money((hours.hundredths * rate.cents + 50) ~/ 100);
}
