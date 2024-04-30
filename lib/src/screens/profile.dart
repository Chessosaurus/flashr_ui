import 'package:flutter/material.dart';
import 'package:flasher_ui/src/screens/home.dart';
import '../widgets/category_section.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profil'),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            // Implementiere die Zurück-Funktion hier
            _navigateBack(context);
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              // Implementiere die Einstellungen-Funktion hier
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: ProfileView(),
        ),
      ),
    );
  }

  void _navigateBack(BuildContext context) {
    Navigator.of(context).pushReplacementNamed('/homepage');
  }
}

class ProfileView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 80,
            backgroundImage: AssetImage('assets/profile_pic.jpg'), // Profilbild hier einfügen
          ),
          SizedBox(height: 20),
          Text(
            'Vorname Nachname', // Benutzername hier einfügen
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          Text(
            '@benutzername', // Benutzername hier einfügen
            style: TextStyle(fontSize: 18),
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              MoviePoster(title: 'Lieblingsfilm 1'), // Lieblingsfilme hier einfügen
              MoviePoster(title: 'Lieblingsfilm 2'),
              MoviePoster(title: 'Lieblingsfilm 3'),
            ],
          ),
          SizedBox(height: 40),
          CategorySection(title: 'Watchlist'),
          SizedBox(height: 20),
          CategorySection(title: 'Zuletzt gesehen')
        ],
      ),
    );
  }
}

class MoviePoster extends StatelessWidget {
  final String title;

  MoviePoster({required this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 120,
          height: 180,
          color: Colors.grey, // Platzhalterfarbe für Filmplakat
        ),
      ],
    );
  }
}
