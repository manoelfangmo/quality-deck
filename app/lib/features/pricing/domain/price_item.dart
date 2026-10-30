import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:app/core/database/price_items_table.dart';
import 'package:app/core/domain/money.dart';
import 'package:app/core/domain/pricing_type.dart';
import 'package:app/core/utils/json_converters.dart';

part 'price_item.freezed.dart';

@freezed
abstract class PriceItem with _$PriceItem {
  const PriceItem._();

  const factory PriceItem({
    required String id,
    required String name,
    String? description,
    required PricingType pricingType,
    required Money price,
    required DateTime updatedAt,
  }) = _PriceItem;

  factory PriceItem.fromJson(Map<String, dynamic> json) {
    return PriceItem(
      id: json[PriceItemsTable.id] as String,
      name: json[PriceItemsTable.itemName] as String,
      description: json[PriceItemsTable.description] as String?,
      pricingType: PricingType.fromDb(
        json[PriceItemsTable.pricingType] as String,
      ),
      price: Money(json[PriceItemsTable.priceCents] as int),
      updatedAt: const UtcToLocalConverter().fromJson(
        json[PriceItemsTable.updatedAt] as String,
      ),
    );
  }

  String get priceLabel => pricingType.formatPrice(price);

  String? get descriptionLine {
    final value = description?.trim();
    if (value == null || value.isEmpty) return null;
    return value.split('\n').first;
  }
}
