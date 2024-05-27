import 'package:flasher_ui/src/widgets/header.dart';
import 'package:flasher_ui/src/services/movie_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/filter.dart';
import '../models/media.dart';
import '../models/movie.dart';
import '../models/tv.dart';
import '../services/tv_service.dart';
import '../widgets/category_section.dart';
import '../widgets/navbar.dart';

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
    final filterModel = Provider.of<FilterModel>(context);
    late Future<List<Media>> contentTrending;
    late Future<List<Media>> contentWatchlist;
    late Future<List<Media>> contentRecommendations;

    if (filterModel.selectedFilter == FilterType.movies) {
      // Filme abrufen
      contentTrending = MovieService.fetchMoviesTrending(true);
      contentWatchlist = MovieService.fetchMovieWatchlist();
      contentRecommendations = MovieService.fetchMovieRecommendation();
    } else {
      // Serien abrufen
      contentTrending = TvService.fetchTvsTrending(true);
      contentWatchlist = TvService.fetchTvWatchlist();
      contentRecommendations = TvService.fetchTvRecommendation();
    }
    return Scaffold(
      body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Header(),
                    TextField(
                      decoration: InputDecoration(
                        labelText: 'Suche nach Filmen, Serien, Genres etc.',
                        prefixIcon: Icon(Icons.search),
                      ),
                      onTap: () {
                        Navigator.pushNamed(context, '/search');
                      },
                    ),
                    SizedBox(height: 20),
                    FutureBuilder<List<dynamic>>(
                      future: contentWatchlist,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else {
                          return CategorySection(
                              title: filterModel.selectedFilter == FilterType.movies
                              ? 'Watchlist'
                                  : 'Watchlist',
                              media: filterModel.selectedFilter == FilterType.movies
                              ? snapshot.data!.cast<Movie>()
                            : snapshot.data!.cast<Tv>(),
                          );
                        }
                      },
                    ),
                    SizedBox(height: 20),
                    FutureBuilder<List<dynamic>>(
                      future: contentTrending,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else {
                          return CategorySection(
                            title: filterModel.selectedFilter == FilterType.movies
                                ? 'Beliebte Filme'
                                : 'Beliebte Serien',
                            media: filterModel.selectedFilter == FilterType.movies
                                ? snapshot.data!.cast<Movie>()
                                : snapshot.data!.cast<Tv>(),
                          );
                        }
                      },
                    ),
                    SizedBox(height: 20),

                    FutureBuilder<List<dynamic>>(
                      future: contentRecommendations,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else {
                          return CategorySection(
                            title: filterModel.selectedFilter == FilterType.movies
                                ? 'Für dich Empfohlen'
                                : 'Für dich Empfohlen',
                            media: filterModel.selectedFilter == FilterType.movies
                                ? snapshot.data!.cast<Movie>()
                                : snapshot.data!.cast<Tv>(),
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
