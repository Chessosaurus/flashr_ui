import 'package:flasher_ui/src/services/search_service.dart';
import 'package:flasher_ui/src/widgets/header_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/filter.dart';
import '../models/media.dart';
import '../widgets/search_section.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late Future<List<Media>> searchResults;
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    searchResults = Future.value([]);
  }

  @override
  Widget build(BuildContext context) {
    final filterModel = Provider.of<FilterModel>(context);

    void updateSearchResults(String query) {
      if (query.isNotEmpty) {
        setState(() {
          searchResults = filterModel.selectedFilter == FilterType.movies
              ? SearchService.fetchMoviesSearch(query)
              : SearchService.fetchTvsSearch(query);
        });
      } else {
        setState(() {
          searchResults = Future.value([]);
        });
      }
    }

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
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Column(
                children: [
                  HeaderSearch(
                    onFilterChanged: (newFilter) {
                      updateSearchResults(_searchController.text);
                    },
                  ),
                  SizedBox(height: 8),
                  TextField(
                    onChanged: (query) {
                      if (query.isNotEmpty) {
                        setState(() {
                          searchResults =
                              filterModel.selectedFilter == FilterType.movies
                                  ? SearchService.fetchMoviesSearch(query)
                                  : SearchService.fetchTvsSearch(query);
                        });
                      } else {
                        setState(() {
                          searchResults = Future.value(
                              []);
                        });
                      }
                    },
                  ),
                  SizedBox(height: 20),
                  FutureBuilder<List<Media>>(
                    future: searchResults,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else {
                        return SearchSection(
                          title: 'Top Ergebnisse',
                          medias: snapshot.data!,
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
    );
  }
}
