import 'package:flasher_ui/src/models/movie.dart';
import 'package:flasher_ui/src/models/user_flashr.dart';
import 'package:flasher_ui/src/services/friends_service.dart';
import 'package:flasher_ui/src/widgets/friend_list_tile.dart';
import 'package:flutter/material.dart';

class SearchFriendSection extends StatefulWidget {
  final String title;
  final List<UserFlashr> users;

  const SearchFriendSection({Key? key, required this.title, required this.users}) : super(key: key);

  @override
  State<SearchFriendSection> createState() => _SearchFriendSectionState();
}

class _SearchFriendSectionState extends State<SearchFriendSection> {
  Future<void> _sendFriendRequest(int? userId) async {
    try {
      await FriendsService.requestFriendship(userId); // Overlay schließen nach erfolgreicher Erstellung
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Benutzer wurde eine Freundschaftsanfrage gesendet!')),
      );
    } catch (e) {
      print('Fehler beim Senden einer Freundschaftsanfrage: $e');
      showDialog(
        context: context,
        builder: (context) =>
            AlertDialog(
              title: Text('Fehler'),
              content: Text(
                  'Dem Benutzer konnte keine Freundschaftsanfrage gesendet werden.'),
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

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(0.0),
          child: Text(
            widget.title,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(
          height: 420,
          child: widget.users.isEmpty ? Center(child: Text("Keine Suchergebnisse")) : ListView.builder(
            scrollDirection: Axis.vertical,
            itemCount: widget.users.length, // Hier die Anzahl der Elemente eintragen
            itemBuilder: (context, index) {
              final user = widget.users[index];
                return Container(
                  margin: EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(3.0),
                    border: Border.all(color: Colors.grey),
                  ),
                  child: ListTile(
                    leading: Icon(Icons.person, size: 40.0),
                    title: Text(user.username as String, style: TextStyle(fontSize: 18.0)),
                    trailing: ElevatedButton(onPressed: () {
                      _sendFriendRequest(user.userId);
                    },
                      child:Text("Hinzufügen"),),
                  ),
                );
            },
          ),
        ),
      ],
    );
  }
}