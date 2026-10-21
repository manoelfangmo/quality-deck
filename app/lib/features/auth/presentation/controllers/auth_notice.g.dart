// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_notice.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(AuthNotice)
final authNoticeProvider = AuthNoticeProvider._();

final class AuthNoticeProvider extends $NotifierProvider<AuthNotice, String?> {
  AuthNoticeProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'authNoticeProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$authNoticeHash();

  @$internal
  @override
  AuthNotice create() => AuthNotice();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String?>(value),
    );
  }
}

String _$authNoticeHash() => r'1c45534bdc03a973161ba764d4c1d20ff78f19be';

abstract class _$AuthNotice extends $Notifier<String?> {
  String? build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<String?, String?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<String?, String?>,
              String?,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
