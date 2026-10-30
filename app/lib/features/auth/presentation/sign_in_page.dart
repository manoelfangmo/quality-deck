import 'package:flutter/material.dart';

import 'package:app/features/auth/presentation/widgets/auth_scaffold.dart';
import 'package:app/features/auth/presentation/widgets/sign_in_form.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const AuthScaffold(
      title: 'Sign in',
      subtitle: 'Welcome back. Sign in to continue.',
      child: SignInForm(),
    );
  }
}
