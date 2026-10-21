import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:timezone/data/latest.dart' as tzdata;

import 'package:app/features/projects/presentation/widgets/project_client_cell.dart';

import '../../../../helpers/fixtures.dart';

void main() {
  setUpAll(tzdata.initializeTimeZones);

  final now = DateTime.utc(2026, 10, 20, 18);

  Future<void> pumpCell(
    WidgetTester tester, {
    required Widget cell,
  }) async {
    await tester.pumpWidget(MaterialApp(home: Scaffold(body: cell)));
  }

  testWidgets('upcoming appointment shows the weekday and time', (tester) async {
    await pumpCell(
      tester,
      cell: ProjectClientCell(
        row: melgarOak,
        now: now,
        timeZone: qualityDeck.timezone,
      ),
    );

    expect(find.text('Ana Melgar'), findsOneWidget);
    expect(find.text('Fri Oct 23 · 9:00 AM'), findsOneWidget);
  });

  testWidgets('past appointment shows Past and the date', (tester) async {
    await pumpCell(
      tester,
      cell: ProjectClientCell(
        row: whitakerPast,
        now: now,
        timeZone: qualityDeck.timezone,
      ),
    );

    expect(find.text('James Whitaker'), findsOneWidget);
    expect(find.text('Past · Oct 3'), findsOneWidget);
  });

  testWidgets('no appointment shows only the name', (tester) async {
    await pumpCell(
      tester,
      cell: ProjectClientCell(
        row: noAppointmentRow,
        now: now,
        timeZone: qualityDeck.timezone,
      ),
    );

    expect(find.text('Priya Shah'), findsOneWidget);
    expect(find.text('No appointment'), findsNothing);
    expect(find.textContaining('Past'), findsNothing);
  });

  testWidgets('removed client is marked', (tester) async {
    await pumpCell(
      tester,
      cell: ProjectClientCell(
        row: removedClientRow,
        now: now,
        timeZone: qualityDeck.timezone,
      ),
    );

    expect(find.text('Old Client One (removed)'), findsOneWidget);
  });

  testWidgets('has no tappable controls', (tester) async {
    await pumpCell(
      tester,
      cell: ProjectClientCell(
        row: melgarOak,
        now: now,
        timeZone: qualityDeck.timezone,
      ),
    );

    expect(find.byType(InkWell), findsNothing);
    expect(find.byType(TextButton), findsNothing);
    expect(find.byType(IconButton), findsNothing);
    expect(find.byType(GestureDetector), findsNothing);
  });
}
