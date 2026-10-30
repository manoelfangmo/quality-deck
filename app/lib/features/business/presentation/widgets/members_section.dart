import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:app/core/domain/user_role.dart';
import 'package:app/core/widgets/confirm_dialog.dart';
import 'package:app/core/widgets/error_retry.dart';
import 'package:app/features/auth/presentation/controllers/current_user.dart';
import 'package:app/features/business/domain/member.dart';
import 'package:app/features/business/presentation/controllers/members.dart';

class MembersSection extends ConsumerWidget {
  const MembersSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider).value;
    ref.watch(membersControllerProvider);
    final members = ref.watch(membersProvider);
    final isOwner = user?.isOwner ?? false;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('Members', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 8),
        members.when(
          loading: () => const Padding(
            padding: EdgeInsets.symmetric(vertical: 24),
            child: Center(child: CircularProgressIndicator()),
          ),
          error: (error, stackTrace) => ErrorRetry(
            onRetry: () => ref.invalidate(membersProvider),
          ),
          data: (list) {
            return Column(
              children: [
                for (final member in list)
                  _MemberTile(
                    member: member,
                    canRemove: isOwner && member.id != user?.id,
                  ),
              ],
            );
          },
        ),
      ],
    );
  }
}

class _MemberTile extends ConsumerWidget {
  const _MemberTile({required this.member, required this.canRemove});

  final Member member;
  final bool canRemove;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final joined = DateFormat.MMMd().format(member.joinedAt);
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(member.fullName),
      subtitle: Text(
        '${member.email}\n${member.role == UserRole.owner ? 'Owner' : 'Member'} · Joined $joined',
      ),
      isThreeLine: true,
      trailing: canRemove
          ? TextButton(
              onPressed: () => _confirmRemove(context, ref),
              child: const Text('Remove'),
            )
          : null,
    );
  }

  Future<void> _confirmRemove(BuildContext context, WidgetRef ref) async {
    final confirmed = await showConfirmDialog(
      context: context,
      title: 'Remove ${member.fullName}?',
      body: "They'll be signed out and lose access right away.",
      confirmLabel: 'Remove',
    );
    if (!confirmed) return;
    await ref.read(membersControllerProvider.notifier).removeMember(member.id);
  }
}
