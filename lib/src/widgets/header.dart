import 'package:flutter/material.dart';

import '../screens/profile.dart';

class Header extends StatelessWidget {

  const Header({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              // Aktion beim Klick auf "Alle"
            },
            style: ElevatedButton.styleFrom(
              fixedSize: Size.fromHeight(40),
            ),
            child: const Text('Alle'),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              // Aktion beim Klick auf "Filme"

            }, // Zeige den Schriftzug nur, wenn der Button nicht aktiv ist
            style: ElevatedButton.styleFrom(
              fixedSize: Size.fromHeight(40),
            ),
            child: const Text('Filme'),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              // Aktion beim Klick auf "Serien"

            }, // Zeige den Schriftzug nur, wenn der Button nicht aktiv ist
            style: ElevatedButton.styleFrom(
              fixedSize: const Size.fromHeight(40),
            ),
            child: const Text('Serien'),
          ),
        ),
        const SizedBox(width: 8),
        // Platz für Profil-Icon
        IconButton(
          icon: const Icon(Icons.account_circle),
          onPressed: () {
            // Aktion bei Klick auf Profil-Icon
            _navigateToProfile(context);
          },
          iconSize: 50,
        ),
      ],
    );
  }
  void _navigateToProfile(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ProfilePage()),
    );
  }
}
