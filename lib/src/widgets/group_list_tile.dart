import 'package:flutter/material.dart';

class GroupListTile extends StatelessWidget {
  final String name;
  final int groupId;

  const GroupListTile({Key? key, required this.name, required this.groupId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          Navigator.of(context).pushReplacementNamed('/group_detail');
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
