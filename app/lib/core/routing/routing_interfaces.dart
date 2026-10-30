import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

abstract class SimpleAppRoute {
  const SimpleAppRoute();

  String get path;

  Widget builder(BuildContext context, GoRouterState state);
}

abstract class ParamAppRoute {
  const ParamAppRoute();

  String get path;

  Widget builder(BuildContext context, GoRouterState state);
}
