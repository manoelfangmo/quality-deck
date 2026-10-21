import 'package:app/core/domain/address.dart';
import 'package:app/core/domain/app_user.dart';
import 'package:app/core/domain/membership.dart';
import 'package:app/core/domain/user_role.dart';
import 'package:app/features/auth/presentation/controllers/current_user.dart';
import 'package:app/features/business/domain/invite.dart';
import 'package:app/features/business/domain/invite_status.dart';
import 'package:app/features/business/domain/member.dart';
import 'package:app/features/business/domain/business.dart';
import 'package:app/core/domain/money.dart';
import 'package:app/core/domain/percent.dart';
import 'package:app/core/domain/pricing_type.dart';
import 'package:app/features/clients/domain/client.dart';
import 'package:app/features/pricing/domain/price_item.dart';
import 'package:app/features/pricing/domain/pricing_settings.dart';
import 'package:app/features/projects/data/models.dart';
import 'package:app/features/scheduling/domain/appointment.dart';
import 'package:app/features/scheduling/domain/appointment_draft.dart';

final joinedAt = DateTime.utc(2026, 10, 1);

final ownerUser = AppUser(
  id: 'owner-id',
  email: 'owner@qualitydeck.test',
  fullName: 'Moises (dev)',
  membership: Membership(
    businessId: 'qd-id',
    role: UserRole.owner,
    joinedAt: joinedAt,
  ),
);

final memberUser = AppUser(
  id: 'crew-id',
  email: 'crew@qualitydeck.test',
  fullName: 'Crew Member',
  membership: Membership(
    businessId: 'qd-id',
    role: UserRole.member,
    joinedAt: joinedAt,
  ),
);

final noBusinessUser = AppUser(
  id: 'none-id',
  email: 'nobusiness@example.test',
  fullName: 'No Business',
);

final ownerMember = Member(
  id: ownerUser.id,
  fullName: ownerUser.fullName,
  email: ownerUser.email,
  role: UserRole.owner,
  joinedAt: joinedAt,
);

final crewMember = Member(
  id: memberUser.id,
  fullName: memberUser.fullName,
  email: memberUser.email,
  role: UserRole.member,
  joinedAt: joinedAt,
);

final activeInvite = Invite(
  id: 'invite-active',
  code: 'ABCD2345',
  status: InviteStatus.active,
  createdAt: DateTime.utc(2026, 10, 20),
  expiresAt: DateTime.utc(2026, 10, 27),
);

final usedInvite = Invite(
  id: 'invite-used',
  code: 'USED2267',
  status: InviteStatus.used,
  createdAt: DateTime.utc(2026, 10, 18),
  expiresAt: DateTime.utc(2026, 10, 25),
  usedByName: 'Crew Member',
);

final anaMelgar = Client(
  id: 'client-ana',
  fullName: 'Ana Melgar',
  email: 'ana.melgar@example.test',
  phone: '+13015550123',
  address: const Address(
    street: '12 Oak St',
    city: 'Bowie',
    state: 'MD',
    zip: '20715',
  ),
  lastActivityAt: DateTime.utc(2026, 10, 20, 18),
  createdAt: DateTime.utc(2026, 10, 1),
);

final qualityDeck = Business(
  id: 'qd-id',
  name: 'Quality Deck',
  ownerId: ownerUser.id,
  timezone: 'America/New_York',
  defaultOnsiteMinutes: 60,
);

final jamesWhitaker = Client(
  id: 'client-james',
  fullName: 'James Whitaker',
  phone: '+13015550102',
  lastActivityAt: DateTime.utc(2026, 10, 20, 17),
  createdAt: DateTime.utc(2026, 10, 2),
);

final anaUpcomingAppointment = Appointment(
  id: 'appt-ana',
  clientId: anaMelgar.id,
  startsAt: DateTime.utc(2026, 10, 23, 13),
  durationMinutes: 60,
  notes: 'Measure back deck\nBring samples',
);

final jamesPastAppointment = Appointment(
  id: 'appt-james',
  clientId: jamesWhitaker.id,
  startsAt: DateTime.utc(2026, 10, 3, 14),
  durationMinutes: 90,
);

