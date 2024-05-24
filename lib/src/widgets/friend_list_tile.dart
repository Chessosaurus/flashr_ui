import 'package:flasher_ui/src/models/friend.dart';
import 'package:flasher_ui/src/screens/friend_details.dart';
import 'package:flutter/material.dart';

class FriendListTile extends StatelessWidget {
  final Friend friend;

  const FriendListTile({Key? key, required this.friend}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FriendDetailPage(friend: friend),
          ),
        );;
      },
      child: Container(
        margin: EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(3.0),
          border: Border.all(color: Colors.grey),
        ),
        child: ListTile(
          leading: Icon(Icons.person, size: 40.0),
          title: Text(friend.friendName, style: TextStyle(fontSize: 18.0)),
          trailing: Icon(Icons.chevron_right),
        ),
    ),
    );
  }
}
