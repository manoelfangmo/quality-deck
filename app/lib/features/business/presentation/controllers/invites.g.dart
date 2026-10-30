// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'invites.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(invites)
final invitesProvider = InvitesProvider._();

final class InvitesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Invite>>,
          List<Invite>,
          FutureOr<List<Invite>>
        >
    with $FutureModifier<List<Invite>>, $FutureProvider<List<Invite>> {
  InvitesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'invitesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$invitesHash();

  @$internal
  @override
  $FutureProviderElement<List<Invite>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Invite>> create(Ref ref) {
    return invites(ref);
  }
}

String _$invitesHash() => r'ff900acfb5876c348c06da7ba07ebac1619926b2';

@ProviderFor(InvitesController)
final invitesControllerProvider = InvitesControllerProvider._();

final class InvitesControllerProvider
    extends $NotifierProvider<InvitesController, void> {
  InvitesControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'invitesControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$invitesControllerHash();

  @$internal
  @override
  InvitesController create() => InvitesController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$invitesControllerHash() => r'5a9c6059b6a3e1f314047a8a08d9f9b2e633722d';

abstract class _$InvitesController extends $Notifier<void> {
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
