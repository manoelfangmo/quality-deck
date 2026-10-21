import 'package:freezed_annotation/freezed_annotation.dart';

part 'address.freezed.dart';
part 'address.g.dart';

@freezed
abstract class Address with _$Address {
  const Address._();

  const factory Address({
    required String street,
    required String city,
    required String state,
    required String zip,
  }) = _Address;

  factory Address.fromJson(Map<String, dynamic> json) =>
      _$AddressFromJson(json);

  static Address? maybeFromRow(Map<String, dynamic> json) {
    final street = json['street'] as String?;
    final city = json['city'] as String?;
    final state = json['state'] as String?;
    final zip = json['zip'] as String?;
    if (street == null && city == null && state == null && zip == null) {
      return null;
    }
    return Address(
      street: street ?? '',
      city: city ?? '',
      state: state ?? '',
      zip: zip ?? '',
    );
  }

  String get oneLine => '$street, $city, $state $zip';

  String get cityState => '$city, $state';
}