final tomorrowNineDraft = AppointmentDraft(
  date: DateTime(2026, 10, 21),
  startHour: 9,
  startMinute: 0,
  durationMinutes: 60,
  notes: 'Measure back deck',
);

final qualityDeckSettings = PricingSettings(
  laborRate: const Money(6500),
  overhead: const Percent(1250),
  updatedAt: DateTime.utc(2026, 10, 20),
  updatedByName: 'Moises (dev)',
);

final unsetSettings = PricingSettings(
  updatedAt: DateTime.utc(2026, 10, 1),
);

final aluminumRailing = PriceItem(
  id: 'item-railing',
  name: 'Aluminum railing',
  description: 'Powder-coated, includes brackets',
  pricingType: PricingType.perLinearFt,
  price: const Money(3800),
  updatedAt: DateTime.utc(2026, 10, 20),
);

final compositeDecking = PriceItem(
  id: 'item-decking',
  name: 'Composite decking',
  description: 'Trex Enhance, includes hidden fasteners',
  pricingType: PricingType.perSqFt,
  price: const Money(450),
  updatedAt: DateTime.utc(2026, 10, 18),
);

final permitFiling = PriceItem(
  id: 'item-permit',
  name: 'Permit filing',
  pricingType: PricingType.fixed,
  price: const Money(35000),
  updatedAt: DateTime.utc(2026, 10, 15),
);

final melgarOak = ProjectRow(
  id: 'project-melgar',
  title: 'Melgar – 12 Oak St',
  createdAt: DateTime.utc(2026, 10, 20),
  siteAddress: const Address(
    street: '12 Oak St',
    city: 'Bowie',
    state: 'MD',
    zip: '20715',
  ),
  clientId: anaMelgar.id,
  clientName: anaMelgar.fullName,
  clientPhone: anaMelgar.phone,
  clientRemoved: false,
  appointmentStartsAt: DateTime.utc(2026, 10, 23, 13),
  appointmentDurationMinutes: 60,
);

final whitakerPast = ProjectRow(
  id: 'project-whitaker',
  title: 'Whitaker – 200 Pine St',
  createdAt: DateTime.utc(2026, 10, 18),
  siteAddress: const Address(
    street: '200 Pine St',
    city: 'Bowie',
    state: 'MD',
    zip: '20715',
  ),
  clientId: jamesWhitaker.id,
  clientName: jamesWhitaker.fullName,
  clientPhone: jamesWhitaker.phone,
  clientRemoved: false,
  appointmentStartsAt: DateTime.utc(2026, 10, 3, 14),
  appointmentDurationMinutes: 90,
);

final noAppointmentRow = ProjectRow(
  id: 'project-none',
  title: 'Shah – 5 Maple St',
  createdAt: DateTime.utc(2026, 10, 15),
  siteAddress: const Address(
    street: '5 Maple St',
    city: 'Laurel',
    state: 'MD',
    zip: '20707',
  ),
  clientId: 'client-priya',
  clientName: 'Priya Shah',
  clientRemoved: false,
);

final removedClientRow = ProjectRow(
  id: 'project-removed',
  title: 'One – 1 Retired Rd',
  createdAt: DateTime.utc(2026, 10, 10),
  siteAddress: const Address(
    street: '1 Retired Rd',
    city: 'Bowie',
    state: 'MD',
    zip: '20715',
  ),
  clientId: 'client-old',
  clientName: 'Old Client One',
  clientRemoved: true,
);

final archivedMelgar = ProjectRow(
  id: 'project-archived',
  title: 'Melgar – 99 Archive St',
  createdAt: DateTime.utc(2026, 10, 1),
  archivedAt: DateTime.utc(2026, 10, 18),
  siteAddress: const Address(
    street: '99 Archive St',
    city: 'Bowie',
    state: 'MD',
    zip: '20715',
  ),
  clientId: anaMelgar.id,
  clientName: anaMelgar.fullName,
  clientPhone: anaMelgar.phone,
  clientRemoved: false,
);

class FakeCurrentUser extends CurrentUser {
  FakeCurrentUser(this.user);

  final AppUser? user;

  @override
  Future<AppUser?> build() async => user;
}
