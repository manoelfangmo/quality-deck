import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:app/features/auth/data/auth_repository.dart';
import 'package:app/features/auth/presentation/controllers/current_user.dart';
import 'package:app/features/business/data/invites_repository.dart';
import 'package:app/features/business/presentation/controllers/invites.dart';
import 'package:app/features/business/presentation/widgets/invites_section.dart';

import '../../../../helpers/fixtures.dart';
import '../../../../mocks.dart';

void main() {
  late MockInvitesRepository invites;

  setUp(() {
    invites = MockInvitesRepository();
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
          invitesRepositoryProvider.overrideWithValue(invites),
          invitesProvider.overrideWith((ref) async {
            return [activeInvite, usedInvite];
          }),
        ],
        child: const MaterialApp(
          home: Scaffold(body: SingleChildScrollView(child: InvitesSection())),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('create shows the code and Copy', (tester) async {
    when(invites.fetchInvites()).thenAnswer((_) async => [activeInvite]);
    when(invites.createInvite()).thenAnswer((_) async => activeInvite);

    await pumpSection(tester, user: FakeCurrentUser(ownerUser));

    await tester.tap(find.widgetWithText(FilledButton, 'Create invite'));
    await tester.pumpAndSettle();

    verify(invites.createInvite()).called(1);
    expect(find.text(activeInvite.code), findsWidgets);
    expect(find.text('Copy'), findsOneWidget);
  });

  testWidgets('revoke is only offered on active invites', (tester) async {
    await pumpSection(tester, user: FakeCurrentUser(ownerUser));

    expect(find.text('Revoke'), findsOneWidget);
    expect(find.text(activeInvite.code), findsOneWidget);
    expect(find.text(usedInvite.code), findsOneWidget);
  });

  testWidgets('hidden entirely for members', (tester) async {
    await pumpSection(tester, user: FakeCurrentUser(memberUser));

    expect(find.text('Create invite'), findsNothing);
    expect(find.text('Invites'), findsNothing);
  });
}
