// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'proposal_export_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(proposalExportService)
final proposalExportServiceProvider = ProposalExportServiceProvider._();

final class ProposalExportServiceProvider
    extends
        $FunctionalProvider<
          ProposalExportService,
          ProposalExportService,
          ProposalExportService
        >
    with $Provider<ProposalExportService> {
  ProposalExportServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'proposalExportServiceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$proposalExportServiceHash();

  @$internal
  @override
  $ProviderElement<ProposalExportService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ProposalExportService create(Ref ref) {
    return proposalExportService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ProposalExportService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ProposalExportService>(value),
    );
  }
}

String _$proposalExportServiceHash() =>
    r'40fb655a292b65d48d2aa2273d4412218cf5f5b6';

@ProviderFor(proposalExportsRepository)
final proposalExportsRepositoryProvider = ProposalExportsRepositoryProvider._();

final class ProposalExportsRepositoryProvider
    extends
        $FunctionalProvider<
          ProposalExportsRepository,
          ProposalExportsRepository,
          ProposalExportsRepository
        >
    with $Provider<ProposalExportsRepository> {
  ProposalExportsRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'proposalExportsRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$proposalExportsRepositoryHash();

  @$internal
  @override
  $ProviderElement<ProposalExportsRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ProposalExportsRepository create(Ref ref) {
    return proposalExportsRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ProposalExportsRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ProposalExportsRepository>(value),
    );
  }
}

String _$proposalExportsRepositoryHash() =>
    r'6a8d63fefd6a5278924ce16700ffb72380de389e';

@ProviderFor(pdfFileHandler)
final pdfFileHandlerProvider = PdfFileHandlerProvider._();

final class PdfFileHandlerProvider
    extends $FunctionalProvider<PdfFileHandler, PdfFileHandler, PdfFileHandler>
    with $Provider<PdfFileHandler> {
  PdfFileHandlerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'pdfFileHandlerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$pdfFileHandlerHash();

  @$internal
  @override
  $ProviderElement<PdfFileHandler> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  PdfFileHandler create(Ref ref) {
    return pdfFileHandler(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PdfFileHandler value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PdfFileHandler>(value),
    );
  }
}

String _$pdfFileHandlerHash() => r'975c142569c747b71f7c5e70570d959e645465dc';

@ProviderFor(proposalExports)
final proposalExportsProvider = ProposalExportsFamily._();

final class ProposalExportsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<ProposalExportRecord>>,
          List<ProposalExportRecord>,
          FutureOr<List<ProposalExportRecord>>
        >
    with
        $FutureModifier<List<ProposalExportRecord>>,
        $FutureProvider<List<ProposalExportRecord>> {
  ProposalExportsProvider._({
    required ProposalExportsFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'proposalExportsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$proposalExportsHash();

  @override
  String toString() {
    return r'proposalExportsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<ProposalExportRecord>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<ProposalExportRecord>> create(Ref ref) {
    final argument = this.argument as String;
    return proposalExports(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is ProposalExportsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$proposalExportsHash() => r'68a1b582bff095a324e68ea8b888471128fd349a';

final class ProposalExportsFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<List<ProposalExportRecord>>,
          String
        > {
  ProposalExportsFamily._()
    : super(
        retry: null,
        name: r'proposalExportsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  ProposalExportsProvider call(String projectId) =>
      ProposalExportsProvider._(argument: projectId, from: this);

  @override
  String toString() => r'proposalExportsProvider';
}
