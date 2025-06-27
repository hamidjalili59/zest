import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

import 'config/router/app_router.dart' show router;

class Application extends StatelessWidget {
  const Application({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      builder:
          (context, child) => ResponsiveBreakpoints.builder(
            child: child ?? const SizedBox.shrink(),
            breakpoints: [
              const Breakpoint(start: 0, end: 450, name: MOBILE),
              const Breakpoint(start: 451, end: 800, name: TABLET),
              const Breakpoint(start: 801, end: 1920, name: DESKTOP),
              const Breakpoint(start: 1921, end: double.infinity, name: '4K'),
            ],
          ),
      routerConfig: router,
    );
  }
}
