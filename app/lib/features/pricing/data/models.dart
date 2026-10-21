import 'package:app/core/database/price_items_table.dart';
import 'package:app/core/domain/pricing_type.dart';
import 'package:app/features/pricing/domain/price_item.dart';

class PriceItemPage {
  const PriceItemPage({required this.items, required this.total});

  final List<PriceItem> items;
  final int total;
}

class CreatePriceItemCommand {
  const CreatePriceItemCommand({
    required this.name,
    this.description,
    required this.pricingType,
    required this.priceCents,
  });

  final String name;
  final String? description;
  final PricingType pricingType;
  final int priceCents;

  Map<String, dynamic> toJson() => _payload(
    name: name,
    description: description,
    pricingType: pricingType,
    priceCents: priceCents,
  );
}

class UpdatePriceItemCommand {
  const UpdatePriceItemCommand({
    required this.id,
    required this.name,
    this.description,
    required this.pricingType,
    required this.priceCents,
  });

  final String id;
  final String name;
  final String? description;
  final PricingType pricingType;
  final int priceCents;

  Map<String, dynamic> toJson() => _payload(
    name: name,
    description: description,
    pricingType: pricingType,
    priceCents: priceCents,
  );
}

Map<String, dynamic> _payload({
  required String name,
  String? description,
  required PricingType pricingType,
  required int priceCents,
}) {
  return {
    PriceItemsTable.itemName: name.trim(),
    PriceItemsTable.description: _blankToNull(description),
    PriceItemsTable.pricingType: pricingType.toDb(),
    PriceItemsTable.priceCents: priceCents,
  };
}

String? _blankToNull(String? value) {
  final trimmed = value?.trim();
  if (trimmed == null || trimmed.isEmpty) return null;
  return trimmed;
}
