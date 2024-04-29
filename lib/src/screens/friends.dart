import 'package:flasher_ui/src/screens/profile.dart';
import 'package:flasher_ui/src/widgets/header.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../widgets/category_section.dart';
import '../widgets/navbar.dart';
import 'home.dart';
import 'movie_swipe.dart';

class Friends extends StatefulWidget {
  const Friends({super.key});

  @override
  State<Friends> createState() => _Friends();
}

class _Friends extends State<Friends> {
  final _future = Supabase.instance.client.schema('persistence')
      .from('User').select();
  int _selectedIndex = 2;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    // Hier füge deine Navigationslogik hinzu, basierend auf dem ausgewählten Index
    switch (index) {
      case 0:
      // Navigation zur Startseite
        //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()));
        break;
      case 1:
      // Navigation zu den Favoriten
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MovieSwipe()));
        break;
      case 2:
      // Navigation zum Profil
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Friends()));
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
