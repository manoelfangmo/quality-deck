import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:app/core/domain/app_exception.dart';
import 'package:app/features/auth/presentation/controllers/current_user.dart';
import 'package:app/features/business/data/business_repository.dart';
import 'package:app/features/business/data/models.dart';
import 'package:app/features/business/domain/invite_code.dart';
import 'package:app/features/business/presentation/controllers/members.dart';
import 'package:app/features/business/presentation/models/onboarding_form_state.dart';

part 'onboarding_controller.g.dart';

@riverpod
class OnboardingController extends _$OnboardingController {
  @override
  OnboardingFormState build() => const OnboardingFormState();

  void setInviteCode(String value) {
    state = state.copyWith(inviteCode: value.toUpperCase(), errorMessage: null);
  }

  void setBusinessName(String value) {
    state = state.copyWith(businessName: value, errorMessage: null);
  }

  Future<void> submit() async {
    state = state.copyWith(isSubmitting: true, errorMessage: null);
    try {
      final repo = ref.read(businessRepositoryProvider);
      if (state.inviteCode.trim().isEmpty) {
        await repo.createBusiness(
          CreateBusinessCommand(name: state.businessName.trim()),
        );
      } else {
        await repo.redeemInvite(
          RedeemInviteCommand(code: normalizeInviteCode(state.inviteCode)),
        );
      }
      ref.invalidate(currentUserProvider);
      ref.invalidate(membersProvider);
    } on AppException catch (error) {
      state = state.copyWith(isSubmitting: false, errorMessage: error.message);
    } catch (_) {
      state = state.copyWith(
        isSubmitting: false,
        errorMessage: 'Something went wrong.',
      );
    }
  }
}
