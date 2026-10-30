// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'current_business.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(currentBusiness)
final currentBusinessProvider = CurrentBusinessProvider._();

final class CurrentBusinessProvider
    extends
        $FunctionalProvider<
          AsyncValue<Business?>,
          Business?,
          FutureOr<Business?>
        >
    with $FutureModifier<Business?>, $FutureProvider<Business?> {
  CurrentBusinessProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'currentBusinessProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$currentBusinessHash();

  @$internal
  @override
  $FutureProviderElement<Business?> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<Business?> create(Ref ref) {
    return currentBusiness(ref);
  }
}

String _$currentBusinessHash() => r'ea4cd1822eaf5f9c4a8c2f762089d5416f7c41f0';
