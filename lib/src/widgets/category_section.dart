import 'package:flasher_ui/src/models/movie.dart';
import 'package:flutter/material.dart';

class CategorySection extends StatelessWidget {
  final String title;
  final List<Movie> movies;

  const CategorySection({Key? key, required this.title, required this.movies}) : super(key: key);

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
          child: movies.isEmpty ? Center(child: Text("Keine Filme verfügbar")) : ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: movies.length, // Hier die Anzahl der Elemente eintragen
            itemBuilder: (context, index) {
              final movie = movies[index];
              return Padding(
                padding: const EdgeInsets.only(right: 8.0, top: 8.0),
                child: Container(
                  width: 120,
                  color: Colors.grey, // Hier würde das Bild des Films oder der Serie stehen
                  child: Column(
                    children: [
                  // Zeige das Bild des Films an
                  Image.network(
                  'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                    width: 120,
                    height: 172,
                    fit: BoxFit.cover,
                  ),
                    ],
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