import 'package:app/core/routing/app_routes.dart';
import 'package:app/core/routing/auth_snapshot.dart';

String? redirect(AuthSnapshot auth, Uri uri) {
  if (auth.isLoading) return null;

  final path = uri.path;
  final isPublic = AppRoutes.publicRoutes.contains(path);

  if (auth.user == null) {
    if (isPublic) return null;
    final from = Uri.encodeComponent(uri.path);
    return '${AppRoutes.signIn}?${AppRoutes.fromParam}=$from';
  }

  if (!auth.user!.hasBusiness) {
    if (path != AppRoutes.onboarding) return AppRoutes.onboarding;
    return null;
  }

  if (isPublic || path == AppRoutes.onboarding) {
    final from = uri.queryParameters[AppRoutes.fromParam];
    if (_isSafeFrom(from)) return from;
    return AppRoutes.projects;
  }

  return null;
}

bool _isSafeFrom(String? from) {
  if (from == null || from.isEmpty) return false;
  if (from.startsWith('//')) return false;
  final uri = Uri.tryParse(from);
  if (uri == null) return false;
  if (uri.hasScheme || uri.host.isNotEmpty) return false;
  if (!from.startsWith('/')) return false;
  if (AppRoutes.publicRoutes.contains(uri.path)) return false;
  if (uri.path == AppRoutes.onboarding) return false;
  return true;
}
