import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:app/core/domain/app_exception.dart';
import 'package:app/features/auth/presentation/controllers/auth_controller.dart';
import 'package:app/features/auth/presentation/controllers/current_user.dart';
import 'package:app/features/auth/presentation/widgets/account_menu.dart';
import 'package:app/features/business/data/business_repository.dart';
import 'package:app/features/business/presentation/controllers/current_business.dart';
import 'package:app/features/business/presentation/validators/business_validators.dart';
import 'package:app/features/business/presentation/widgets/invites_section.dart';
import 'package:app/features/business/presentation/widgets/members_section.dart';

class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({super.key});

  @override
  ConsumerState<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
  final _nameController = TextEditingController();
  var _savingName = false;
  String? _nameError;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _saveName(String businessId) async {
    final error = BusinessValidators.businessName(_nameController.text);
    if (error != null) {
      setState(() => _nameError = error);
      return;
    }
    setState(() {
      _savingName = true;
      _nameError = null;
    });
    try {
      await ref
          .read(businessRepositoryProvider)
          .renameBusiness(businessId: businessId, name: _nameController.text);
      ref.invalidate(currentBusinessProvider);
    } on AppException catch (e) {
      setState(() => _nameError = e.message);
    } finally {
      if (mounted) setState(() => _savingName = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(currentUserProvider).value;
    final business = ref.watch(currentBusinessProvider).value;
    if (business != null && _nameController.text.isEmpty) {
      _nameController.text = business.name;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        actions: const [AccountMenu()],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            Text('Business', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            if (user?.isOwner == true) ...[
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Business name',
                  errorText: _nameError,
                ),
                enabled: !_savingName,
              ),
              const SizedBox(height: 12),
              FilledButton(
                onPressed: _savingName || business == null
                    ? null
                    : () => _saveName(business.id),
                child: _savingName
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Save name'),
              ),
            ] else
              Text(business?.name ?? ''),
            const SizedBox(height: 32),
            const MembersSection(),
            const SizedBox(height: 32),
            const InvitesSection(),
            const SizedBox(height: 32),
            OutlinedButton(
              onPressed: () =>
                  ref.read(authControllerProvider.notifier).signOut(),
              child: const Text('Sign out'),
            ),
          ],
        ),
      ),
    );
  }
}
