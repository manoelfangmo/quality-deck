import 'package:app/core/domain/money.dart';
import 'package:app/core/domain/quantity.dart';
import 'package:app/features/estimates/domain/labor.dart';
import 'package:app/features/estimates/domain/line_item.dart';

/// Matches Postgres `round(quantity * price_cents)` for non-negative values.
int lineTotal(Quantity quantity, int priceCents) {
  return (quantity.hundredths * priceCents + 50) ~/ 100;
}

/// Matches Postgres `round(labor_hours * labor_rate_cents)`.
int laborTotal(Quantity hours, int rateCents) => lineTotal(hours, rateCents);

/// Matches `(subtotal * bps + 5000) ~/ 10000` — half up.
int overheadAmount(int subtotalCents, int basisPoints) {
  return (subtotalCents * basisPoints + 5000) ~/ 10000;
}

Money jobTotal({required Iterable<LineItem> lines, Labor? labor}) {
  var cents = 0;
  for (final line in lines) {
    cents += line.total.cents;
  }
  if (labor != null) cents += labor.total.cents;
  return Money(cents);
}
