import 'package:flasher_ui/src/screens/profile.dart';
import 'package:flasher_ui/src/widgets/header.dart';
import 'package:flasher_ui/src/services/movie_service.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/movie.dart';
import '../widgets/category_section.dart';
import '../widgets/navbar.dart';
import 'friends.dart';
import 'movie_swipe.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Movie>> trendingMovies;
  late Future<List<Movie>> watchlist;
  late Future<List<Movie>> recommendationMovies;

  @override
  void initState() {
    super.initState();
    trendingMovies = MovieService.fetchMoviesTrending(true);
    watchlist = MovieService.fetchMovieWatchlist();
    recommendationMovies = MovieService.fetchMovieRecommendation();

  }

  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    // Navigation logic based on the selected index
    switch (index) {
      case 0:
        Navigator.of(context).pushReplacementNamed('/homepage');
        break;
      case 1:
        Navigator.of(context).pushReplacementNamed('/movieswipe');
        break;
      case 2:
        Navigator.of(context).pushReplacementNamed('/friends');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get the size of the screen
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Header(),
                    // Search bar
                    TextField(
                      decoration: InputDecoration(
                        labelText: 'Suche nach Filmen, Serien, Genres etc.',
                        prefixIcon: Icon(Icons.search),
                      ),
                      onTap: () {
                        Navigator.pushNamed(context, '/search');
                      },
                    ),
                    // Movie list views
                    SizedBox(height: 20),
                    FutureBuilder<List<Movie>>(
                      future: watchlist,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else {
                          return CategorySection(
                            title: 'Deine Watchlist',
                            movies: snapshot.data!,
                          );
                        }
                      },
                    ),
                    SizedBox(height: 20),
                    FutureBuilder<List<Movie>>(
                      future: trendingMovies,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else {
                          return CategorySection(
                            title: 'Beliebte Filme',
                            movies: snapshot.data!,
                          );
                        }
                      },
                    ),
                    FutureBuilder<List<Movie>>(
                      future: recommendationMovies,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else {
                          return CategorySection(
                            title: 'Für dich Empfohlen',
                            movies: snapshot.data!,
                          );
                        }
                      },
                    ),
                  ],
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
