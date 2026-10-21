// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'client_appointment.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(clientAppointment)
final clientAppointmentProvider = ClientAppointmentFamily._();

final class ClientAppointmentProvider
    extends
        $FunctionalProvider<
          AsyncValue<Appointment?>,
          Appointment?,
          FutureOr<Appointment?>
        >
    with $FutureModifier<Appointment?>, $FutureProvider<Appointment?> {
  ClientAppointmentProvider._({
    required ClientAppointmentFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'clientAppointmentProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$clientAppointmentHash();

  @override
  String toString() {
    return r'clientAppointmentProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<Appointment?> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<Appointment?> create(Ref ref) {
    final argument = this.argument as String;
    return clientAppointment(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is ClientAppointmentProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$clientAppointmentHash() => r'0046fccf63d07fde34fe9b69b94af3546ec4904b';

final class ClientAppointmentFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<Appointment?>, String> {
  ClientAppointmentFamily._()
    : super(
        retry: null,
        name: r'clientAppointmentProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  ClientAppointmentProvider call(String clientId) =>
      ClientAppointmentProvider._(argument: clientId, from: this);

  @override
  String toString() => r'clientAppointmentProvider';
}
