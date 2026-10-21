// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'price_items_table.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(PriceItemsTableController)
final priceItemsTableControllerProvider = PriceItemsTableControllerProvider._();

final class PriceItemsTableControllerProvider
    extends $NotifierProvider<PriceItemsTableController, PriceItemsTableState> {
  PriceItemsTableControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'priceItemsTableControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$priceItemsTableControllerHash();

  @$internal
  @override
  PriceItemsTableController create() => PriceItemsTableController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PriceItemsTableState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PriceItemsTableState>(value),
    );
  }
}

String _$priceItemsTableControllerHash() =>
    r'd910ae8c7a087f9a97112619913602e83820769b';

abstract class _$PriceItemsTableController
    extends $Notifier<PriceItemsTableState> {
  PriceItemsTableState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<PriceItemsTableState, PriceItemsTableState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<PriceItemsTableState, PriceItemsTableState>,
              PriceItemsTableState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(allPriceItems)
final allPriceItemsProvider = AllPriceItemsProvider._();

final class AllPriceItemsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<PriceItem>>,
          List<PriceItem>,
          FutureOr<List<PriceItem>>
        >
    with $FutureModifier<List<PriceItem>>, $FutureProvider<List<PriceItem>> {
  AllPriceItemsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'allPriceItemsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$allPriceItemsHash();

  @$internal
  @override
  $FutureProviderElement<List<PriceItem>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<PriceItem>> create(Ref ref) {
    return allPriceItems(ref);
  }
}

String _$allPriceItemsHash() => r'793fe89f79abb25e63b8db89375e1a353f492ba2';

@ProviderFor(priceItemsPage)
final priceItemsPageProvider = PriceItemsPageFamily._();

final class PriceItemsPageProvider
    extends
        $FunctionalProvider<
          AsyncValue<PriceItemPage>,
          PriceItemPage,
          FutureOr<PriceItemPage>
        >
    with $FutureModifier<PriceItemPage>, $FutureProvider<PriceItemPage> {
  PriceItemsPageProvider._({
    required PriceItemsPageFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'priceItemsPageProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$priceItemsPageHash();

  @override
  String toString() {
    return r'priceItemsPageProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<PriceItemPage> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<PriceItemPage> create(Ref ref) {
    final argument = this.argument as int;
    return priceItemsPage(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is PriceItemsPageProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$priceItemsPageHash() => r'88ee9ceabed769f999434471c297f28b021b8971';

final class PriceItemsPageFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<PriceItemPage>, int> {
  PriceItemsPageFamily._()
    : super(
        retry: null,
        name: r'priceItemsPageProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  PriceItemsPageProvider call(int page) =>
      PriceItemsPageProvider._(argument: page, from: this);

  @override
  String toString() => r'priceItemsPageProvider';
}
