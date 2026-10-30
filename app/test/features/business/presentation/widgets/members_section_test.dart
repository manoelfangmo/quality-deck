import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:app/features/auth/data/auth_repository.dart';
import 'package:app/features/auth/presentation/controllers/current_user.dart';
import 'package:app/features/business/data/business_repository.dart';
import 'package:app/features/business/presentation/controllers/members.dart';
import 'package:app/features/business/presentation/widgets/members_section.dart';

import '../../../../helpers/fixtures.dart';
import '../../../../mocks.dart';

void main() {
  late MockBusinessRepository business;

  setUp(() {
    business = MockBusinessRepository();
  });

  Future<void> pumpSection(
    WidgetTester tester, {
    required FakeCurrentUser user,
  }) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          currentUserProvider.overrideWith(() => user),
          authStateChangesProvider.overrideWith(
            (ref) => Stream<AuthState>.empty(),
          ),
          authRepositoryProvider.overrideWithValue(MockAuthRepository()),
          businessRepositoryProvider.overrideWithValue(business),
          membersProvider.overrideWith((ref) async => [ownerMember, crewMember]),
        ],
        child: const MaterialApp(
          home: Scaffold(body: SingleChildScrollView(child: MembersSection())),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('Remove is hidden for self', (tester) async {
    await pumpSection(tester, user: FakeCurrentUser(ownerUser));
    expect(find.text('Remove'), findsOneWidget);
    expect(find.text(ownerMember.fullName), findsOneWidget);
  });

  testWidgets('Remove is hidden for members viewing', (tester) async {
    await pumpSection(tester, user: FakeCurrentUser(memberUser));
    expect(find.text('Remove'), findsNothing);
  });

  testWidgets('confirmation is required before removing', (tester) async {
    when(business.removeMember(any)).thenAnswer((_) async {});

    await pumpSection(tester, user: FakeCurrentUser(ownerUser));
    await tester.tap(find.text('Remove'));
    await tester.pumpAndSettle();

    expect(find.text('Remove Crew Member?'), findsOneWidget);
    verifyNever(business.removeMember(any));

    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();
    verifyNever(business.removeMember(any));

    await tester.tap(find.text('Remove'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(TextButton, 'Remove').last);
    await tester.pumpAndSettle();

    verify(business.removeMember(crewMember.id)).called(1);
  });
}
