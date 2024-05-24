import 'package:flasher_ui/src/screens/profile.dart';
import 'package:flasher_ui/src/widgets/friend_list_tile.dart';
import 'package:flasher_ui/src/widgets/header.dart';
import 'package:flasher_ui/src/widgets/header_friends.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flasher_ui/src/widgets/friend_list_tile.dart';

import '../models/group.dart';
import '../services/group_service.dart';
import '../widgets/category_section.dart';
import '../widgets/group_list_tile.dart';
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

  late Future<List<Group>> groupsOfUserList;

  @override
  void initState() {
    super.initState();
    groupsOfUserList = GroupService.getGroupsOfUsers();
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

  bool _showOverlay = false;
  final TextEditingController _groupNameController = TextEditingController();

  void _toggleOverlay() {
    setState(() {
      _showOverlay = !_showOverlay;
    });
  }

    Future<void> _createGroup() async {
      try {
        await GroupService.createGroup(_groupNameController.text);
        _toggleOverlay(); // Overlay schließen nach erfolgreicher Erstellung
        // Optional: Gruppenliste aktualisieren oder eine Bestätigung anzeigen
      } catch (e) {
        // Fehlerbehandlung (z. B. eine Fehlermeldung anzeigen)
        print('Fehler beim Erstellen der Gruppe: $e');
      }
    }


    @override
    Widget build(BuildContext context) {
      return Scaffold(
        body: Stack(
            children: [
              SingleChildScrollView(
                child: Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Column(
                      children: <Widget>[
                        Text(
                          'Deine Gruppen',
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 20),
                        IconButton(
                            onPressed: () {
                              _toggleOverlay();
                            },
                            icon: Icon(Icons.add)),
                        SizedBox(height: 20),
                        FutureBuilder<List<Group>>(
                          future: groupsOfUserList,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return CircularProgressIndicator();
                            } else if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            } else {
                              final groups = snapshot.data!;
                              return SizedBox(  // Wrap ListView.builder in SizedBox
                                height: MediaQuery.of(context).size.height * 0.5, // Example height
                                child: ListView.builder(
                                  shrinkWrap: true,  // Add shrinkWrap
                                  physics: const NeverScrollableScrollPhysics(), // Disable scrolling
                                  itemCount: groups.length,
                                  itemBuilder: (context, index) {
                                    return GroupListTile(name: groups[index].name, groupId: groups[index].id,);
                                  },
                                ),
                              );
                            }},
                        ),
                      ],
                    )
                ),
              ),
              if (_showOverlay) // Overlay nur anzeigen, wenn _showOverlay true ist
                Container(
                  color: Colors.black54, // Hintergrund abdunkeln
                  child: Center(
                    child: Container(
                      padding: EdgeInsets.all(20),
                      color: Colors.black,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextField(
                            controller: _groupNameController,
                            decoration: InputDecoration(
                                labelText: 'Gruppenname'),
                          ),
                          SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ElevatedButton(
                                onPressed: _createGroup,
                                child: Text('Erstellen'),
                              ),
                              ElevatedButton(
                                onPressed: _toggleOverlay, // Overlay schließen
                                child: Text('Abbrechen'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ]
        ),
        bottomNavigationBar: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        // Aktion beim Klick auf "Freunde"
                        Navigator.of(context).pushReplacementNamed(
                            '/friends'); // Navigiere zur Groups-Seite
                      },
                      style: ElevatedButton.styleFrom(
                        fixedSize: Size.fromHeight(40),
                      ),
                      child: const Text('Freunde'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        fixedSize: Size.fromHeight(40),

                      ),
                      child: const Text('Gruppen'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        // Aktion beim Klick auf "Anfragen"
                        Navigator.of(context).pushReplacementNamed(
                            '/requests'); // Navigiere zur Groups-Seite
                      },
                      style: ElevatedButton.styleFrom(
                        fixedSize: const Size.fromHeight(40),
                      ),
                      child: const Text('Anfragen'),
                    ),
                  ),
                  const SizedBox(width: 8),
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
  }
