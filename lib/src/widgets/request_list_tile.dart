import 'package:flutter/material.dart';

import '../models/user_flashr.dart';
import '../services/friends_service.dart';

class RequestListTile extends StatefulWidget {
  final String name;
  final List<UserFlashr> users;

  const RequestListTile({Key? key, required this.name, required this.users}) : super(key: key);

  @override
  State<RequestListTile> createState() => _RequestListTileState();
}

class _RequestListTileState extends State<RequestListTile> {

  Future<void> _acceptFriendship(int? friendId) async {
    try {
      await FriendsService.acceptFriendship(friendId); // Overlay schließen nach erfolgreicher Erstellung
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Die Anfrage wurde erfolgreich angenommen!')),
      );
    } catch (e) {
      print('Fehler beim akzeptieren einer Freundschaft: $e');
      showDialog(
        context: context,
        builder: (context) =>
            AlertDialog(
              title: Text('Fehler'),
              content: Text(
                  'Die Anfrage konnte nicht angenommen werden.'),
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

  Future<void> _declineFriendship(int? friendId) async {
    try {
      await FriendsService.removeFriendship(friendId); // Overlay schließen nach erfolgreicher Erstellung
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Die Anfrage wurde erfolgreich abgelehnt!')),
      );
    } catch (e) {
      print('Fehler beim ablehnen einer Freundschaft: $e');
      showDialog(
        context: context,
        builder: (context) =>
            AlertDialog(
              title: Text('Fehler'),
              content: Text(
                  'Die Anfrage konnte nicht abgelehnt werden.'),
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
        SizedBox(
          height: 420,
          child: widget.users.isEmpty ? Center(child: Text("Keine Suchergebnisse")) : ListView.builder(
            scrollDirection: Axis.vertical,
            itemCount: widget.users.length, // Hier die Anzahl der Elemente eintragen
            itemBuilder: (context, index) {
              final user = widget.users[index];
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
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min, // Damit die Row nicht zu breit wird
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            _acceptFriendship(user.userId);
                          },
                          child: Text("Annehmen"),
                        ),
                        SizedBox(width: 8), // Abstand zwischen den Buttons
                        ElevatedButton(
                          onPressed: () {
                            _declineFriendship(user.userId); // Methode zum Ablehnen aufrufen
                          },
                          child: Text("Ablehnen"),
                        ),
                      ],
                    ),
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
