// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'line_form.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(LineFormController)
final lineFormControllerProvider = LineFormControllerFamily._();

final class LineFormControllerProvider
    extends $NotifierProvider<LineFormController, LineFormState> {
  LineFormControllerProvider._({
    required LineFormControllerFamily super.from,
    required ({String projectId, String jobId, LineItem? item}) super.argument,
  }) : super(
         retry: null,
         name: r'lineFormControllerProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$lineFormControllerHash();

  @override
  String toString() {
    return r'lineFormControllerProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  LineFormController create() => LineFormController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LineFormState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LineFormState>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is LineFormControllerProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$lineFormControllerHash() =>
    r'a82c1b7c8cfc1cee9c1dfbf2d30ce257ce8bcf9e';

final class LineFormControllerFamily extends $Family
    with
        $ClassFamilyOverride<
          LineFormController,
          LineFormState,
          LineFormState,
          LineFormState,
          ({String projectId, String jobId, LineItem? item})
        > {
  LineFormControllerFamily._()
    : super(
        retry: null,
        name: r'lineFormControllerProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  LineFormControllerProvider call({
    required String projectId,
    required String jobId,
    LineItem? item,
  }) => LineFormControllerProvider._(
    argument: (projectId: projectId, jobId: jobId, item: item),
    from: this,
  );

  @override
  String toString() => r'lineFormControllerProvider';
}

abstract class _$LineFormController extends $Notifier<LineFormState> {
  late final _$args =
      ref.$arg as ({String projectId, String jobId, LineItem? item});
  String get projectId => _$args.projectId;
  String get jobId => _$args.jobId;
  LineItem? get item => _$args.item;

  LineFormState build({
    required String projectId,
    required String jobId,
    LineItem? item,
  });
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<LineFormState, LineFormState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<LineFormState, LineFormState>,
              LineFormState,
              Object?,
              Object?
            >;
    return element.handleCreate(
      ref,
      () => build(
        projectId: _$args.projectId,
        jobId: _$args.jobId,
        item: _$args.item,
      ),
    );
  }
}
