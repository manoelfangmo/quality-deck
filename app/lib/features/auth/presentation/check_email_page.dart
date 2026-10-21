import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:app/core/routing/app_routes.dart';

class CheckEmailPage extends StatelessWidget {
  const CheckEmailPage({super.key, this.email});

  final String? email;

  @override
  Widget build(BuildContext context) {
    final address = email == null || email!.isEmpty ? 'your email' : email;
    return Scaffold(
      appBar: AppBar(title: const Text('Check your email')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'We sent a link to $address. Open it on this device to continue.',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 24),
              TextButton(
                onPressed: () => context.go(AppRoutes.signIn),
                child: const Text('Back to sign in'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
