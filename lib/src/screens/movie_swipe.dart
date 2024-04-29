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
  final _future = Supabase.instance.client.schema('persistence')
      .from('User').select();
  int _selectedIndex = 1;

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
