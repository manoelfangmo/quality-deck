// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'business_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(businessRepository)
final businessRepositoryProvider = BusinessRepositoryProvider._();

final class BusinessRepositoryProvider
    extends
        $FunctionalProvider<
          BusinessRepository,
          BusinessRepository,
          BusinessRepository
        >
    with $Provider<BusinessRepository> {
  BusinessRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'businessRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$businessRepositoryHash();

  @$internal
  @override
  $ProviderElement<BusinessRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  BusinessRepository create(Ref ref) {
    return businessRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(BusinessRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<BusinessRepository>(value),
    );
  }
}

String _$businessRepositoryHash() =>
    r'ef84cff6bc0c99350312485e7876c39a08f706da';
