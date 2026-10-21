enum JobType {
  deck,
  patio,
  hardscaping;

  String toDb() => name;

  static JobType fromDb(String value) {
    return JobType.values.firstWhere(
      (type) => type.toDb() == value,
      orElse: () => throw FormatException('Unknown job type: $value'),
    );
  }

  String get label => switch (this) {
    JobType.deck => 'Deck',
    JobType.patio => 'Patio',
    JobType.hardscaping => 'Hardscaping',
  };
}
