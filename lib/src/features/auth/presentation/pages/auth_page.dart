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
          child: SizedBox(
            width: 100,
            height: 50,
            child: GestureDetector(
              onTap: () async {
                debugPrint('---- logging ----');
                final pref = await SharedPreferences.getInstance();
                await pref.setBool('loggedIn', true);
                loggedIn = true;
                router.replace(RouterPaths.home);
              },
              child: Container(color: Colors.blue),
            ),
          ),
        ),
      ),
    );
  }
}
