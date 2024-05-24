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

class _MovieDetailsState extends State<MovieDetails> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final Movie movie; // Store the passed movie object
  bool isFrontVisible = true;

  _MovieDetailsState(this.movie);

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Dummy CardData
    return LayoutBuilder(
      builder: (context, constraints) {
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
            title: Text(movie.title),
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
                if (isFrontVisible) {
                  _controller.reverse();
                } else {
                  _controller.forward();
                }
              });
            },
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                double value = _controller.value;
                return Transform(
                  transform: Matrix4.identity()
                    ..setEntry(3, 2, 0.001) // Perspektive
                    ..rotateY(math.pi * value), // Rotation um die y-Achse
                  alignment: Alignment.center,
                  child: child,
                );
              },
              child: Container(
                key: UniqueKey(),
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
                    : CardBack(
                    title: movie.title,
                    description: movie.overview,
                    posterPath: movie.posterPath,
                    voteAverage: movie.voteAverage,
                    releaseDate: movie.releaseDate,
                    id: movie.id
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _navigateBack(BuildContext context) {
    Navigator.of(context).pushReplacementNamed('/homepage');
  }

  Future<void> _watched() async {
    ///
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
