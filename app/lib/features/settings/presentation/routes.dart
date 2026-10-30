import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import 'package:app/core/routing/app_routes.dart';
import 'package:app/core/routing/routing_interfaces.dart';
import 'package:app/features/settings/presentation/settings_page.dart';

class SettingsRoute extends SimpleAppRoute {
  const SettingsRoute();

  @override
  String get path => AppRoutes.settings;

  @override
  Widget builder(BuildContext context, GoRouterState state) {
    return const SettingsPage();
  }
}
