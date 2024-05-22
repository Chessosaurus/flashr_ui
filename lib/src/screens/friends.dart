import 'package:flasher_ui/src/screens/groups.dart';  // Importiere die Groups-Seite
import 'package:flasher_ui/src/screens/profile.dart';
import 'package:flasher_ui/src/widgets/friend_list_tile.dart';
import 'package:flasher_ui/src/widgets/header.dart';
import 'package:flasher_ui/src/widgets/header_friends.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flasher_ui/src/widgets/friend_list_tile.dart';

import '../widgets/category_section.dart';
import '../widgets/navbar.dart';
import '../widgets/friend_list_tile.dart';
import 'home.dart';
import 'movie_swipe.dart';

class Friends extends StatefulWidget {
  const Friends({super.key});

  @override
  State<Friends> createState() => _Friends();
}

class _Friends extends State<Friends> {
  int _selectedIndex = 2;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    // Hier füge deine Navigationslogik hinzu, basierend auf dem ausgewählten Index
    switch (index) {
      case 0:
      // Navigation zur Startseite
        Navigator.of(context).pushReplacementNamed('/homepage');
        break;
      case 1:
      // Navigation zu den Favoriten
        Navigator.of(context).pushReplacementNamed('/movieswipe');
        break;
      case 2:
      // Navigation zum Profil
        Navigator.of(context).pushReplacementNamed('/friends');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            children: [
              Text(
                'Deine Freunde',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              HeaderFriends(),
              SizedBox(height: 20),
              FriendListTile(
                name: 'Tobias Hahn',
              ),
              FriendListTile(
                name: 'Shaken Earth',
              ),
              FriendListTile(
                name: 'Janosch Selbmann',
              ),
              FriendListTile(
                name: 'Timo Zink',
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // Aktion beim Klick auf "Freunde"

                    },
                    style: ElevatedButton.styleFrom(
                      fixedSize: Size.fromHeight(40),
                    ),
                    child: Text('Freunde'),
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacementNamed('/groups'); // Navigiere zur Groups-Seite
                    },
                    style: ElevatedButton.styleFrom(
                      fixedSize: Size.fromHeight(40),

                    ),
                    child: Text('Gruppen'),
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // Aktion beim Klick auf "Anfragen"
                      Navigator.of(context).pushReplacementNamed('/requests'); // Navigiere zur Groups-Seite

                    },
                    style: ElevatedButton.styleFrom(
                      fixedSize: Size.fromHeight(40),
                    ),
                    child: Text('Anfragen'),
                  ),
                ),
                SizedBox(width: 8),
                // Platz für Profil-Icon
              ],
            ),
          ),
          NavBar(
            selectedIndex: _selectedIndex,
            onItemTapped: _onItemTapped,
          ),
        ],
      ),
    );
  }

  void _navigateToProfile(BuildContext context) {
    Navigator.of(context).pushReplacementNamed('/profile');
  }
}

