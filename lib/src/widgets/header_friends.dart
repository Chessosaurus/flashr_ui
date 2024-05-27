import 'package:flutter/material.dart';

class HeaderFriends extends StatelessWidget {
  const HeaderFriends({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Row(
        children: [
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Suche nach Freunden',
                prefixIcon: Icon(Icons.search),
              ),
              onTap: (){
                Navigator.of(context).pushReplacementNamed('/friend_search');
              },
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

  void _navigateToQRCode(BuildContext context) {
    Navigator.of(context).pushReplacementNamed('/qr_code');
  }
}
