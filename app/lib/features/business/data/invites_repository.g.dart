// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'invites_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(invitesRepository)
final invitesRepositoryProvider = InvitesRepositoryProvider._();

final class InvitesRepositoryProvider
    extends
        $FunctionalProvider<
          InvitesRepository,
          InvitesRepository,
          InvitesRepository
        >
    with $Provider<InvitesRepository> {
  InvitesRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'invitesRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$invitesRepositoryHash();

  @$internal
  @override
  $ProviderElement<InvitesRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  InvitesRepository create(Ref ref) {
    return invitesRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(InvitesRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<InvitesRepository>(value),
    );
  }
}

String _$invitesRepositoryHash() => r'77bd3e5dd82b495173c98fdf28dd9c88f85bce47';
