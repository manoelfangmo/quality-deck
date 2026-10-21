import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:app/features/pricing/presentation/widgets/pricing_settings_header.dart';

import '../../../../helpers/fixtures.dart';

void main() {
  testWidgets('header shows Not set and Set when values are null', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: PricingSettingsHeader(
            settings: unsetSettings,
            onEditLaborRate: () {},
            onEditOverhead: () {},
          ),
        ),
      ),
    );

    expect(find.text('Not set'), findsNWidgets(2));
    expect(find.widgetWithText(TextButton, 'Set'), findsNWidgets(2));
    expect(find.widgetWithText(TextButton, 'Edit'), findsNothing);
  });

  testWidgets('header shows the values and Edit when set', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: PricingSettingsHeader(
            settings: qualityDeckSettings,
            onEditLaborRate: () {},
            onEditOverhead: () {},
          ),
        ),
      ),
    );

    expect(find.text(r'$65.00 / hr'), findsOneWidget);
    expect(find.text('12.5%'), findsOneWidget);
    expect(find.widgetWithText(TextButton, 'Edit'), findsNWidgets(2));
    expect(find.textContaining('Moises (dev)'), findsWidgets);
  });
}
