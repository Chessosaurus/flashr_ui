import 'package:flasher_ui/src/screens/groups.dart';  // Importiere die Groups-Seite
import 'package:flasher_ui/src/screens/profile.dart';
import 'package:flasher_ui/src/services/friends_service.dart';
import 'package:flasher_ui/src/widgets/friend_list_tile.dart';
import 'package:flasher_ui/src/widgets/friend_navbar.dart';
import 'package:flasher_ui/src/widgets/header.dart';
import 'package:flasher_ui/src/widgets/header_friends.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flasher_ui/src/widgets/friend_list_tile.dart';

import '../models/friend.dart';
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

  late Future<List<Friend>> friendList;

  @override
  void initState() {
    super.initState();
    friendList = FriendsService.getFriendsOfUser();
  }

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

  int _selectedIndexFriends = 0;
  void _onItemTappedFriends(int index){
    setState(() {
      _selectedIndexFriends = index; // Aktualisiere den Index der ausgewählten Seite
    });
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
              FutureBuilder<List<Friend>>(
                future: friendList,
                builder: (context, snapshot) {
                  if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    final friends = snapshot.data!;
                    return SizedBox(  // Wrap ListView.builder in SizedBox
                      height: MediaQuery.of(context).size.height * 0.5, // Example height
                      child: ListView.builder(
                        shrinkWrap: true,  // Add shrinkWrap
                        physics: const NeverScrollableScrollPhysics(), // Disable scrolling
                        itemCount: friends.length,
                        itemBuilder: (context, index) {
                          return FriendListTile(name: friends[index].friendName);
                        },
                      ),
                    );
                  }},
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

