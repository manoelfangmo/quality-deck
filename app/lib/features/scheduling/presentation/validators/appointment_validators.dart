abstract final class AppointmentValidators {
  static const durations = [30, 60, 90, 120, 180, 240];
  static const maxNotes = 2000;
  static const defaultDurationMinutes = 60;
  static const defaultStartHour = 9;
  static const defaultStartMinute = 0;

  static int snapDuration(int minutes) {
    return durations.reduce((a, b) {
      final aDiff = (a - minutes).abs();
      final bDiff = (b - minutes).abs();
      return aDiff <= bDiff ? a : b;
    });
  }

  static String? date(DateTime? value) {
    if (value == null) return 'Pick a date.';
    return null;
  }

  static String? startTime({int? hour, int? minute}) {
    if (hour == null || minute == null) return 'Pick a start time.';
    if (hour < 0 || hour > 23 || minute < 0 || minute > 59) {
      return 'Pick a start time.';
    }
    return null;
  }

  static String? duration(int? minutes) {
    if (minutes == null || !durations.contains(minutes)) {
      return 'Pick a duration.';
    }
    return null;
  }

  static String? notes(String? value) {
    if ((value?.length ?? 0) > maxNotes) {
      return 'Keep notes under 2,000 characters.';
    }
    return null;
  }
}
