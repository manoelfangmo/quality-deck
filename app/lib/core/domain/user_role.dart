enum UserRole {
  owner,
  member;

  String toDb() => name;

  static UserRole fromDb(String value) {
    return UserRole.values.firstWhere(
      (role) => role.name == value,
      orElse: () => throw FormatException('Unknown user role: $value'),
    );
  }
}
