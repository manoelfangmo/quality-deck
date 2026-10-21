// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'client_actions.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ClientActionsController)
final clientActionsControllerProvider = ClientActionsControllerFamily._();

final class ClientActionsControllerProvider
    extends $NotifierProvider<ClientActionsController, ClientActionState> {
  ClientActionsControllerProvider._({
    required ClientActionsControllerFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'clientActionsControllerProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$clientActionsControllerHash();

  @override
  String toString() {
    return r'clientActionsControllerProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  ClientActionsController create() => ClientActionsController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ClientActionState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ClientActionState>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is ClientActionsControllerProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$clientActionsControllerHash() =>
    r'3fbb4e9c7845761b04cb1dde8f7dc6e3ff7ff438';

final class ClientActionsControllerFamily extends $Family
    with
        $ClassFamilyOverride<
          ClientActionsController,
          ClientActionState,
          ClientActionState,
          ClientActionState,
          String
        > {
  ClientActionsControllerFamily._()
    : super(
        retry: null,
        name: r'clientActionsControllerProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  ClientActionsControllerProvider call(String clientId) =>
      ClientActionsControllerProvider._(argument: clientId, from: this);

  @override
  String toString() => r'clientActionsControllerProvider';
}

abstract class _$ClientActionsController extends $Notifier<ClientActionState> {
  late final _$args = ref.$arg as String;
  String get clientId => _$args;

  ClientActionState build(String clientId);
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<ClientActionState, ClientActionState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<ClientActionState, ClientActionState>,
              ClientActionState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, () => build(_$args));
  }
}
