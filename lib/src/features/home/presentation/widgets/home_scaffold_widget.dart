import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:zest/src/core/constants/app_theme.dart';
import 'package:zest/src/features/home/presentation/widgets/home_navigation_bar_widget.dart';

const _kBg = Color(0xFF0F1216);
// const _kGlassBorder = Color(0x22FFFFFF);
// const _kAccent1 = Color(0xFF22D3EE);
const _kAccent2 = Color(0xFF22C55E);

class HomeScaffold extends StatefulWidget {
  final Widget body;

  const HomeScaffold({super.key, required this.body});

  @override
  State<HomeScaffold> createState() => _HomeScaffoldState();
}

class _HomeScaffoldState extends State<HomeScaffold> {
  int _selectedIndex = 0;

  void _onTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
    // اینجا می‌تونی روتینگ بزنی یا بدی به body های مختلف
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = ResponsiveBreakpoints.of(context).largerThan(TABLET);

    return Scaffold(
      backgroundColor: _kBg,
      body: Row(
        children: [
          if (isDesktop)
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                child: NavigationRail(
                  backgroundColor: Colors.white.withAlpha(0.03.toAlpha()),
                  selectedIndex: _selectedIndex,
                  onDestinationSelected: _onTap,
                  selectedIconTheme: const IconThemeData(
                    color: _kAccent2,
                    size: 28,
                  ),
                  unselectedIconTheme: const IconThemeData(
                    color: Colors.white70,
                    size: 24,
                  ),
                  selectedLabelTextStyle: const TextStyle(
                    color: _kAccent2,
                    fontWeight: FontWeight.bold,
                  ),
                  unselectedLabelTextStyle: const TextStyle(
                    color: Colors.white54,
                  ),
                  labelType: NavigationRailLabelType.all,
                  destinations: const [
                    NavigationRailDestination(
                      icon: Icon(Icons.dashboard_outlined),
                      selectedIcon: Icon(Icons.dashboard),
                      label: Text("Dashboard"),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.restaurant_outlined),
                      selectedIcon: Icon(Icons.restaurant),
                      label: Text("Meals"),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.show_chart_outlined),
                      selectedIcon: Icon(Icons.show_chart),
                      label: Text("Progress"),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.person_outline),
                      selectedIcon: Icon(Icons.person),
                      label: Text("Profile"),
                    ),
                  ],
                ),
              ),
            ),
          // محتوای اصلی
          Expanded(child: widget.body),
        ],
      ),
      bottomNavigationBar: isDesktop ? null : const HomeBottomNavigationBar(),
    );
  }
}
