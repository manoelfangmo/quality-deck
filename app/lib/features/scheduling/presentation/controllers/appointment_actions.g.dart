// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'appointment_actions.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(AppointmentActionsController)
final appointmentActionsControllerProvider =
    AppointmentActionsControllerProvider._();

final class AppointmentActionsControllerProvider
    extends $NotifierProvider<AppointmentActionsController, void> {
  AppointmentActionsControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appointmentActionsControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appointmentActionsControllerHash();

  @$internal
  @override
  AppointmentActionsController create() => AppointmentActionsController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$appointmentActionsControllerHash() =>
    r'a5151dff0cf7c750a3317f9d966199a828021390';

abstract class _$AppointmentActionsController extends $Notifier<void> {
  void build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<void, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<void, void>,
              void,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
