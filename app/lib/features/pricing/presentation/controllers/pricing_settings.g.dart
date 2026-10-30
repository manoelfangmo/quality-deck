// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pricing_settings.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(pricingSettings)
final pricingSettingsProvider = PricingSettingsProvider._();

final class PricingSettingsProvider
    extends
        $FunctionalProvider<
          AsyncValue<PricingSettings?>,
          PricingSettings?,
          FutureOr<PricingSettings?>
        >
    with $FutureModifier<PricingSettings?>, $FutureProvider<PricingSettings?> {
  PricingSettingsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'pricingSettingsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$pricingSettingsHash();

  @$internal
  @override
  $FutureProviderElement<PricingSettings?> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<PricingSettings?> create(Ref ref) {
    return pricingSettings(ref);
  }
}

String _$pricingSettingsHash() => r'39a50e771b533b7fdf7ef2bd97772853e0ba4e8e';

@ProviderFor(PricingSettingsController)
final pricingSettingsControllerProvider = PricingSettingsControllerProvider._();

final class PricingSettingsControllerProvider
    extends
        $NotifierProvider<
          PricingSettingsController,
          PricingSettingsActionState
        > {
  PricingSettingsControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'pricingSettingsControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$pricingSettingsControllerHash();

  @$internal
  @override
  PricingSettingsController create() => PricingSettingsController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PricingSettingsActionState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PricingSettingsActionState>(value),
    );
  }
}

String _$pricingSettingsControllerHash() =>
    r'6dc3f9128c6812cb091a9a90f167e5becf5b9334';

abstract class _$PricingSettingsController
    extends $Notifier<PricingSettingsActionState> {
  PricingSettingsActionState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref
            as $Ref<PricingSettingsActionState, PricingSettingsActionState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                PricingSettingsActionState,
                PricingSettingsActionState
              >,
              PricingSettingsActionState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
