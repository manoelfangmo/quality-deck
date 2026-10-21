import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:app/core/routing/app_routes.dart';
import 'package:app/core/routing/auth_snapshot.dart';
import 'package:app/core/routing/home_page.dart';
import 'package:app/core/routing/redirect.dart';
import 'package:app/features/auth/presentation/check_email_page.dart';
import 'package:app/features/auth/presentation/controllers/current_user.dart';
import 'package:app/features/auth/presentation/sign_in_page.dart';
import 'package:app/features/auth/presentation/sign_up_page.dart';
import 'package:app/features/business/presentation/onboarding_page.dart';
import 'package:app/features/clients/presentation/clients_page.dart';
import 'package:app/features/pricing/presentation/pricing_page.dart';
import 'package:app/features/projects/presentation/projects_page.dart';
import 'package:app/features/settings/presentation/routes.dart';

part 'go_router.g.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');

@Riverpod(keepAlive: true)
GoRouter goRouter(Ref ref) {
  final refresh = _RouterRefresh();
  ref.onDispose(refresh.dispose);
  ref.listen(currentUserProvider, (_, _) {
    refresh.notify();
  });

  return GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: AppRoutes.projects,
    refreshListenable: refresh,
    debugLogDiagnostics: kDebugMode,
    redirect: (context, state) {
      final snapshot = AuthSnapshot.fromAsync(ref.read(currentUserProvider));
      return redirect(snapshot, state.uri);
    },
    routes: [
      GoRoute(
        path: AppRoutes.signIn,
        builder: (context, state) => const SignInPage(),
      ),
      GoRoute(
        path: AppRoutes.signUp,
        builder: (context, state) => const SignUpPage(),
      ),
      GoRoute(
        path: AppRoutes.checkEmail,
        builder: (context, state) {
          return CheckEmailPage(
            email: state.uri.queryParameters[AppRoutes.emailParam],
          );
        },
      ),
      GoRoute(
        path: AppRoutes.onboarding,
        builder: (context, state) => const OnboardingPage(),
      ),
      GoRoute(
        path: const SettingsRoute().path,
        parentNavigatorKey: rootNavigatorKey,
        builder: const SettingsRoute().builder,
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return HomePage(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.projects,
                builder: (context, state) => const ProjectsPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.clients,
                builder: (context, state) => const ClientsPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.pricing,
                builder: (context, state) => const PricingPage(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}

class _RouterRefresh extends ChangeNotifier {
  void notify() => notifyListeners();
}
