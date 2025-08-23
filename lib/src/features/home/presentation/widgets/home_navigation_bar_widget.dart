import 'package:flutter/material.dart';
import 'package:zest/src/core/constants/app_theme.dart';
import 'package:zest/src/features/home/constants/home_constants.dart';

class HomeBottomNavigationBar extends StatefulWidget {
  const HomeBottomNavigationBar({super.key});
  @override
  State<HomeBottomNavigationBar> createState() =>
      _HomeBottomNavigationBarState();
}

class _HomeBottomNavigationBarState extends State<HomeBottomNavigationBar> {
  int selectedItem = 1;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
      child: BottomAppBar(
        color: Colors.white.withAlpha(0.03.toAlpha()),
        elevation: 10,
        child: SizedBox(
          height: HomeConstants.kNavigationBarSize,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NavItem(
                icon: Icons.calendar_today,
                index: 0,
                selected: selectedItem,
                onTap: (i) => setState(() => selectedItem = i),
              ),
              _NavItem(
                icon: Icons.home,
                index: 1,
                selected: selectedItem,
                onTap: (i) => setState(() => selectedItem = i),
              ),
              _NavItem(
                icon: Icons.person,
                index: 2,
                selected: selectedItem,
                onTap: (i) => setState(() => selectedItem = i),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final int index;
  final int selected;
  final ValueChanged<int> onTap;
  const _NavItem({
    required this.icon,
    required this.index,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = selected == index;
    return GestureDetector(
      onTap: () => onTap(index),
      child: Container(
        width: 62,
        height: 42,
        decoration: BoxDecoration(
          color: isSelected
              ? Colors.white.withAlpha(0.12.toAlpha())
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: isSelected ? Colors.white : Colors.white54),
      ),
    );
  }
}
