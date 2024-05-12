import 'package:flasher_ui/src/screens/profile.dart';
import 'package:flasher_ui/src/widgets/header.dart';
import 'package:flasher_ui/src/services/movie_service.dart';
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
  late Future<List<Movie>> trendingMovies;
  late Future<List<Movie>> movieRecommendations;
  late Future<List<Movie>> friendMovieRecommendations;
  late Future<List<Movie>> watchlist;

  @override
  void initState() {
    super.initState();
    trendingMovies =  MovieService.fetchMoviesTrending(true);
    //movieRecommendations = MovieService.fetchMovieRecommendation();
    //swipeMovieRecommendations = MovieService.fetchSwipeMovieRecommendation();
  }

  int _selectedIndex = 0;
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
      body: SingleChildScrollView(
        child: Column( // Hier wurde das Column-Widget hinzugefügt
          children: <Widget>[
            SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: Column(
                  children: [
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
                    FutureBuilder<List<Movie>>(
                      future: trendingMovies,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else {
                          return CategorySection(title: 'Deine Watchlist',
                              movies: snapshot.data!);
                        }
                      },
                    ),
                    SizedBox(height: 20),
                    CategorySection(title: 'Für dich Empfohlen', movies: []),
                    SizedBox(height: 20),
                    CategorySection(title: 'Von Freunden Empfohlen', movies: []),
                    SizedBox(height: 20),
                    FutureBuilder<List<Movie>>(
                      future: trendingMovies,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else {
                          return CategorySection(title: 'Beliebte Filme',
                              movies: snapshot.data!);
                        }
                      },
                    ),
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
