import 'package:flutter/material.dart';

class NavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const NavBar({
    Key? key,
    required this.selectedIndex,
    required this.onItemTapped,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double iconSize = MediaQuery.of(context).size.width > 600 ? 40 : 40;

    return BottomNavigationBar(
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home, size: iconSize),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: ImageIcon(AssetImage('assets/icons/swipe_icon.png'), size: iconSize),
          label: 'Swipe',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.group, size: iconSize),
          label: 'Freunde',
        ),
      ],
      currentIndex: selectedIndex,
      selectedItemColor: Theme.of(context).colorScheme.primary,
      onTap: onItemTapped,
      showUnselectedLabels: false,
      showSelectedLabels: false,
      backgroundColor: Colors.black,
    );
  }
}
