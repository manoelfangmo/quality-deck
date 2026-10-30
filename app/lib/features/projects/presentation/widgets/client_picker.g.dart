// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'client_picker.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(clientPickerResults)
final clientPickerResultsProvider = ClientPickerResultsFamily._();

final class ClientPickerResultsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Client>>,
          List<Client>,
          FutureOr<List<Client>>
        >
    with $FutureModifier<List<Client>>, $FutureProvider<List<Client>> {
  ClientPickerResultsProvider._({
    required ClientPickerResultsFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'clientPickerResultsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$clientPickerResultsHash();

  @override
  String toString() {
    return r'clientPickerResultsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<Client>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Client>> create(Ref ref) {
    final argument = this.argument as String;
    return clientPickerResults(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is ClientPickerResultsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$clientPickerResultsHash() =>
    r'4423264c9985badaa90d65a53c55c76c9ee2dc91';

final class ClientPickerResultsFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<Client>>, String> {
  ClientPickerResultsFamily._()
    : super(
        retry: null,
        name: r'clientPickerResultsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  ClientPickerResultsProvider call(String query) =>
      ClientPickerResultsProvider._(argument: query, from: this);

  @override
  String toString() => r'clientPickerResultsProvider';
}
