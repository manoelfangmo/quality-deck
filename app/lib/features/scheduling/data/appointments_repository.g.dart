// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'appointments_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(appointmentsRepository)
final appointmentsRepositoryProvider = AppointmentsRepositoryProvider._();

final class AppointmentsRepositoryProvider
    extends
        $FunctionalProvider<
          AppointmentsRepository,
          AppointmentsRepository,
          AppointmentsRepository
        >
    with $Provider<AppointmentsRepository> {
  AppointmentsRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appointmentsRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appointmentsRepositoryHash();

  @$internal
  @override
  $ProviderElement<AppointmentsRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AppointmentsRepository create(Ref ref) {
    return appointmentsRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AppointmentsRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AppointmentsRepository>(value),
    );
  }
}

String _$appointmentsRepositoryHash() =>
    r'cc015a7cbc67761bdc4408e073e1d3f7edabaab9';
