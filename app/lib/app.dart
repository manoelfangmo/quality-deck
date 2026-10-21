import 'package:app/core/theme/theme.dart';
import 'package:app/core/theme/util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:app/core/routing/go_router.dart';
import 'package:app/core/widgets/splash_page.dart';
import 'package:app/features/auth/presentation/controllers/current_user.dart';

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(goRouterProvider);
    TextTheme textTheme = createTextTheme(context, "Inter", "Barlow");
    MaterialTheme theme = MaterialTheme(textTheme);

    return MaterialApp.router(
      title: 'Field Notes',
      theme: theme.dark(),
      routerConfig: router,
      debugShowCheckedModeBanner: false,
      builder: (context, child) {
        final user = ref.watch(currentUserProvider);
        if (user.isLoading && !user.hasValue) {
          return const SplashPage();
        }
        return child ?? const SizedBox.shrink();
      },
    );
  }
}
