// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'price_item_actions.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(PriceItemActionsController)
final priceItemActionsControllerProvider = PriceItemActionsControllerFamily._();

final class PriceItemActionsControllerProvider
    extends
        $NotifierProvider<PriceItemActionsController, PriceItemActionState> {
  PriceItemActionsControllerProvider._({
    required PriceItemActionsControllerFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'priceItemActionsControllerProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$priceItemActionsControllerHash();

  @override
  String toString() {
    return r'priceItemActionsControllerProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  PriceItemActionsController create() => PriceItemActionsController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PriceItemActionState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PriceItemActionState>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is PriceItemActionsControllerProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$priceItemActionsControllerHash() =>
    r'1408ed0132c4f670c0e5b7408b19c1fd46aad8ab';

final class PriceItemActionsControllerFamily extends $Family
    with
        $ClassFamilyOverride<
          PriceItemActionsController,
          PriceItemActionState,
          PriceItemActionState,
          PriceItemActionState,
          String
        > {
  PriceItemActionsControllerFamily._()
    : super(
        retry: null,
        name: r'priceItemActionsControllerProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  PriceItemActionsControllerProvider call(String itemId) =>
      PriceItemActionsControllerProvider._(argument: itemId, from: this);

  @override
  String toString() => r'priceItemActionsControllerProvider';
}

abstract class _$PriceItemActionsController
    extends $Notifier<PriceItemActionState> {
  late final _$args = ref.$arg as String;
  String get itemId => _$args;

  PriceItemActionState build(String itemId);
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<PriceItemActionState, PriceItemActionState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<PriceItemActionState, PriceItemActionState>,
              PriceItemActionState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, () => build(_$args));
  }
}
