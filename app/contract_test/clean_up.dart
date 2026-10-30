import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:app/core/database/appointments_table.dart';
import 'package:app/core/database/businesses_table.dart';
import 'package:app/core/database/clients_table.dart';
import 'package:app/core/database/invites_table.dart';
import 'package:app/core/database/price_items_table.dart';
import 'package:app/core/database/pricing_settings_table.dart';
import 'package:app/core/database/projects_table.dart';

import 'helpers.dart';
import 'test_env.dart';

/// Service-role teardown for rows and auth users this file created, plus
/// snapshot/restore for the shared Quality Deck seed rows a file mutates.
///
/// Never pass [_admin] into a repository under test.
class ContractCleanup {
  ContractCleanup()
    : _admin = SupabaseClient(TestEnv.supabaseUrl, TestEnv.serviceRoleKey);

  final SupabaseClient _admin;
  final List<String> _users = [];
  final List<String> _businesses = [];
  final List<String> _clients = [];
  final List<String> _appointments = [];
  final List<String> _priceItems = [];
  final List<String> _projects = [];
  final List<String> _invites = [];
  final List<SupabaseClient> _sessions = [];
  final List<({String bucket, String path})> _storageObjects = [];

  Map<String, dynamic>? _pricing;
  String? _businessName;

  void trackUser(String userId) => _users.add(userId);

  void trackBusiness(String businessId) => _businesses.add(businessId);

  void trackClient(String clientId) => _clients.add(clientId);

  void trackAppointment(String appointmentId) =>
      _appointments.add(appointmentId);

  void trackPriceItem(String priceItemId) => _priceItems.add(priceItemId);

  void trackProject(String projectId) => _projects.add(projectId);

  void trackInvite(String inviteId) => _invites.add(inviteId);

  void trackSession(SupabaseClient client) => _sessions.add(client);

  void trackStorageObject({required String bucket, required String path}) {
    _storageObjects.add((bucket: bucket, path: path));
  }

  void trackSignedUp(SignedInSession session) {
    trackUser(session.userId);
    trackSession(session.client);
  }

  Future<void> snapshotQualityDeckPricing() async {
    _pricing = await _admin
        .from(PricingSettingsTable.name)
        .select()
        .eq(PricingSettingsTable.businessId, SeedUsers.qualityDeckId)
        .single();
  }

  Future<void> snapshotQualityDeckName() async {
    final row = await _admin
        .from(BusinessesTable.name)
        .select(BusinessesTable.businessName)
        .eq(BusinessesTable.id, SeedUsers.qualityDeckId)
        .single();
    _businessName = row[BusinessesTable.businessName] as String;
  }

  Future<void> teardown() async {
    for (final client in _sessions) {
      await _try('sign-out session', client.auth.signOut);
      await _try('dispose session', client.dispose);
    }
    _sessions.clear();

    for (final id in List<String>.from(_appointments)) {
      await _try('delete appointment $id', () {
        return _admin
            .from(AppointmentsTable.name)
            .delete()
            .eq(AppointmentsTable.id, id);
      });
    }
    _appointments.clear();

    for (final id in List<String>.from(_projects)) {
      await _try('delete project $id', () {
        return _admin
            .from(ProjectsTable.name)
            .delete()
            .eq(ProjectsTable.id, id);
      });
    }
    _projects.clear();

    for (final id in List<String>.from(_clients)) {
      await _try('delete appointments for client $id', () {
        return _admin
            .from(AppointmentsTable.name)
            .delete()
            .eq(AppointmentsTable.clientId, id);
      });
      await _try('delete projects for client $id', () {
        return _admin
            .from(ProjectsTable.name)
            .delete()
            .eq(ProjectsTable.clientId, id);
      });
      await _try('delete client $id', () {
        return _admin.from(ClientsTable.name).delete().eq(ClientsTable.id, id);
      });
    }
    _clients.clear();

    for (final id in List<String>.from(_priceItems)) {
      await _try('delete price item $id', () {
        return _admin
            .from(PriceItemsTable.name)
            .delete()
            .eq(PriceItemsTable.id, id);
      });
    }
    _priceItems.clear();

    for (final id in List<String>.from(_invites)) {
      await _try('delete invite $id', () {
        return _admin.from(InvitesTable.name).delete().eq(InvitesTable.id, id);
      });
    }
    _invites.clear();

    for (final id in List<String>.from(_businesses)) {
      await _try('delete business $id', () {
        return _admin
            .from(BusinessesTable.name)
            .delete()
            .eq(BusinessesTable.id, id);
      });
    }
    _businesses.clear();

    for (final id in List<String>.from(_users)) {
      await _try('clear invite used_by $id', () {
        return _admin
            .from(InvitesTable.name)
            .update({InvitesTable.usedBy: null, InvitesTable.usedAt: null})
            .eq(InvitesTable.usedBy, id);
      });
      await _try('delete user $id', () => _admin.auth.admin.deleteUser(id));
    }
    _users.clear();

    for (final object in List<({String bucket, String path})>.from(
      _storageObjects,
    )) {
      await _try('delete storage ${object.bucket}/${object.path}', () async {
        await _admin.storage.from(object.bucket).remove([object.path]);
      });
    }
    _storageObjects.clear();

    await _restorePricingSettings();
    await _restoreBusinessName();
  }

  Future<void> dispose() async {
    await _try('dispose admin', _admin.dispose);
  }

  Future<void> _restorePricingSettings() async {
    final row = _pricing;
    if (row == null) return;
    await _try('restore pricing settings', () {
      return _admin
          .from(PricingSettingsTable.name)
          .update({
            PricingSettingsTable.laborRateCents:
                row[PricingSettingsTable.laborRateCents],
            PricingSettingsTable.overheadBps:
                row[PricingSettingsTable.overheadBps],
          })
          .eq(PricingSettingsTable.businessId, SeedUsers.qualityDeckId);
    });
  }

  Future<void> _restoreBusinessName() async {
    final name = _businessName;
    if (name == null) return;
    await _try('restore business name', () {
      return _admin
          .from(BusinessesTable.name)
          .update({BusinessesTable.businessName: name})
          .eq(BusinessesTable.id, SeedUsers.qualityDeckId);
    });
  }

  Future<void> _try(String label, Future<void> Function() action) async {
    try {
      await action();
    } catch (e) {
      debugPrint('cleanup: failed to $label: $e');
    }
  }
}
