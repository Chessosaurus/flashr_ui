import 'package:flasher_ui/src/screens/profile.dart';
import 'package:flasher_ui/src/widgets/header.dart';
import 'package:flasher_ui/src/providers/movieprovider.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/album.dart';
import '../models/movie.dart';

import '../widgets/category_section.dart';
import '../widgets/navbar.dart';
import 'friends.dart';
import 'movie_swipe.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.supabase});
  final SupabaseClient supabase;

  @override
  State<HomePage> createState() => _HomePageState();
}


class _HomePageState extends State<HomePage> {
  late Future<Movie?> futureAlbum;

  @override
  void initState() {
    super.initState();
    Movieprovider mv = new Movieprovider();
    futureAlbum = mv.fetchMovies();
  }

  void fetchData(){
    Movieprovider mv = new Movieprovider();
    //mv.fetchMovies();
    //futureAlbum = mv.fetchAlbum();
  }

  //Wird das gebraucht??? @Timo war bei Mergeconflict bei dir nicht mit drin
  final _future = Supabase.instance.client.schema('persistence')
      .from('User').select();
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    // Hier füge deine Navigationslogik hinzu, basierend auf dem ausgewählten Index
    switch (index) {
      case 0:
      // Navigation zur Startseite
        //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage(supabase: supabase,)));
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
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // Suchfunktion
            },
          ),
          IconButton(
            icon: const Icon(Icons.account_circle),
            onPressed: fetchData,
          )
        ],
      ),
      */
      body: const SingleChildScrollView(
        child: Column( // Hier wurde das Column-Widget hinzugefügt
          children: <Widget>[
            SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: Column(
                  children: <Widget>[
                    Header(),
                    // Suchleiste
                    TextField(
                      decoration: InputDecoration(
                        labelText: 'Suche nach Filmen, Serien, Genres etc.',
                        prefixIcon: Icon(Icons.search),
                      ),
                    ),
                    // Film Listenansichten
                    SizedBox(height: 20),

                    CategorySection(title: 'Deine Watchlist'),
                    SizedBox(height: 20),
                    CategorySection(title: 'Für dich Empfohlen'),
                    SizedBox(height: 20),
                    CategorySection(title: 'Von Freunden Empfohlen'),
                    SizedBox(height: 20),
                    CategorySection(title: 'Beliebte Filme'),
                    // Weitere Listen ...
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: NavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
