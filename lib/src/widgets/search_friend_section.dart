import 'package:flasher_ui/src/models/movie.dart';
import 'package:flasher_ui/src/models/user_flashr.dart';
import 'package:flasher_ui/src/services/friends_service.dart';
import 'package:flasher_ui/src/widgets/friend_list_tile.dart';
import 'package:flutter/material.dart';

class SearchFriendSection extends StatelessWidget {
  final String title;
  final List<UserFlashr> users;

  const SearchFriendSection({Key? key, required this.title, required this.users}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(0.0),
          child: Text(
            title,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(
          height: 420,
          child: users.isEmpty ? Center(child: Text("Keine Suchergebnisse")) : ListView.builder(
            scrollDirection: Axis.vertical,
            itemCount: users.length, // Hier die Anzahl der Elemente eintragen
            itemBuilder: (context, index) {
              final user = users[index];
              return GestureDetector(
                onTap: () {
                  print('Tapped!');
                },
                child: Container(
                  margin: EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(3.0),
                    border: Border.all(color: Colors.grey),
                  ),
                  child: ListTile(
                    leading: Icon(Icons.person, size: 40.0),
                    title: Text(user.username as String, style: TextStyle(fontSize: 18.0)),
                    trailing: ElevatedButton(onPressed: () {
                      FriendsService.requestFriendship(user.userId);
                    },
                      child:Text("Hinzufügen"),),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}