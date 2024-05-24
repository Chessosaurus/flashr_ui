import 'package:flasher_ui/src/screens/profile.dart';
import 'package:flasher_ui/src/widgets/friend_list_tile.dart';
import 'package:flasher_ui/src/widgets/header.dart';
import 'package:flasher_ui/src/widgets/header_friends.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flasher_ui/src/widgets/friend_list_tile.dart';

import '../models/friend.dart';
import '../services/friends_service.dart';
import '../widgets/category_section.dart';
import '../widgets/friend_navbar.dart';
import '../widgets/navbar.dart';
import '../widgets/friend_list_tile.dart';
import 'home.dart';
import 'movie_swipe.dart';

class Requests extends StatefulWidget {
  const Requests({super.key});

  @override
  State<Requests> createState() => _Requests();
}

class _Requests extends State<Requests> {

  late Future<List<Friend>> friendRequestsList;

  @override
  void initState() {
    super.initState();
    friendRequestsList = FriendsService.getFriendshipRequests();
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

  int _selectedIndexFriends = 2;
  void _onItemTappedFriends(int index){
    setState(() {
      _selectedIndexFriends = index; // Aktualisiere den Index der ausgewählten Seite
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /*
      appBar: AppBar(
        title: const Text('Streaming App UI'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // Suchfunktion
            },
          ),
          IconButton(
            icon: const Icon(Icons.account_circle),
            onPressed: () {
              // Nutzerprofil
            },
          )
        ],
      ),
      */

      body:  SingleChildScrollView(
        child: Padding(
            padding: EdgeInsets.all(20.0),
            child: Column(
              children:[
                Text(
                  'Deine Anfragen',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20),
                FutureBuilder<List<Friend>>(
                  future: friendRequestsList,
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
                            return FriendListTile(friend:friends[index]);
                          },
                        ),
                      );
                    }},
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
