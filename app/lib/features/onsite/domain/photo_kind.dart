enum PhotoKind {
  before,
  concept,
  after;

  String toDb() => name;

  static PhotoKind fromDb(String value) {
    return PhotoKind.values.firstWhere(
      (kind) => kind.toDb() == value,
      orElse: () => throw FormatException('Unknown photo kind: $value'),
    );
  }

  String get label => switch (this) {
    PhotoKind.before => 'Before',
    PhotoKind.concept => 'Concept',
    PhotoKind.after => 'After',
  };

  String get emptyMessage => switch (this) {
    PhotoKind.before =>
      'No before photos yet. Add photos of the site as it is today.',
    PhotoKind.concept =>
      'No concept photos yet. Add mockups or design images for this job.',
    PhotoKind.after => 'No after photos yet. Add photos of the finished work.',
  };
}
