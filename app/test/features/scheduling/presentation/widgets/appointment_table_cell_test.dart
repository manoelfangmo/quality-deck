import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:timezone/data/latest.dart' as tzdata;

import 'package:app/features/scheduling/presentation/widgets/appointment_table_cell.dart';

void main() {
  setUpAll(tzdata.initializeTimeZones);

  const timeZone = 'America/New_York';
  final now = DateTime.utc(2026, 10, 20, 16);

  Future<void> pumpCell(WidgetTester tester, DateTime? startsAt) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AppointmentTableCell(
            startsAt: startsAt,
            now: now,
            timeZone: timeZone,
          ),
        ),
      ),
    );
  }

  testWidgets('upcoming text', (tester) async {
    await pumpCell(tester, DateTime.utc(2026, 10, 23, 13));
    expect(find.text('Fri Oct 23 · 9:00 AM'), findsOneWidget);
  });

  testWidgets('past text', (tester) async {
    await pumpCell(tester, DateTime.utc(2026, 10, 3, 14));
    expect(find.text('Past · Oct 3'), findsOneWidget);
  });

  testWidgets('blank when there is no appointment', (tester) async {
    await pumpCell(tester, null);
    expect(find.textContaining('Oct'), findsNothing);
    expect(find.textContaining('Past'), findsNothing);
  });
}
