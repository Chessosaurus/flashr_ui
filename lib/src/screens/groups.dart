import 'package:flasher_ui/src/screens/profile.dart';
import 'package:flasher_ui/src/widgets/friend_list_tile.dart';
import 'package:flasher_ui/src/widgets/header.dart';
import 'package:flasher_ui/src/widgets/header_friends.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flasher_ui/src/widgets/friend_list_tile.dart';

import '../widgets/category_section.dart';
import '../widgets/friend_navbar.dart';
import '../widgets/navbar.dart';
import '../widgets/friend_list_tile.dart';
import 'home.dart';
import 'movie_swipe.dart';

class Groups extends StatefulWidget {
  const Groups({super.key});

  @override
  State<Groups> createState() => _Groups();
}

class _Groups extends State<Groups> {
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

  int _selectedIndexFriends = 1;
  void _onItemTappedFriends(int index){
    setState(() {
      _selectedIndexFriends = index; // Aktualisiere den Index der ausgewählten Seite
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(


      body: const SingleChildScrollView(
        child: Padding(
            padding: EdgeInsets.all(20.0),
            child: Column(
              children: <Widget> [
                Text(
                  'Deine Gruppen',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                SizedBox(height: 20),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Suche nach Gruppen',
                    prefixIcon: Icon(Icons.search),
                  ),
                ),
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
            )
        ),
      ),

      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: FriendNavbar(
              selectedIndex: _selectedIndexFriends,
              onItemTapped: _onItemTappedFriends,
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
