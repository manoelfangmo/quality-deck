import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:app/core/utils/toasts.dart';
import 'package:app/core/widgets/confirm_dialog.dart';
import 'package:app/core/widgets/error_retry.dart';
import 'package:app/core/widgets/loading_button.dart';
import 'package:app/features/auth/presentation/controllers/auth_notice.dart';
import 'package:app/features/auth/presentation/controllers/current_user.dart';
import 'package:app/features/business/domain/invite.dart';
import 'package:app/features/business/domain/invite_status.dart';
import 'package:app/features/business/presentation/controllers/invites.dart';

class InvitesSection extends ConsumerStatefulWidget {
  const InvitesSection({super.key});

  @override
  ConsumerState<InvitesSection> createState() => _InvitesSectionState();
}

class _InvitesSectionState extends ConsumerState<InvitesSection> {
  Invite? _created;
  var _creating = false;

  Future<void> _create() async {
    setState(() => _creating = true);
    try {
      final invite = await ref
          .read(invitesControllerProvider.notifier)
          .createInvite();
      if (mounted) {
        setState(() {
          _created = invite;
          _creating = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _creating = false);
    }
  }

  Future<void> _copy(String code) async {
    await Clipboard.setData(ClipboardData(text: code));
    if (mounted) {
      AppSnackbars.show(context, AuthMessages.codeCopied);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(currentUserProvider).value;
    ref.watch(invitesControllerProvider);
    if (user == null || !user.isOwner) {
      return const SizedBox.shrink();
    }

    final invites = ref.watch(invitesProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('Invites', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 8),
        LoadingButton(
          label: 'Create invite',
          isLoading: _creating,
          onPressed: _create,
        ),
        if (_created != null) ...[
          const SizedBox(height: 16),
          Text(
            _created!.code,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 8),
          OutlinedButton(
            onPressed: () => _copy(_created!.code),
            child: const Text('Copy'),
          ),
        ],
        const SizedBox(height: 16),
        invites.when(
          loading: () => const Padding(
            padding: EdgeInsets.symmetric(vertical: 24),
            child: Center(child: CircularProgressIndicator()),
          ),
          error: (error, stackTrace) => ErrorRetry(
            onRetry: () => ref.invalidate(invitesProvider),
          ),
          data: (list) {
            if (list.isEmpty) {
              return const Text('No invites yet.');
            }
            return Column(
              children: [
                for (final invite in list) _InviteTile(invite: invite),
              ],
            );
          },
        ),
      ],
    );
  }
}

class _InviteTile extends ConsumerWidget {
  const _InviteTile({required this.invite});

  final Invite invite;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final expiry = DateFormat.MMMd().format(invite.expiresAt);
    final statusLabel = switch (invite.status) {
      InviteStatus.active => 'Active · Expires $expiry',
      InviteStatus.used =>
        'Used${invite.usedByName == null ? '' : ' by ${invite.usedByName}'}',
      InviteStatus.expired => 'Expired',
      InviteStatus.revoked => 'Cancelled',
    };

    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(invite.code),
      subtitle: Text(statusLabel),
      trailing: invite.status == InviteStatus.active
          ? TextButton(
              onPressed: () => _confirmRevoke(context, ref),
              child: const Text('Revoke'),
            )
          : null,
    );
  }

  Future<void> _confirmRevoke(BuildContext context, WidgetRef ref) async {
    final confirmed = await showConfirmDialog(
      context: context,
      title: 'Revoke ${invite.code}?',
      body: "That code won't work after this.",
      confirmLabel: 'Revoke',
    );
    if (!confirmed) return;
    await ref.read(invitesControllerProvider.notifier).revokeInvite(invite.id);
  }
}
