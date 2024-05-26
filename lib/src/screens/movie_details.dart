import 'package:flasher_ui/src/models/movie.dart';
import 'package:flutter/material.dart';
import '../models/media.dart';
import '../models/tv.dart';
import '../services/movie_service.dart';
import '../services/tv_service.dart';
import 'movie_swipe.dart';
import 'dart:math' as math;

class MovieDetails extends StatefulWidget {
  final Media media;

  const MovieDetails({Key? key, required this.media})
      : super(key: key); // media statt movie

  @override
  State<MovieDetails> createState() => _MovieDetailsState();
}

class _MovieDetailsState extends State<MovieDetails>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool isFrontVisible = true;

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
            title: Text(widget.media.title),
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
                onPressed: () {
                  _setMediaStatusWatched(widget.media);
                },
              ),
              IconButton(
                icon: Icon(Icons.favorite),
                onPressed: () {
                  _setMediaStatusFavorite(widget.media);
                },
              ),
            ],
          ),
          body: GestureDetector(
            onTap: () {
              setState(() {
                isFrontVisible =
                    !isFrontVisible; // Ändere den Status, wenn auf die Karte geklickt wird
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
                    ? CardFront(title: widget.media.posterPath!)
                    : CardBack(mediaItem: widget.media), // mediaExtra übergeben
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

  Future<void> _setMediaStatusWatched(Media mediaItem) async {
    try {
      if (mediaItem is Movie) {
        await MovieService.setMovieStatusWatched(mediaItem.id);
      } else if (mediaItem is Tv) {
        await TvService.setTVStatusWatched(mediaItem.id);
      }
    } on Exception catch (error) {
      print('Fehler beim Setzen des Status auf "Gesehen"');
    }
  }

  Future<void> _setMediaStatusFavorite(Media mediaItem) async {
    try {
      if (mediaItem is Movie) {
        List<Movie> data = await MovieService.fetchMovieFavorite();
        if(data.length <= 3){
          await MovieService.setMovieStatusFavorite(mediaItem.id);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Favorit erfolgreich gesetzt!')),
          );
        } else {
          showDialog(
            context: context,
            builder: (context) =>
                AlertDialog(
                  title: Text('Fehler'),
                  content: Text(
                      'Favorit konnte nicht gesetzt werden, da schon alle Favoriten gesetzt worden.'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('OK'),
                    ),
                  ],
                ),
          );
        }

      } else if (mediaItem is Tv) {
        List<Tv> data = await TvService.fetchTvFavorite();
        if(data.length <= 3){
          await TvService.setTVStatusFavorite(mediaItem.id);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Favorit erfolgreich gesetzt!')),
          );
        }

      }
    } on Exception catch (error) {
      print('Fehler beim Setzen des Status auf "Favorit');
    }
    showDialog(
      context: context,
      builder: (context) =>
          AlertDialog(
            title: Text('Fehler'),
            content: Text(
                'Favorit konnte nicht gesetzt werden, da schon alle Favoriten gesetzt worden.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('OK'),
              ),
            ],
          ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
