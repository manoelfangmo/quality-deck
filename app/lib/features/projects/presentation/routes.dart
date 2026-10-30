import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import 'package:app/core/routing/app_routes.dart';
import 'package:app/core/routing/routing_interfaces.dart';
import 'package:app/features/projects/presentation/project_page.dart';

class ProjectRoute extends ParamAppRoute {
  const ProjectRoute([this.projectId = '']);

  final String projectId;

  @override
  String get path => '${AppRoutes.projects}/:${AppRoutes.projectIdParam}';

  String get location => AppRoutes.project(projectId);

  @override
  Widget builder(BuildContext context, GoRouterState state) {
    final id = state.pathParameters[AppRoutes.projectIdParam] ?? projectId;
    return ProjectPage(projectId: id);
  }
}
