abstract final class AppRoutes {
  static const signIn = '/sign-in';
  static const signUp = '/sign-up';
  static const checkEmail = '/check-email';
  static const onboarding = '/onboarding';
  static const projects = '/projects';
  static const clients = '/clients';
  static const pricing = '/pricing';
  static const settings = '/settings';

  static const fromParam = 'from';
  static const emailParam = 'email';
  static const projectIdParam = 'projectId';

  static String project(String projectId) => '$projects/$projectId';

  static const publicRoutes = [signIn, signUp, checkEmail];
}
