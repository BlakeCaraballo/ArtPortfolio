// ignore_for_file: use_build_context_synchronously

import 'package:art_portfolio/route_names.dart';
import 'package:flutter/material.dart';

class AppBottomNavigation extends StatelessWidget {
  final int selectedIndex;

  const AppBottomNavigation({
    Key? key,
    required this.selectedIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.photo),
          label: 'Artworks',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.group),
          label: 'Artists',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: 'Settings',
        ),
      ],
      currentIndex: selectedIndex,
      showUnselectedLabels: true,
      unselectedItemColor: Colors.black87,
      selectedItemColor: Theme.of(context).primaryColor,
      onTap: (value) {
        switch (value) {
          case 0:
            Navigator.pushNamed(context, AppRouteNames.home);
            break;
          case 1:
            Navigator.pushNamed(context, AppRouteNames.artworks);
            break;
          case 2:
            Navigator.pushNamed(context, AppRouteNames.artists);
            break;
          case 3:
            Navigator.pushNamed(context, AppRouteNames.settings);
            break;
          default:
        }
      },
    );
  }
}
