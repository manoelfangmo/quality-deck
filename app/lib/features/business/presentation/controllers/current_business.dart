import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:app/features/auth/presentation/controllers/current_user.dart';
import 'package:app/features/business/data/business_repository.dart';
import 'package:app/features/business/domain/business.dart';

part 'current_business.g.dart';

@Riverpod(keepAlive: true)
Future<Business?> currentBusiness(Ref ref) async {
  final user = await ref.watch(currentUserProvider.future);
  if (user == null || !user.hasBusiness) return null;
  return ref.watch(businessRepositoryProvider).fetchBusiness();
}
