// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'price_item_form.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(PriceItemFormController)
final priceItemFormControllerProvider = PriceItemFormControllerFamily._();

final class PriceItemFormControllerProvider
    extends $NotifierProvider<PriceItemFormController, PriceItemFormState> {
  PriceItemFormControllerProvider._({
    required PriceItemFormControllerFamily super.from,
    required PriceItem? super.argument,
  }) : super(
         retry: null,
         name: r'priceItemFormControllerProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$priceItemFormControllerHash();

  @override
  String toString() {
    return r'priceItemFormControllerProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  PriceItemFormController create() => PriceItemFormController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PriceItemFormState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PriceItemFormState>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is PriceItemFormControllerProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$priceItemFormControllerHash() =>
    r'f438837ae5595732aee852ab91bc8c89e8cf51b3';

final class PriceItemFormControllerFamily extends $Family
    with
        $ClassFamilyOverride<
          PriceItemFormController,
          PriceItemFormState,
          PriceItemFormState,
          PriceItemFormState,
          PriceItem?
        > {
  PriceItemFormControllerFamily._()
    : super(
        retry: null,
        name: r'priceItemFormControllerProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  PriceItemFormControllerProvider call({PriceItem? item}) =>
      PriceItemFormControllerProvider._(argument: item, from: this);

  @override
  String toString() => r'priceItemFormControllerProvider';
}

abstract class _$PriceItemFormController extends $Notifier<PriceItemFormState> {
  late final _$args = ref.$arg as PriceItem?;
  PriceItem? get item => _$args;

  PriceItemFormState build({PriceItem? item});
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<PriceItemFormState, PriceItemFormState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<PriceItemFormState, PriceItemFormState>,
              PriceItemFormState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, () => build(item: _$args));
  }
}
