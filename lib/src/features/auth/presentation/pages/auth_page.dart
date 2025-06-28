import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zest/src/core/constants/router_paths.dart';

import 'package:zest/src/config/router/app_router.dart' show router;

import 'package:zest/main.dart' show loggedIn;

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: GestureDetector(
            onTap: () async {
              debugPrint('---- logging ----');
              final pref = await SharedPreferences.getInstance();
              await pref.setBool('loggedIn', true);
              loggedIn = true;
              router.replace(RouterPaths.home);
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: ColoredBox(
                color: Colors.blue,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  child: Text(
                    'ورود به صفحه اصلی',
                    style: TextTheme.of(context).titleSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
