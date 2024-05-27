import 'package:flasher_ui/src/widgets/friend_navbar.dart';
import 'package:flutter/material.dart';
import '../models/group.dart';
import '../services/group_service.dart';
import '../widgets/group_list_tile.dart';
import '../widgets/navbar.dart';

class Groups extends StatefulWidget {
  const Groups({super.key});

  @override
  State<Groups> createState() => _Groups();
}

class _Groups extends State<Groups> {

  late Future<List<Group>> groupsOfUserList;

  @override
  void initState() {
    super.initState();
    groupsOfUserList = GroupService.getGroupsOfUsers();
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

  int _selectedIndexFriends = 1;
  void _onItemTappedFriends(int index){
    setState(() {
      _selectedIndexFriends = index;
    });
  }

  bool _showOverlay = false;
  final TextEditingController _groupNameController = TextEditingController();

  void _toggleOverlay() {
    setState(() {
      _showOverlay = !_showOverlay;
    });
  }

    Future<void> _createGroup() async {
      try {
        await GroupService.createGroup(_groupNameController.text);
        _toggleOverlay();
      } catch (e) {
        print('Fehler beim Erstellen der Gruppe: $e');
      }
    }


    @override
    Widget build(BuildContext context) {
      return Scaffold(
        body: Stack(
            children: [
              SingleChildScrollView(
                child: Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Column(
                      children: <Widget>[
                        Text(
                          'Deine Gruppen',
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
                              Text('Gruppe erstellen'),
                            ],
                          ),
                        ),
                        SizedBox(height: 20),
                        FutureBuilder<List<Group>>(
                          future: groupsOfUserList,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return CircularProgressIndicator();
                            } else if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            } else {
                              final groups = snapshot.data!;
                              return SizedBox(
                                height: MediaQuery.of(context).size.height * 0.5,
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: groups.length,
                                  itemBuilder: (context, index) {
                                    return GroupListTile(name: groups[index].name, group: groups[index],);
                                  },
                                ),
                              );
                            }
                          },
                        ),
                      ],
                    )
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
                          TextField(
                            controller: _groupNameController,
                            decoration: InputDecoration(
                                labelText: 'Gruppenname'
                            ),
                          ),
                          SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ElevatedButton(
                                onPressed: _createGroup,
                                child: Text('Erstellen'),
                              ),
                              ElevatedButton(
                                onPressed: _toggleOverlay,
                                child: Text('Abbrechen'),
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
