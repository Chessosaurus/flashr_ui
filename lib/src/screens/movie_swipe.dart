import 'package:flasher_ui/src/screens/profile.dart';
import 'package:flasher_ui/src/widgets/header.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../widgets/category_section.dart';
import '../widgets/navbar.dart';
import 'friends.dart';
import 'home.dart';

class MovieSwipe extends StatefulWidget {
  const MovieSwipe({super.key});

  @override
  State<MovieSwipe> createState() => _MovieSwipe();
}

class _MovieSwipe extends State<MovieSwipe> {
  int _selectedIndex = 1;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
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
      body: const SingleChildScrollView(
      ),
      bottomNavigationBar: NavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
