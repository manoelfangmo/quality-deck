// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'line_removal.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(LineRemovalController)
final lineRemovalControllerProvider = LineRemovalControllerFamily._();

final class LineRemovalControllerProvider
    extends $NotifierProvider<LineRemovalController, LineRemovalState> {
  LineRemovalControllerProvider._({
    required LineRemovalControllerFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'lineRemovalControllerProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$lineRemovalControllerHash();

  @override
  String toString() {
    return r'lineRemovalControllerProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  LineRemovalController create() => LineRemovalController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LineRemovalState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LineRemovalState>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is LineRemovalControllerProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$lineRemovalControllerHash() =>
    r'f8952022a42f0fefca12e788f84dfd0fe07249a2';

final class LineRemovalControllerFamily extends $Family
    with
        $ClassFamilyOverride<
          LineRemovalController,
          LineRemovalState,
          LineRemovalState,
          LineRemovalState,
          String
        > {
  LineRemovalControllerFamily._()
    : super(
        retry: null,
        name: r'lineRemovalControllerProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  LineRemovalControllerProvider call(String projectId) =>
      LineRemovalControllerProvider._(argument: projectId, from: this);

  @override
  String toString() => r'lineRemovalControllerProvider';
}

abstract class _$LineRemovalController extends $Notifier<LineRemovalState> {
  late final _$args = ref.$arg as String;
  String get projectId => _$args;

  LineRemovalState build(String projectId);
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<LineRemovalState, LineRemovalState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<LineRemovalState, LineRemovalState>,
              LineRemovalState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, () => build(_$args));
  }
}
