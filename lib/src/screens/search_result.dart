import 'package:flasher_ui/src/services/search_service.dart';
import 'package:flasher_ui/src/widgets/header_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


import '../models/movie.dart';
import '../services/movie_service.dart';
import '../widgets/category_section.dart';
import '../widgets/search_section.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late Future<List<Movie>> trendingMovies;
  late Future<List<Movie>> searchResult;
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    trendingMovies =  MovieService.fetchMoviesTrending(true);
    searchResult = SearchService.fetchMoviesSearch("");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pushReplacementNamed('/slide_to_home');
          },
        ),
    ),
    body: SingleChildScrollView(
      child: Column( // Hier wurde das Column-Widget hinzugefügt
        children: <Widget>[
          SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: Column(
                children: [
                  HeaderSearch(),
                  // Suchleiste
                  SizedBox(
                    height: 8,
                  ),
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'Suche nach Filmen,Genres etc.',
                      prefixIcon: Icon(Icons.search),
                    ),
                    controller: _searchController,
                    onChanged: (query){
                      if(_searchController.text.isNotEmpty){
                        setState(() {
                          searchResult = SearchService.fetchMoviesSearch(query);
                        });
                      }
                    },
                  ),
                  // Film Listenansichten
                  SizedBox(height: 20),
                  FutureBuilder<List<Movie>>(
                    future: searchResult,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState ==
                          ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else {
                        return SearchSection(title: 'Top Ergebnisse',
                            movies: snapshot.data!);
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
    );
  }
}

