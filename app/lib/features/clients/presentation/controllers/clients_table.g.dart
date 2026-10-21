// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'clients_table.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ClientsTableController)
final clientsTableControllerProvider = ClientsTableControllerProvider._();

final class ClientsTableControllerProvider
    extends $NotifierProvider<ClientsTableController, ClientsTableState> {
  ClientsTableControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'clientsTableControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$clientsTableControllerHash();

  @$internal
  @override
  ClientsTableController create() => ClientsTableController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ClientsTableState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ClientsTableState>(value),
    );
  }
}

String _$clientsTableControllerHash() =>
    r'4f618aa6df4a374d103ad8b058566bf0a607331c';

abstract class _$ClientsTableController extends $Notifier<ClientsTableState> {
  ClientsTableState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<ClientsTableState, ClientsTableState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<ClientsTableState, ClientsTableState>,
              ClientsTableState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(allClients)
final allClientsProvider = AllClientsProvider._();

final class AllClientsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Client>>,
          List<Client>,
          FutureOr<List<Client>>
        >
    with $FutureModifier<List<Client>>, $FutureProvider<List<Client>> {
  AllClientsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'allClientsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$allClientsHash();

  @$internal
  @override
  $FutureProviderElement<List<Client>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Client>> create(Ref ref) {
    return allClients(ref);
  }
}

String _$allClientsHash() => r'3aaf063dd10821340c59c8ef3cf832a1c66ca5db';
