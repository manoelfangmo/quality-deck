import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:app/core/domain/app_exception.dart';
import 'package:app/features/auth/data/auth_repository.dart';
import 'package:app/features/auth/presentation/controllers/current_user.dart';
import 'package:app/features/business/data/business_repository.dart';
import 'package:app/features/business/data/models.dart';
import 'package:app/features/business/presentation/controllers/onboarding_controller.dart';

import '../../../../helpers/fixtures.dart';
import '../../../../mocks.dart';

void main() {
  late MockBusinessRepository business;
  late MockAuthRepository auth;

  ProviderContainer container() {
    return ProviderContainer(
      retry: (count, error) => null,
      overrides: [
        businessRepositoryProvider.overrideWithValue(business),
        authRepositoryProvider.overrideWithValue(auth),
        currentUserProvider.overrideWith(() => FakeCurrentUser(noBusinessUser)),
        authStateChangesProvider.overrideWith(
          (ref) => Stream<AuthState>.empty(),
        ),
      ],
    );
  }

  setUp(() {
    business = MockBusinessRepository();
    auth = MockAuthRepository();
  });

  test('blank code calls createBusiness(name)', () async {
    when(business.createBusiness(any)).thenAnswer((_) async => 'biz-id');

    final c = container();
    addTearDown(c.dispose);
    final notifier = c.read(onboardingControllerProvider.notifier);
    notifier.setBusinessName('  Test Decks  ');
    await notifier.submit();

    final command =
        verify(business.createBusiness(captureAny)).captured.single
            as CreateBusinessCommand;
    expect(command.name, 'Test Decks');
    verifyNever(business.redeemInvite(any));
  });

  test('non-blank code calls redeemInvite and never createBusiness', () async {
    when(business.redeemInvite(any)).thenAnswer((_) async => 'biz-id');

    final c = container();
    addTearDown(c.dispose);
    final notifier = c.read(onboardingControllerProvider.notifier);
    notifier.setInviteCode('qd-active');
    notifier.setBusinessName('Should Not Be Used');
    await notifier.submit();

    final command =
        verify(business.redeemInvite(captureAny)).captured.single
            as RedeemInviteCommand;
    expect(command.code, 'QDACTIVE');
    verifyNever(business.createBusiness(any));
  });

  test('each Q0 error surfaces the right message and leaves state editable', () async {
    const cases = {
      'invite_not_found':
          "That code doesn't match any invite. Check it and try again.",
      'invite_expired': 'That invite has expired. Ask for a new code.',
      'invite_used': 'That invite has already been used. Ask for a new code.',
      'invite_revoked': 'That invite was cancelled. Ask for a new code.',
      'already_in_business': "You're already part of a business.",
      'invalid_business_name': 'Enter a business name (up to 80 characters).',
    };

    for (final entry in cases.entries) {
      business = MockBusinessRepository();
      when(
        business.redeemInvite(any),
      ).thenThrow(AppException.fromToken(entry.key));

      final c = container();
      addTearDown(c.dispose);
      final notifier = c.read(onboardingControllerProvider.notifier);
      notifier.setInviteCode('ABCDEFGH');
      await notifier.submit();

      final state = c.read(onboardingControllerProvider);
      expect(state.errorMessage, entry.value, reason: entry.key);
      expect(state.isSubmitting, isFalse);
    }
  });
}
