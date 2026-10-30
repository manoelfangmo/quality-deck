import 'package:flutter_test/flutter_test.dart';
import 'package:timezone/data/latest.dart' as tzdata;

import 'package:app/core/domain/business_time.dart';

void main() {
  setUpAll(tzdata.initializeTimeZones);

  const timeZone = 'America/New_York';
  BusinessTime businessTime() => BusinessTime(timeZone);

  test('9:00 AM converts to UTC before the Nov 1 2026 DST change', () {
    final utc = businessTime().toUtc(
      date: DateTime(2026, 10, 31),
      startHour: 9,
      startMinute: 0,
    );
    expect(utc, DateTime.utc(2026, 10, 31, 13));

    final back = businessTime().toBusiness(utc);
    expect(back.year, 2026);
    expect(back.month, 10);
    expect(back.day, 31);
    expect(back.hour, 9);
    expect(back.minute, 0);
  });

  test('9:00 AM converts to UTC after the Nov 1 2026 DST change', () {
    final utc = businessTime().toUtc(
      date: DateTime(2026, 11, 1),
      startHour: 9,
      startMinute: 0,
    );
    expect(utc, DateTime.utc(2026, 11, 1, 14));

    final back = businessTime().toBusiness(utc);
    expect(back.year, 2026);
    expect(back.month, 11);
    expect(back.day, 1);
    expect(back.hour, 9);
    expect(back.minute, 0);
  });

  test('display formats as specified', () {
    final upcoming = DateTime.utc(2026, 10, 23, 13);
    expect(
      businessTime().formatTile(upcoming, 60),
      'Fri Oct 23 · 9:00 AM · 1 hr',
    );
    expect(businessTime().formatTableUpcoming(upcoming), 'Fri Oct 23 · 9:00 AM');
    expect(
      businessTime().formatTablePast(DateTime.utc(2026, 10, 3, 14)),
      'Past · Oct 3',
    );
    expect(BusinessTime.formatDuration(30), '30 min');
    expect(BusinessTime.formatDuration(90), '1.5 hr');
    expect(BusinessTime.formatDuration(120), '2 hr');
  });
}
