import 'package:mockito/annotations.dart';

import 'package:app/features/auth/data/auth_repository.dart';
import 'package:app/features/business/data/business_repository.dart';
import 'package:app/features/business/data/invites_repository.dart';
import 'package:app/features/clients/data/clients_repository.dart';
import 'package:app/features/pricing/data/price_items_repository.dart';
import 'package:app/features/pricing/data/pricing_repository.dart';
import 'package:app/features/scheduling/data/appointments_repository.dart';

@GenerateNiceMocks([
  MockSpec<AuthRepository>(),
  MockSpec<BusinessRepository>(),
  MockSpec<InvitesRepository>(),
  MockSpec<ClientsRepository>(),
  MockSpec<AppointmentsRepository>(),
  MockSpec<PricingRepository>(),
  MockSpec<PriceItemsRepository>(),
])
export 'mocks.mocks.dart';
