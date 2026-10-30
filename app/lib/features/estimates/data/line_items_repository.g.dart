// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'line_items_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(lineItemsRepository)
final lineItemsRepositoryProvider = LineItemsRepositoryProvider._();

final class LineItemsRepositoryProvider
    extends
        $FunctionalProvider<
          LineItemsRepository,
          LineItemsRepository,
          LineItemsRepository
        >
    with $Provider<LineItemsRepository> {
  LineItemsRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'lineItemsRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$lineItemsRepositoryHash();

  @$internal
  @override
  $ProviderElement<LineItemsRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  LineItemsRepository create(Ref ref) {
    return lineItemsRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LineItemsRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LineItemsRepository>(value),
    );
  }
}

String _$lineItemsRepositoryHash() =>
    r'137b8bd70b0b57ecfa61e5bbc8bf945fb0e65f89';
