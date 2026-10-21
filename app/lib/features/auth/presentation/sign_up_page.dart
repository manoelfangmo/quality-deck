import 'package:flutter/material.dart';

import 'package:app/features/auth/presentation/widgets/auth_scaffold.dart';
import 'package:app/features/auth/presentation/widgets/sign_up_form.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const AuthScaffold(
      title: 'Create account',
      subtitle: 'Set up your Field Notes account.',
      child: SignUpForm(),
    );
  }
}
