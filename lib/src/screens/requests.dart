import 'package:flasher_ui/src/widgets/request_list_tile.dart';
import 'package:flutter/material.dart';

import '../models/friend.dart';
import '../services/friends_service.dart';
import '../widgets/friend_navbar.dart';
import '../widgets/navbar.dart';


class Requests extends StatefulWidget {
  const Requests({super.key});

  @override
  State<Requests> createState() => _Requests();
}

class _Requests extends State<Requests> {

  late Future<List<Friend>> friendRequestsList;

  @override
  void initState() {
    super.initState();
    _refreshFriendRequests();
  }

  Future<void> _refreshFriendRequests() async {
    setState(() {
      friendRequestsList = FriendsService.getFriendshipRequests();
    });
  }


  int _selectedIndex = 2;

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

  int _selectedIndexFriends = 2;
  void _onItemTappedFriends(int index){
    setState(() {
      _selectedIndexFriends = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(


      body:  SingleChildScrollView(
        child: Padding(
            padding: EdgeInsets.all(20.0),
            child: Column(
              children:[
                Text(
                  'Deine Anfragen',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20),
                FutureBuilder<List<Friend>>(
                  future: friendRequestsList,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      final friends = snapshot.data!;
                      return SizedBox(
                        height: MediaQuery.of(context).size.height * 0.5,
                        child: ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: friends.length,
                          itemBuilder: (context, index) {
                            return RequestListTile(users:friends, onRequestUpdated: _refreshFriendRequests,);
                          },
                        ),
                      );
                    }},
                ),
              ],
            )
        ),
      ),

      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: FriendNavbar(
              selectedIndex: _selectedIndexFriends,
              onItemTapped: _onItemTappedFriends,
            ),
          ),
          NavBar(
            selectedIndex: _selectedIndex,
            onItemTapped: _onItemTapped,
          ),
        ],
      ),
    );
  }
}
