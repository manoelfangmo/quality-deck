import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:app/core/routing/app_routes.dart';
import 'package:app/features/auth/presentation/widgets/auth_scaffold.dart';

class CheckEmailPage extends StatelessWidget {
  const CheckEmailPage({super.key, this.email});

  final String? email;

  @override
  Widget build(BuildContext context) {
    final address = email == null || email!.isEmpty ? 'your email' : email;
    return AuthScaffold(
      title: 'Check your email',
      subtitle:
          'We sent a link to $address. Open it on this device to continue.',
      child: TextButton(
        onPressed: () => context.go(AppRoutes.signIn),
        child: const Text('Back to sign in'),
      ),
    );
  }
}
