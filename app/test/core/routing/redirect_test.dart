import 'package:flutter_test/flutter_test.dart';

import 'package:app/core/routing/app_routes.dart';
import 'package:app/core/routing/auth_snapshot.dart';
import 'package:app/core/routing/redirect.dart';

import '../../helpers/fixtures.dart';

void main() {
  test('loading returns null', () {
    expect(redirect(const AuthSnapshot.loading(), Uri.parse('/projects')), isNull);
  });

  test('signed-out visitor on a public path stays', () {
    expect(
      redirect(const AuthSnapshot.signedOut(), Uri.parse(AppRoutes.signIn)),
      isNull,
    );
    expect(
      redirect(const AuthSnapshot.signedOut(), Uri.parse(AppRoutes.signUp)),
      isNull,
    );
    expect(
      redirect(const AuthSnapshot.signedOut(), Uri.parse(AppRoutes.checkEmail)),
      isNull,
    );
  });

  test('signed-out visitor on a private path goes to sign-in with from', () {
    expect(
      redirect(const AuthSnapshot.signedOut(), Uri.parse(AppRoutes.pricing)),
      '${AppRoutes.signIn}?${AppRoutes.fromParam}=${Uri.encodeComponent(AppRoutes.pricing)}',
    );
  });

  test('no-business user on /projects goes to onboarding', () {
    expect(
      redirect(
        AuthSnapshot.signedIn(noBusinessUser),
        Uri.parse(AppRoutes.projects),
      ),
      AppRoutes.onboarding,
    );
  });

  test('no-business user on onboarding stays', () {
    expect(
      redirect(
        AuthSnapshot.signedIn(noBusinessUser),
        Uri.parse(AppRoutes.onboarding),
      ),
      isNull,
    );
  });

  test('business user on onboarding goes to projects', () {
    expect(
      redirect(
        AuthSnapshot.signedIn(ownerUser),
        Uri.parse(AppRoutes.onboarding),
      ),
      AppRoutes.projects,
    );
  });

  test('business user on sign-in with safe from returns from', () {
    expect(
      redirect(
        AuthSnapshot.signedIn(ownerUser),
        Uri.parse(
          '${AppRoutes.signIn}?${AppRoutes.fromParam}=${Uri.encodeComponent(AppRoutes.pricing)}',
        ),
      ),
      AppRoutes.pricing,
    );
  });

  test('unsafe from is ignored', () {
    expect(
      redirect(
        AuthSnapshot.signedIn(ownerUser),
        Uri.parse(
          '${AppRoutes.signIn}?${AppRoutes.fromParam}=https://evil.example',
        ),
      ),
      AppRoutes.projects,
    );
    expect(
      redirect(
        AuthSnapshot.signedIn(ownerUser),
        Uri.parse(
          '${AppRoutes.signIn}?${AppRoutes.fromParam}=${Uri.encodeComponent(AppRoutes.signUp)}',
        ),
      ),
      AppRoutes.projects,
    );
    expect(
      redirect(
        AuthSnapshot.signedIn(ownerUser),
        Uri.parse('${AppRoutes.signIn}?${AppRoutes.fromParam}=//evil.example'),
      ),
      AppRoutes.projects,
    );
  });

  test('business user on an app path stays', () {
    expect(
      redirect(
        AuthSnapshot.signedIn(ownerUser),
        Uri.parse(AppRoutes.projects),
      ),
      isNull,
    );
  });
}
