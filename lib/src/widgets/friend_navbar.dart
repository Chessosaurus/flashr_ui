import 'package:flutter/material.dart';

class FriendNavbar extends StatefulWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  FriendNavbar({required this.selectedIndex, required this.onItemTapped});

  @override
  _FriendNavbarState createState() => _FriendNavbarState();
}

class _FriendNavbarState extends State<FriendNavbar> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              Navigator.of(context).pushReplacementNamed('/friends');
              widget.onItemTapped(0);
            },
            style: ElevatedButton.styleFrom(
              fixedSize: Size.fromHeight(40),
              backgroundColor: widget.selectedIndex == 0 ? Theme.of(context).colorScheme.primary : Colors.black,
              foregroundColor: widget.selectedIndex == 0 ? Colors.white : Theme.of(context).colorScheme.primary,
            ),
            child: Text('Freunde'),
          ),
        ),
        SizedBox(width: 8),
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              Navigator.of(context).pushReplacementNamed('/groups');
              widget.onItemTapped(1);
            },
            style: ElevatedButton.styleFrom(
              fixedSize: Size.fromHeight(40),
              backgroundColor: widget.selectedIndex == 1 ? Theme.of(context).colorScheme.primary : Colors.black,
              foregroundColor: widget.selectedIndex == 1 ? Colors.white : Theme.of(context).colorScheme.primary,
            ),
            child: Text('Gruppen'),
          ),
        ),
        SizedBox(width: 8),
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              Navigator.of(context).pushReplacementNamed('/requests');
              widget.onItemTapped(2);
            },
            style: ElevatedButton.styleFrom(
              fixedSize: Size.fromHeight(40),
              backgroundColor: widget.selectedIndex == 2 ? Theme.of(context).colorScheme.primary : Colors.black,
              foregroundColor: widget.selectedIndex == 2 ? Colors.white : Theme.of(context).colorScheme.primary,
            ),
            child: Text('Anfragen'),
          ),
        ),
        SizedBox(width: 8),
      ],
    );
  }
}
