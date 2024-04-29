import 'package:flutter/material.dart';

class CategorySection extends StatelessWidget {
  final String title;

  const CategorySection({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(0.0),
          child: Text(
            title,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(
          height: 180,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 10, // Hier die Anzahl der Elemente eintragen
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(right: 8.0, top: 8.0),
                child: Container(
                  width: 120,
                  color: Colors
                      .grey, // Hier würde das Bild des Films oder der Serie stehen
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}