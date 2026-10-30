import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:app/core/routing/app_routes.dart';
import 'package:app/features/auth/presentation/controllers/auth_controller.dart';
import 'package:app/features/auth/presentation/controllers/current_user.dart';
import 'package:app/features/business/presentation/controllers/current_business.dart';

class AccountMenu extends ConsumerWidget {
  const AccountMenu({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider).value;
    final business = ref.watch(currentBusinessProvider).value;

    return PopupMenuButton<String>(
      tooltip: 'Account',
      constraints: const BoxConstraints(minWidth: 44, minHeight: 44),
      onSelected: (value) async {
        if (value == 'settings') {
          context.push(AppRoutes.settings);
        } else if (value == 'sign-out') {
          await ref.read(authControllerProvider.notifier).signOut();
        }
      },
      itemBuilder: (context) {
        return [
          PopupMenuItem<String>(
            enabled: false,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user?.fullName ?? '',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                Text(
                  user?.email ?? '',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                if (business != null)
                  Text(
                    business.name,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
              ],
            ),
          ),
          const PopupMenuDivider(),
          const PopupMenuItem(value: 'settings', child: Text('Settings')),
          const PopupMenuItem(value: 'sign-out', child: Text('Sign out')),
        ];
      },
      child: const Padding(
        padding: EdgeInsets.all(12),
        child: Icon(Icons.account_circle),
      ),
    );
  }
}
