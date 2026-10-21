import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:app/features/auth/presentation/controllers/current_user.dart';
import 'package:app/features/business/data/business_repository.dart';
import 'package:app/features/business/domain/member.dart';

part 'members.g.dart';

@riverpod
Future<List<Member>> members(Ref ref) {
  return ref.watch(businessRepositoryProvider).fetchMembers();
}

@riverpod
class MembersController extends _$MembersController {
  @override
  void build() {}

  Future<void> removeMember(String userId) async {
    await ref.read(businessRepositoryProvider).removeMember(userId);
    if (!ref.mounted) return;
    ref.invalidate(membersProvider);
    ref.invalidate(currentUserProvider);
  }
}
