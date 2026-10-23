// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'export_proposal.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ExportProposalController)
final exportProposalControllerProvider = ExportProposalControllerFamily._();

final class ExportProposalControllerProvider
    extends $NotifierProvider<ExportProposalController, ExportProposalState> {
  ExportProposalControllerProvider._({
    required ExportProposalControllerFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'exportProposalControllerProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$exportProposalControllerHash();

  @override
  String toString() {
    return r'exportProposalControllerProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  ExportProposalController create() => ExportProposalController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ExportProposalState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ExportProposalState>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is ExportProposalControllerProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$exportProposalControllerHash() =>
    r'4fa40b79055f9775c5957367657d1467d3485054';

final class ExportProposalControllerFamily extends $Family
    with
        $ClassFamilyOverride<
          ExportProposalController,
          ExportProposalState,
          ExportProposalState,
          ExportProposalState,
          String
        > {
  ExportProposalControllerFamily._()
    : super(
        retry: null,
        name: r'exportProposalControllerProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  ExportProposalControllerProvider call(String projectId) =>
      ExportProposalControllerProvider._(argument: projectId, from: this);

  @override
  String toString() => r'exportProposalControllerProvider';
}

abstract class _$ExportProposalController
    extends $Notifier<ExportProposalState> {
  late final _$args = ref.$arg as String;
  String get projectId => _$args;

  ExportProposalState build(String projectId);
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<ExportProposalState, ExportProposalState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<ExportProposalState, ExportProposalState>,
              ExportProposalState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, () => build(_$args));
  }
}
