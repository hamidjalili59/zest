import 'package:flutter/material.dart' show BuildContext;
import 'package:go_router/go_router.dart';
import 'package:zest/src/features/auth/presentation/pages/auth_page.dart';
import 'package:zest/src/core/constants/router_paths.dart';
import 'package:zest/src/features/home/presentation/pages/meal_suggestions_page.dart';

import 'package:zest/main.dart' show loggedIn;
import 'package:zest/src/features/home/presentation/pages/home_page.dart';

final router = GoRouter(
  redirect: _redirectRouter,
  initialLocation: RouterPaths.home,
  routes: [
    GoRoute(path: RouterPaths.home, builder: (context, state) => HomePage()),
    GoRoute(path: RouterPaths.auth, builder: (context, state) => AuthPage()),
    GoRoute(
      path: RouterPaths.mealSuggestions,
      builder: (context, state) => const MealSuggestionsPage(),
    ),
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
