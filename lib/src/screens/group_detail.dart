import 'package:flasher_ui/src/models/group.dart';
import 'package:flasher_ui/src/models/user_flashr.dart';
import 'package:flasher_ui/src/services/group_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../models/friend.dart';
import '../services/friends_service.dart';


class GroupDetailPage extends StatefulWidget {
  final Group group;
  const GroupDetailPage({super.key, required this.group});
  @override
  State<GroupDetailPage> createState() => _GroupDetailPage();
}

class _GroupDetailPage extends State<GroupDetailPage> {
  late Future<List<UserFlashr>> groupMemberList;
  late Future<List<Friend>> friendList;

  @override
  void initState() {
    super.initState();
    groupMemberList = GroupService.getUsersOfGroup(widget.group.id);
    friendList = FriendsService.getFriendsOfUser();
  }

  bool _showOverlay = false;

  void _toggleOverlay() {
    setState(() {
      _showOverlay = !_showOverlay;
    });
  }

  Future<void> _addMemberToGroup(int userId) async {
    try {
      await GroupService.addUserToGroup(widget.group.id, userId);
      setState(() {
        groupMemberList = GroupService.getUsersOfGroup(widget.group.id);
      });
      _toggleOverlay();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Benutzer erfolgreich zur Gruppe hinzugefügt!')),
      );
    } catch (e) {
      print('Fehler beim Entfernen des Benutzers: $e');
      showDialog(
        context: context,
        builder: (context) =>
            AlertDialog(
              title: Text('Fehler'),
              content: Text(
                  'Der Benutzer konnte nicht der Gruppe hinzugefügt werden.'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('OK'),
                ),
              ],
            ),
      );
    }
  }

  Future<void> _removeUserFromGroup(int? userId) async {
    try {
      await GroupService.removeUserFromGroup(widget.group.id, userId);
      setState(() {
        Navigator.of(context).pushReplacementNamed('/groups');
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Benutzer erfolgreich aus der Gruppe entfernt!')),
      );
    } catch (e) {
      print('Der Benutzer konnte nicht aus der Gruppe entfernt werden..: $e');
      showDialog(
        context: context,
        builder: (context) =>
            AlertDialog(
              title: Text('Fehler'),
              content: Text(
                  'Der Benutzer konnte nicht aus der Gruppe entfernt werden.'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('OK'),
                ),
              ],
            ),
      );
    }
  }

  Future<void> _deleteGroup() async {
    showDialog(
      context: context,
      builder: (context) =>
          AlertDialog(
            title: Text('Gruppe wirklich löschen?'),
            content: Text(
                'Sind sie sich sicher das Sie die Gruppe löschen wollen?'),
            actions: [
              TextButton(
                onPressed: () async {
                  try {
                    await GroupService.deleteGroup(widget.group.id);
                    setState(() {
                      Navigator.of(context).pushReplacementNamed('/groups');
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Gruppe erfolgreich gelöscht!')),
                    );
                  } catch (e) {
                    print('Fehler beim Löschen der Gruppe: $e');
                    showDialog(
                      context: context,
                      builder: (context) =>
                          AlertDialog(
                            title: Text('Fehler'),
                            content: Text(
                                'Fehler beim Löschen der Gruppe.'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: Text('OK'),
                              ),
                            ],
                          ),
                    );
                  }
                },
                child: Text('Ja'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Nein'),
              ),
            ],
          ),
    );
  }


      @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gruppenmitglieder'),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pushReplacementNamed('/groups');
          },
        ),
      ),
      body: Stack(
          children: [
      SingleChildScrollView(
      child: Padding(
      padding: EdgeInsets.all(20.0),
      child: Column(
        children: <Widget>[
          Text(
            widget.group.name,
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              _toggleOverlay();
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.add),
                SizedBox(width: 8),
                Text('Mitglied hinzufügen'),
              ],
            ),
          ),
          SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              _deleteGroup();
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.delete_forever),
                SizedBox(width: 8),
                Text('Gruppe löschen'),
              ],
            ),
          ),
          SizedBox(height: 20),
              FutureBuilder<List<UserFlashr>>(
                future: groupMemberList,
                builder: (context, snapshot) {
                  if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    final groupMembers = snapshot.data!;
                    return SizedBox(
                      height: MediaQuery.of(context).size.height * 0.5,
                      child: ListView.builder(
                        shrinkWrap: true,  // Add shrinkWrap
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: groupMembers.length,
                        itemBuilder: (context, index) {
                           return Container(
                              margin: EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(3.0),
                                border: Border.all(color: Colors.grey),
                              ),
                              child: ListTile(
                                leading: Icon(Icons.person, size: 40.0),
                                title: Text(groupMembers[index].username.toString(), style: TextStyle(fontSize: 18.0)),
                                trailing: ElevatedButton(onPressed: () {
                                  setState(() {
                                    _removeUserFromGroup(groupMembers[index].userId);
                                  });
                                },
                                  child:Icon(Icons.delete),
                                ),
                              ),
                           );
                        },
                      ),
                    );
                  }},
              ),
            ],
          ),
        ),
      ),
            if (_showOverlay)
              Container(
                color: Colors.black54,
                child: Center(
                  child: Container(
                    padding: EdgeInsets.all(20),
                    color: Colors.black,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        FutureBuilder<List<Friend>>(
                          future: friendList,
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
                                    return Container(
                                      margin: EdgeInsets.all(8.0),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(3.0),
                                        border: Border.all(color: Colors.grey),
                                      ),
                                      child: ListTile(
                                        leading: Icon(Icons.person, size: 40.0),
                                        title: Text(friends[index].friendName, style: TextStyle(fontSize: 18.0)),
                                        trailing: ElevatedButton(onPressed: () {
                                          _addMemberToGroup(friends[index].friendId);
                                        },
                                          child:Text("Hinzufügen"),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              );
                            }},
                        ),
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                              onPressed: _toggleOverlay,
                              child: Text('Zurück'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ]
      ),
    );
  }
}

