// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'client_intake_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(clientIntakeService)
final clientIntakeServiceProvider = ClientIntakeServiceProvider._();

final class ClientIntakeServiceProvider
    extends
        $FunctionalProvider<
          ClientIntakeService,
          ClientIntakeService,
          ClientIntakeService
        >
    with $Provider<ClientIntakeService> {
  ClientIntakeServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'clientIntakeServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$clientIntakeServiceHash();

  @$internal
  @override
  $ProviderElement<ClientIntakeService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ClientIntakeService create(Ref ref) {
    return clientIntakeService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ClientIntakeService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ClientIntakeService>(value),
    );
  }
}

String _$clientIntakeServiceHash() =>
    r'b021e000cd03745be9ca38d7b76ed81f92b817b9';
