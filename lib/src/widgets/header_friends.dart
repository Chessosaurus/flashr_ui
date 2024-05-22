import 'package:flutter/material.dart';

import '../screens/profile.dart';

class HeaderFriends extends StatelessWidget {
  const HeaderFriends({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity, // Setzen der Breite auf die Bildschirmbreite
      child: Row(
        children: [
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Suche nach Freunden',
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),

          IconButton(
            icon: Icon(Icons.qr_code),
            onPressed: () {
              _navigateToQRCode(context);
            },
          ),
        ],
      ),
    );
  }

  void _navigateToProfile(BuildContext context) {
    Navigator.of(context).pushReplacementNamed('/profile');
  }

  void _navigateToQRCode(BuildContext context) {
    Navigator.of(context).pushReplacementNamed('/qr_code');
  }
}
