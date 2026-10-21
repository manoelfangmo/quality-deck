// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'price_items_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(priceItemsRepository)
final priceItemsRepositoryProvider = PriceItemsRepositoryProvider._();

final class PriceItemsRepositoryProvider
    extends
        $FunctionalProvider<
          PriceItemsRepository,
          PriceItemsRepository,
          PriceItemsRepository
        >
    with $Provider<PriceItemsRepository> {
  PriceItemsRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'priceItemsRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$priceItemsRepositoryHash();

  @$internal
  @override
  $ProviderElement<PriceItemsRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  PriceItemsRepository create(Ref ref) {
    return priceItemsRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PriceItemsRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PriceItemsRepository>(value),
    );
  }
}

String _$priceItemsRepositoryHash() =>
    r'1a1d9f683e92c5d25043fae93b7b8532423af178';
