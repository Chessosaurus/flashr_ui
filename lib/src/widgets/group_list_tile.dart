import 'package:flasher_ui/src/screens/group_detail.dart';
import 'package:flutter/material.dart';

import '../models/group.dart';

class GroupListTile extends StatelessWidget {
  final String name;
  final Group group;

  const GroupListTile({Key? key, required this.name, required this.group}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
              builder: (context) => GroupDetailPage(group: group),
          ),
          );
        },
    child: Container(
        margin: EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(3.0),
          border: Border.all(color: Colors.grey),
        ),
        child: ListTile(
          leading: Icon(Icons.group, size: 40.0),
          title: Text(name, style: TextStyle(fontSize: 18.0)),
          trailing: Icon(Icons.chevron_right),
        ),
      )
    );
  }
}
