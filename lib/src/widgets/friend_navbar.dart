import 'package:flutter/material.dart';

class FriendNavbar extends StatefulWidget {
  final int selectedIndex; // Index der ausgewählten Seite
  final Function(int) onItemTapped; // Funktion zum Behandeln des Klicks auf einen Button

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
              widget.onItemTapped(0); // Behandele den Klick und aktualisiere den Index
            },
            style: ElevatedButton.styleFrom(
              fixedSize: Size.fromHeight(40),
              // Manually set the background color based on the selected state
              backgroundColor: widget.selectedIndex == 0 ? Theme.of(context).colorScheme.primary : Colors.black,
              foregroundColor: widget.selectedIndex == 0 ? Colors.white : Theme.of(context).colorScheme.primary, // Textfarbe des Buttons
            ),
            child: Text('Freunde'),
          ),
        ),
        SizedBox(width: 8),
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              Navigator.of(context).pushReplacementNamed('/groups');
              widget.onItemTapped(1); // Behandele den Klick und aktualisiere den Index
            },
            style: ElevatedButton.styleFrom(
              fixedSize: Size.fromHeight(40),
              // Manually set the background color based on the selected state
              backgroundColor: widget.selectedIndex == 1 ? Theme.of(context).colorScheme.primary : Colors.black,
              foregroundColor: widget.selectedIndex == 1 ? Colors.white : Theme.of(context).colorScheme.primary, // Textfarbe des Buttons
            ),
            child: Text('Gruppen'),
          ),
        ),
        SizedBox(width: 8),
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              Navigator.of(context).pushReplacementNamed('/requests');
              widget.onItemTapped(2); // Behandele den Klick und aktualisiere den Index
            },
            style: ElevatedButton.styleFrom(
              fixedSize: Size.fromHeight(40),
              // Manually set the background color based on the selected state
              backgroundColor: widget.selectedIndex == 2 ? Theme.of(context).colorScheme.primary : Colors.black,
              foregroundColor: widget.selectedIndex == 2 ? Colors.white : Theme.of(context).colorScheme.primary, // Textfarbe des Buttons
            ),
            child: Text('Anfragen'),
          ),
        ),
        SizedBox(width: 8),
        // Platz für Profil-Icon
      ],
    );
  }
}
