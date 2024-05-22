import 'package:flutter/material.dart';

class FriendListTile extends StatelessWidget {
  final String name;

  const FriendListTile({Key? key, required this.name}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
          title: Text(name, style: TextStyle(fontSize: 18.0)),
          trailing: Icon(Icons.chevron_right),
        ),
      ),
    );
  }
}
