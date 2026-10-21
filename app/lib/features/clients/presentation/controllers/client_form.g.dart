// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'client_form.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ClientFormController)
final clientFormControllerProvider = ClientFormControllerFamily._();

final class ClientFormControllerProvider
    extends $NotifierProvider<ClientFormController, ClientFormState> {
  ClientFormControllerProvider._({
    required ClientFormControllerFamily super.from,
    required Client? super.argument,
  }) : super(
         retry: null,
         name: r'clientFormControllerProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$clientFormControllerHash();

  @override
  String toString() {
    return r'clientFormControllerProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  ClientFormController create() => ClientFormController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ClientFormState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ClientFormState>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is ClientFormControllerProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$clientFormControllerHash() =>
    r'd24944525aa35341662f2fb2d73c26829800e5e9';

final class ClientFormControllerFamily extends $Family
    with
        $ClassFamilyOverride<
          ClientFormController,
          ClientFormState,
          ClientFormState,
          ClientFormState,
          Client?
        > {
  ClientFormControllerFamily._()
    : super(
        retry: null,
        name: r'clientFormControllerProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  ClientFormControllerProvider call({Client? client}) =>
      ClientFormControllerProvider._(argument: client, from: this);

  @override
  String toString() => r'clientFormControllerProvider';
}

abstract class _$ClientFormController extends $Notifier<ClientFormState> {
  late final _$args = ref.$arg as Client?;
  Client? get client => _$args;

  ClientFormState build({Client? client});
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<ClientFormState, ClientFormState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<ClientFormState, ClientFormState>,
              ClientFormState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, () => build(client: _$args));
  }
}
