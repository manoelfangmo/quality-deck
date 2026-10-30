import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:app/features/business/data/invites_repository.dart';
import 'package:app/features/business/domain/invite.dart';

part 'invites.g.dart';

@riverpod
Future<List<Invite>> invites(Ref ref) {
  return ref.watch(invitesRepositoryProvider).fetchInvites();
}

@riverpod
class InvitesController extends _$InvitesController {
  @override
  void build() {}

  Future<Invite> createInvite() async {
    final invite = await ref.read(invitesRepositoryProvider).createInvite();
    if (ref.mounted) ref.invalidate(invitesProvider);
    return invite;
  }

  Future<void> revokeInvite(String inviteId) async {
    await ref.read(invitesRepositoryProvider).revokeInvite(inviteId);
    if (ref.mounted) ref.invalidate(invitesProvider);
  }
}
