import 'package:intl/intl.dart';
import 'package:timezone/timezone.dart' as tz;

class BusinessTime {
  BusinessTime(this.timeZoneName) : location = tz.getLocation(timeZoneName);

  final String timeZoneName;
  final tz.Location location;

  static const _locale = 'en_US';

  tz.TZDateTime toBusiness(DateTime instant) =>
      tz.TZDateTime.from(instant.toUtc(), location);

  DateTime toUtc({
    required DateTime date,
    required int startHour,
    required int startMinute,
  }) {
    final local = tz.TZDateTime(
      location,
      date.year,
      date.month,
      date.day,
      startHour,
      startMinute,
    );
    return local.toUtc();
  }

  DateTime calendarDate(DateTime instant) {
    final local = toBusiness(instant);
    return DateTime(local.year, local.month, local.day);
  }

  DateTime tomorrowDate(DateTime instant) {
    return calendarDate(instant).add(const Duration(days: 1));
  }

  ({int hour, int minute}) timeOfDay(DateTime instant) {
    final local = toBusiness(instant);
    return (hour: local.hour, minute: local.minute);
  }

  String formatTile(DateTime startsAtUtc, int durationMinutes) {
    final local = toBusiness(startsAtUtc);
    return '${_day(local)} · ${_time(local)} · ${formatDuration(durationMinutes)}';
  }

  String formatTableUpcoming(DateTime startsAtUtc) {
    final local = toBusiness(startsAtUtc);
    return '${_day(local)} · ${_time(local)}';
  }

  String formatTablePast(DateTime startsAtUtc) {
    final local = toBusiness(startsAtUtc);
    return 'Past · ${DateFormat('MMM d', _locale).format(local)}';
  }

  static String formatDuration(int minutes) {
    if (minutes < 60) return '$minutes min';
    if (minutes % 60 == 0) return '${minutes ~/ 60} hr';
    final hours = minutes / 60;
    final formatted = hours.toStringAsFixed(1);
    return '${formatted.replaceFirst(RegExp(r'\.0$'), '')} hr';
  }

  static String formatClock(int hour, int minute) {
    final local = DateTime(2000, 1, 1, hour, minute);
    return DateFormat('h:mm a', _locale).format(local);
  }

  static String _day(DateTime local) =>
      DateFormat('E MMM d', _locale).format(local);

  static String _time(DateTime local) =>
      DateFormat('h:mm a', _locale).format(local);
}
