import 'package:flutter/material.dart';

import '../screens/profile.dart';

class HeaderSearch extends StatelessWidget {

  const HeaderSearch({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
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
      ],
    );
  }
}
