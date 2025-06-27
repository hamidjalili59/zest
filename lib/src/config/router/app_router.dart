import 'package:flutter/material.dart' show BuildContext, Container;
import 'package:go_router/go_router.dart';
import 'package:zest/src/features/auth/presentation/pages/auth_page.dart';
import 'package:zest/src/core/constants/router_paths.dart';

import 'package:zest/main.dart' show loggedIn;

final router = GoRouter(
  redirect: _redirectRouter,
  initialLocation: RouterPaths.home,
  routes: [
    GoRoute(path: RouterPaths.home, builder: (context, state) => Container()),
    GoRoute(path: RouterPaths.auth, builder: (context, state) => AuthPage()),
  ],
);

Future<String?> _redirectRouter(
  BuildContext context,
  GoRouterState state,
) async {
  if (!loggedIn) {
    return RouterPaths.auth;
  }
  return null;
}
