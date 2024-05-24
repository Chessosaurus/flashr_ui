import 'package:flasher_ui/src/models/movie.dart';
import 'package:flutter/material.dart';

import '../services/supabase_auth_service.dart';
import 'movie_swipe.dart';
import 'dart:math' as math;

class MovieDetails extends StatefulWidget {
  const MovieDetails({Key? key, required this.movie}) : super(key: key);

  final Movie movie;
  @override
  State<MovieDetails> createState() => _MovieDetailsState(movie);
}

class _MovieDetailsState extends State<MovieDetails> {
  final Movie movie; // Store the passed movie object
  bool isFrontVisible = true;

  _MovieDetailsState(this.movie);

  Future<void> _watched() async {
    ///
  }

  @override
  void initState() {
    super.initState();
  }

  //CardData cardData = new CardData(id: 1, title: 'Test', description: 'description', posterPath: 'posterPath', voteAverage: 5.2, releaseDate: '12-12-1221');


  @override
  Widget build(BuildContext context) {
    // Dummy CardData
    return LayoutBuilder(
        builder: (context, constraints){
          double availableWidth = constraints.maxWidth;
          double availableHeight = constraints.maxHeight;

          // Berechne die Breite und Höhe basierend auf dem 3:2-Verhältnis
          double cardWidth = math.min(availableWidth, (availableHeight * 2) / 3);
          double cardHeight = (cardWidth * 3) / 2;

          // Bestimme die horizontale Mitte des Bildschirms
          double screenWidth = MediaQuery.of(context).size.width;
          double screenCenterX = screenWidth / 2;


          return Scaffold(
            appBar: AppBar(
              title: Text('Titel des Films'),
              centerTitle: true,
              leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  _navigateBack(context);
                },
              ),
              actions: [
                IconButton(
                  icon: Icon(Icons.remove_red_eye),
                  onPressed: _watched,
                ),
              ],
            ),
            body: GestureDetector(
              onTap: () {
                setState(() {
                  isFrontVisible = !isFrontVisible; // Ändere den Status, wenn auf die Karte geklickt wird
                });
              },
              child: AnimatedSwitcher(
                duration: Duration(milliseconds: 500), // Animationsdauer
                child: Container(
                  key: UniqueKey(), // Wichtig, um dem AnimatedSwitcher mitzuteilen, dass sich der Widget-Inhalt ändert
                  width: cardWidth,
                  height: cardHeight,
                  margin: EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: isFrontVisible
                      ? CardFront(title: movie.posterPath)
                      : CardBack(title: movie.title, description: movie.overview, posterPath: movie.posterPath, voteAverage: movie.voteAverage, releaseDate: movie.releaseDate),
                ),
              ),
            ),
          );
        }
    );

  }

  void _navigateBack(BuildContext context) {
    Navigator.of(context).pushReplacementNamed('/homepage');
  }
}