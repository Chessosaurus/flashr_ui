import 'package:flasher_ui/src/models/user_flashr.dart';

import 'package:flasher_ui/src/services/search_service.dart';
import 'package:flasher_ui/src/widgets/header_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../widgets/search_friend_section.dart';
import '../widgets/search_section.dart';

class SearchFriendPage extends StatefulWidget {
  const SearchFriendPage({super.key});

  @override
  State<SearchFriendPage> createState() => _SearchFriendPageState();
}

class _SearchFriendPageState extends State<SearchFriendPage> {
  late Future<List<UserFlashr>> searchResult;
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    searchResult = SearchService.fetchFriendsSearch("");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pushReplacementNamed('/slide_to_friends');
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
                  // Suchleiste
                  SizedBox(
                    height: 8,
                  ),
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'Suche nach Freunde',
                      prefixIcon: Icon(Icons.search),
                    ),
                    controller: _searchController,
                    onChanged: (query){
                      if(_searchController.text.isNotEmpty){
                        setState(() {
                          searchResult = SearchService.fetchFriendsSearch(query);
                        });
                      }
                    },
                  ),
                  // Film Listenansichten
                  SizedBox(height: 20),
                  FutureBuilder<List<UserFlashr>>(
                    future: searchResult,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState ==
                          ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else {
                        return SearchFriendSection(title: 'Top Ergebnisse',
                            users: snapshot.data!);
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

