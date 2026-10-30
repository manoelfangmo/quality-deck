enum InviteStatus {
  active,
  used,
  expired,
  revoked;

  String toDb() => name;

  static InviteStatus fromDb(String value) {
    return InviteStatus.values.firstWhere(
      (status) => status.name == value,
      orElse: () => throw FormatException('Unknown invite status: $value'),
    );
  }
}
