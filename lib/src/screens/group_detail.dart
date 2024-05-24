import 'package:flasher_ui/src/models/user_flashr.dart';
import 'package:flasher_ui/src/screens/groups.dart';  // Importiere die Groups-Seite
import 'package:flasher_ui/src/screens/profile.dart';
import 'package:flasher_ui/src/services/friends_service.dart';
import 'package:flasher_ui/src/services/group_service.dart';
import 'package:flasher_ui/src/widgets/friend_list_tile.dart';
import 'package:flasher_ui/src/widgets/header.dart';
import 'package:flasher_ui/src/widgets/header_friends.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flasher_ui/src/widgets/friend_list_tile.dart';

import '../models/friend.dart';
import '../widgets/category_section.dart';
import '../widgets/navbar.dart';
import '../widgets/friend_list_tile.dart';
import 'home.dart';
import 'movie_swipe.dart';

class GroupDetailPage extends StatefulWidget {
  final int groupId;
  const GroupDetailPage({super.key, required this.groupId});
  @override
  State<GroupDetailPage> createState() => _GroupDetailPage(groupId: groupId);
}

class _GroupDetailPage extends State<GroupDetailPage> {
  final groupId;
  _GroupDetailPage({required this.groupId});
  late Future<List<UserFlashr>> groupMemberList;

  @override
  void initState() {
    super.initState();
    groupMemberList = GroupService.getUsersOfGroup(26);
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
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            children: [
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
                    return SizedBox(  // Wrap ListView.builder in SizedBox
                      height: MediaQuery.of(context).size.height * 0.5, // Example height
                      child: ListView.builder(
                        shrinkWrap: true,  // Add shrinkWrap
                        physics: const NeverScrollableScrollPhysics(), // Disable scrolling
                        itemCount: groupMembers.length,
                        itemBuilder: (context, index) {
                          return FriendListTile(name: groupMembers[index].username.toString());
                        },
                      ),
                    );
                  }},
              ),
            ],
          ),
        ),
      ),
      );
  }

  void _navigateToProfile(BuildContext context) {
    Navigator.of(context).pushReplacementNamed('/profile');
  }
}

