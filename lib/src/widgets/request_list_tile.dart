import 'package:flutter/material.dart';

import '../models/user_flashr.dart';
import '../services/friends_service.dart';

class RequestListTile extends StatelessWidget {
  final String name;
  final List<UserFlashr> users;

  const RequestListTile({Key? key, required this.name, required this.users}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          height: 420,
          child: users.isEmpty ? Center(child: Text("Keine Suchergebnisse")) : ListView.builder(
            scrollDirection: Axis.vertical,
            itemCount: users.length, // Hier die Anzahl der Elemente eintragen
            itemBuilder: (context, index) {
              final user = users[index];
              return GestureDetector(
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
                      child:Text("Annehmen"),),
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
