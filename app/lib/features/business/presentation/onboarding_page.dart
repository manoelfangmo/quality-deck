import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:app/core/widgets/loading_button.dart';
import 'package:app/features/auth/presentation/controllers/auth_controller.dart';
import 'package:app/features/business/presentation/controllers/onboarding_controller.dart';
import 'package:app/features/business/presentation/validators/business_validators.dart';

class OnboardingPage extends ConsumerStatefulWidget {
  const OnboardingPage({super.key});

  @override
  ConsumerState<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends ConsumerState<OnboardingPage> {
  final _formKey = GlobalKey<FormState>();
  final _codeController = TextEditingController();
  final _nameController = TextEditingController();

  @override
  void dispose() {
    _codeController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final form = ref.read(onboardingControllerProvider);
    if (!form.hasCode) {
      if (!(_formKey.currentState?.validate() ?? false)) return;
    }
    await ref.read(onboardingControllerProvider.notifier).submit();
  }

  @override
  Widget build(BuildContext context) {
    final form = ref.watch(onboardingControllerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Welcome')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Join or create a business',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 24),
                TextFormField(
                  controller: _codeController,
                  textInputAction: TextInputAction.next,
                  textCapitalization: TextCapitalization.characters,
                  inputFormatters: [
                    TextInputFormatter.withFunction((oldValue, newValue) {
                      return newValue.copyWith(
                        text: newValue.text.toUpperCase(),
                      );
                    }),
                  ],
                  decoration: const InputDecoration(
                    labelText: 'Invite code (optional)',
                  ),
                  onChanged: ref
                      .read(onboardingControllerProvider.notifier)
                      .setInviteCode,
                ),
                if (form.errorMessage != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    form.errorMessage!,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                ],
                if (!form.hasCode) ...[
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _nameController,
                    textInputAction: TextInputAction.done,
                    textCapitalization: TextCapitalization.words,
                    decoration: const InputDecoration(
                      labelText: 'Business name',
                    ),
                    validator: BusinessValidators.businessName,
                    onChanged: ref
                        .read(onboardingControllerProvider.notifier)
                        .setBusinessName,
                    onFieldSubmitted: (_) => _submit(),
                  ),
                ],
                const SizedBox(height: 24),
                LoadingButton(
                  label: form.hasCode ? 'Join business' : 'Create business',
                  isLoading: form.isSubmitting,
                  onPressed: _submit,
                ),
                const SizedBox(height: 24),
                TextButton(
                  onPressed: form.isSubmitting
                      ? null
                      : () => ref.read(authControllerProvider.notifier).signOut(),
                  child: const Text('Sign out'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
