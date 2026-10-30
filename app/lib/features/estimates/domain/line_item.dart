import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:app/core/database/line_items_table.dart';
import 'package:app/core/domain/money.dart';
import 'package:app/core/domain/pricing_type.dart';
import 'package:app/core/domain/quantity.dart';
import 'package:app/features/estimates/domain/line_math.dart';

part 'line_item.freezed.dart';

@freezed
abstract class LineItem with _$LineItem {
  const LineItem._();

  const factory LineItem({
    required String id,
    required String jobId,
    required int position,
    required bool isCustom,
    String? priceItemId,
    required String name,
    String? description,
    required PricingType pricingType,
    required Quantity quantity,
    required Money savedPrice,
    Money? overridePrice,
    required Money total,
  }) = _LineItem;

  factory LineItem.fromJson(Map<String, dynamic> json) {
    final override = json[LineItemsTable.overridePriceCents];
    return LineItem(
      id: json[LineItemsTable.id] as String,
      jobId: json[LineItemsTable.jobId] as String,
      position: json[LineItemsTable.position] as int,
      isCustom: json[LineItemsTable.isCustom] as bool,
      priceItemId: json[LineItemsTable.priceItemId] as String?,
      name: json[LineItemsTable.itemName] as String,
      description: json[LineItemsTable.description] as String?,
      pricingType: PricingType.fromDb(
        json[LineItemsTable.pricingType] as String,
      ),
      quantity: Quantity.fromDb(json[LineItemsTable.quantity] as Object),
      savedPrice: Money(json[LineItemsTable.savedPriceCents] as int),
      overridePrice: override == null ? null : Money(override as int),
      total: Money(json[LineItemsTable.totalCents] as int),
    );
  }

  Money get effectivePrice => overridePrice ?? savedPrice;

  bool get hasOverride => overridePrice != null;

  bool get priceItemDeleted => !isCustom && priceItemId == null;

  String? get descriptionLine {
    final value = description?.trim();
    if (value == null || value.isEmpty) return null;
    return value.split('\n').first;
  }

  Money get computedTotal =>
      Money(lineTotal(quantity, effectivePrice.cents));

  String formatQuantityPrice([Money? price]) {
    if (pricingType == PricingType.fixed) return 'Fixed';
    final shown = price ?? effectivePrice;
    return '${quantity.format()} ${pricingType.quantityUnit} × ${shown.format()}';
  }
}
