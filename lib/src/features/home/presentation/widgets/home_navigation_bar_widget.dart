import 'package:flutter/material.dart';
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
    return NavigationBar(
      labelPadding: EdgeInsets.zero,
      height: HomeConstants.kNavigationBarSize,
      backgroundColor: HomeConstants.kNavigationBarBackGroundColor,
      elevation: 5,
      shadowColor: Colors.black,
      selectedIndex: selectedItem,
      destinations: [
        _NavigationItemWidget(
          icon: Icons.window_outlined,
          isSelected: selectedItem == 0,
          onTap: () {
            selectedItem = 0;
            setState(() {});
          },
        ),
        _NavigationItemWidget(
          icon: Icons.home_outlined,
          isSelected: selectedItem == 1,
          onTap: () {
            selectedItem = 1;
            setState(() {});
          },
        ),
        _NavigationItemWidget(
          icon: Icons.person_outline_rounded,
          isSelected: selectedItem == 2,
          onTap: () {
            selectedItem = 2;
            setState(() {});
          },
        ),
      ],
    );
  }
}

class _NavigationItemWidget extends StatelessWidget {
  const _NavigationItemWidget({
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  final IconData icon;
  final bool isSelected;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: CircleAvatar(
        backgroundColor: isSelected
            ? HomeConstants.kNavigationBarItemColor
            : Colors.transparent,
        child: Icon(
          icon,
          size: isSelected
              ? HomeConstants.kNavigationBarItemSelectedSize
              : HomeConstants.kNavigationBarItemUnSelectedSize,
          color: isSelected
              ? HomeConstants.kNavigationBarItemSelectedTextColor
              : HomeConstants.kNavigationBarItemUnSelectedTextColor,
        ),
      ),
    );
  }
}
