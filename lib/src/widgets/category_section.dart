import 'package:flasher_ui/src/screens/movie_details.dart';
import 'package:flutter/material.dart';
import '../models/media.dart';

class CategorySection extends StatelessWidget {
  final String title;
  final List<Media> media;

  const CategorySection({Key? key, required this.title, required this.media}) : super(key: key);

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
          child: media.isEmpty
              ? const Center(child: Text("Keine Medien verfügbar"))
              : ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: media.length,
            itemBuilder: (context, index) {
              final mediaItem = media[index];
              return Padding(
                padding: const EdgeInsets.only(right: 8.0, top: 8.0),
                child: GestureDetector(
                  onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MovieDetails(media: mediaItem),
                        ),
                      );
                  },
                  child: Container(
                    color: Colors.grey, // Placeholder
                    child: Column(
                      children: [
                        if (mediaItem.posterPath != null)
                          Image.network(
                            'https://image.tmdb.org/t/p/w500${mediaItem.posterPath}',
                            height: 172,
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
