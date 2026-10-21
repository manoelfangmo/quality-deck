// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'line_reorder.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(LineReorderController)
final lineReorderControllerProvider = LineReorderControllerFamily._();

final class LineReorderControllerProvider
    extends $NotifierProvider<LineReorderController, LineReorderState> {
  LineReorderControllerProvider._({
    required LineReorderControllerFamily super.from,
    required ({String projectId, String jobId}) super.argument,
  }) : super(
         retry: null,
         name: r'lineReorderControllerProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$lineReorderControllerHash();

  @override
  String toString() {
    return r'lineReorderControllerProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  LineReorderController create() => LineReorderController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LineReorderState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LineReorderState>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is LineReorderControllerProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$lineReorderControllerHash() =>
    r'd328b0da71cad7ac23d1b6b0034c6b34150d9f20';

final class LineReorderControllerFamily extends $Family
    with
        $ClassFamilyOverride<
          LineReorderController,
          LineReorderState,
          LineReorderState,
          LineReorderState,
          ({String projectId, String jobId})
        > {
  LineReorderControllerFamily._()
    : super(
        retry: null,
        name: r'lineReorderControllerProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  LineReorderControllerProvider call({
    required String projectId,
    required String jobId,
  }) => LineReorderControllerProvider._(
    argument: (projectId: projectId, jobId: jobId),
    from: this,
  );

  @override
  String toString() => r'lineReorderControllerProvider';
}

abstract class _$LineReorderController extends $Notifier<LineReorderState> {
  late final _$args = ref.$arg as ({String projectId, String jobId});
  String get projectId => _$args.projectId;
  String get jobId => _$args.jobId;

  LineReorderState build({required String projectId, required String jobId});
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<LineReorderState, LineReorderState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<LineReorderState, LineReorderState>,
              LineReorderState,
              Object?,
              Object?
            >;
    return element.handleCreate(
      ref,
      () => build(projectId: _$args.projectId, jobId: _$args.jobId),
    );
  }
}
