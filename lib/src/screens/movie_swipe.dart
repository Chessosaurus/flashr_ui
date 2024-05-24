import 'package:flasher_ui/src/models/movie_extra.dart';
import 'package:flasher_ui/src/widgets/donut_chart.dart';
import 'package:flasher_ui/src/widgets/header.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


import 'dart:math' as math;

import '../models/movie.dart';
import '../services/movie_service.dart';
import '../widgets/navbar.dart';

class MovieSwipe extends StatefulWidget {
  const MovieSwipe({Key? key}) : super(key: key);

  @override
  State<MovieSwipe> createState() => _MovieSwipeState();
}

class _MovieSwipeState extends State<MovieSwipe> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  List<String> movieImages = [];
  List<Movie> movies = [];
  List<CardData> cards = [];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    fetchMovieImages();
  }

  Future<void> fetchMovieImages() async {
    try {
       movies = await MovieService.fetchSwipeMovieRecommendation(10);
      setState(() {
        cards = CardData.fromMovies(movies);
      });
    } catch (e) {
      print('Failed to fetch swipe movie recommendations: $e');
    }
  }

  int _selectedIndex = 1;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    // Hier füge deine Navigationslogik hinzu, basierend auf dem ausgewählten Index
    switch (index) {
      case 0:
      // Navigation zur Startseite
        Navigator.of(context).pushReplacementNamed('/homepage');
        break;
      case 1:
      // Navigation zu den Favoriten
        Navigator.of(context).pushReplacementNamed('/movieswipe');
        break;
      case 2:
      // Navigation zum Profil
        Navigator.of(context).pushReplacementNamed('/friends');
        break;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /*
      appBar: AppBar(
        title: Text('Karten Stapel'),
      ),
      */
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(20.0),
            child: Header(),
          ),
          Expanded(
            child: Stack(
              children: cards.map((card) {
                int index = cards.indexOf(card);
                return DraggableCard(
                  cardData: card,
                  onSwipe: () {
                    setState(() {
                      cards.remove(card);
                      if(cards.isEmpty){
                        fetchMovieImages();
                      }
                    });
                  },
                  onTap: () {
                    setState(() {
                      card.isFrontVisible = !card.isFrontVisible;
                      if (card.isFrontVisible) {
                        _controller.reverse();
                      } else {
                        _controller.forward();
                      }
                    });
                  },
                  controller: _controller,
                  zIndex: index.toDouble(),
                   // Stelle die Karten im Stapel dar
                );
              }).toList(),
            ),
          ),
          Padding(
              padding: EdgeInsets.all(20.0),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          MovieService.setMovieStatusUninterested(cards.removeLast().id);
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        fixedSize: Size.fromHeight(40),
                      ),
                      child: const Text('Nicht interessiert', textAlign: TextAlign.center,),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          MovieService.setMovieStatusInterested(cards.removeLast().id);
                        });
                      }, // Zeige den Schriftzug nur, wenn der Button nicht aktiv ist
                      style: ElevatedButton.styleFrom(
                        fixedSize: Size.fromHeight(40),
                      ),
                      child: const Text('Watchlist'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          MovieService.setMovieStatusWatched(cards.removeLast().id);
                        });

                      }, // Zeige den Schriftzug nur, wenn der Button nicht aktiv ist
                      style: ElevatedButton.styleFrom(
                        fixedSize: const Size.fromHeight(40),
                      ),
                      child: const Text('Gesehen'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Platz für Profil-Icon
                ],
              )
          )
        ],
      ),
      bottomNavigationBar: NavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}

class DraggableCard extends StatefulWidget {
  final CardData cardData;
  final Function onSwipe;
  final Function onTap;
  final AnimationController controller;
  final double zIndex; // zIndex hinzufügen

  DraggableCard({
    required this.cardData,
    required this.onSwipe,
    required this.onTap,
    required this.controller,
    required this.zIndex, // zIndex hinzufügen
  });

  @override
  _DraggableCardState createState() => _DraggableCardState();
}

class _DraggableCardState extends State<DraggableCard> {
  late Offset _startPosition;
  late Offset _position; // Aktuelle Position der Karte
  double _rotationAngle = 0.0; // Neigungswinkel der Karte

  @override
  void initState() {
    super.initState();
    _position = Offset.zero; // Setze die Startposition auf den Ursprung
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Bestimme die verfügbare Breite und Höhe
        double availableWidth = constraints.maxWidth;
        double availableHeight = constraints.maxHeight;

        // Berechne die Breite und Höhe basierend auf dem 3:2-Verhältnis
        double cardWidth = math.min(availableWidth, (availableHeight * 2) / 3);
        double cardHeight = (cardWidth * 3) / 2;

        // Bestimme die horizontale Mitte des Bildschirms
        double screenWidth = MediaQuery.of(context).size.width;
        double screenCenterX = screenWidth / 2;

        return GestureDetector(
          onTap: widget.onTap as void Function()?,
          onPanStart: (details) {
            _startPosition = details.localPosition;
          },
          onPanUpdate: (details) {
            setState(() {
              if (widget.cardData.isFrontVisible){
                _position += details.delta; // Aktualisiere die Position basierend auf der Verschiebung
                double deltaX = _position.dx - _startPosition.dx;

                // Berechne den Abstand der Karte zur Bildschirmmitte
                double distanceToCenter = (_position.dx + screenWidth / 2) - screenCenterX;

                // Berechne den maximalen Neigungswinkel basierend auf der Distanz zur Mitte
                double maxRotationAngle = math.pi / 8;
                double normalizedDistance = distanceToCenter / (screenWidth / 2);
                _rotationAngle = normalizedDistance * maxRotationAngle;
              }
            });
          },
          onPanEnd: (details) {
            double deltaX1 = _position.dx - _startPosition.dx;
            double deltaX2 = _startPosition.dx - _position.dx;
            double deltaY = _startPosition.dy - _position.dy;
            if (widget.cardData.isFrontVisible && deltaX1 > 100) { //Überprüfung auf Rechts-Swipe
              print("rechts");
              widget.onSwipe();
            }else if (widget.cardData.isFrontVisible && deltaX2 > 350){ //Überprüfung auf Links-Swipe
              widget.onSwipe();
              print("links");
            }else if (widget.cardData.isFrontVisible && deltaY > 700){ //Überprüfung auf Oben-Swipe
              widget.onSwipe();
              print("oben");
            }

            // Bringe die Karte immer zum Ausgangspunkt zurück
            setState(() {
              _position = Offset.zero;
              _rotationAngle = 0.0;
            });
          },
          child: AnimatedBuilder(
            animation: widget.controller,
            builder: (context, child) {
              return Transform(
                transform: Matrix4.rotationY(widget.controller.value * math.pi),
                alignment: Alignment.center,
                child: Transform.translate(
                  offset: _position, // Aktuelle Position der Karte
                  child: Transform.rotate(
                    angle: _rotationAngle, // Dynamisch berechneter Neigungswinkel
                    child: child,
                  ),
                ),
              );
            },
            child: Container(
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
              child: widget.cardData.isFrontVisible
                  ? CardFront(title: widget.cardData.posterPath)
                  : CardBack(title: widget.cardData.title, description: widget.cardData.description, posterPath: widget.cardData.posterPath, voteAverage: widget.cardData.voteAverage, releaseDate: widget.cardData.releaseDate, id: widget.cardData.id),
            ),
          ),
        );
      },
    );
  }
}


class CardFront extends StatelessWidget {
  final String title;

  CardFront({required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.0), // abgerundete Ecken der Karte
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: ClipRRect( // um die abgerundeten Ecken zu behalten
        borderRadius: BorderRadius.circular(15.0),
        child: Image.network(
          'https://image.tmdb.org/t/p/w500${title}',
          fit: BoxFit.cover, // das Bild so skalieren, dass es die komplette Fläche abdeckt
        ),
      ),
    );
  }
}

class CardBack extends StatefulWidget {
  final int id;
  final String title;
  final String description;
  final String posterPath;
  final double voteAverage;
  final String releaseDate;

  CardBack({required this.title, required this.description, required this.posterPath, required this.voteAverage, required this.releaseDate, required this.id });

  @override
  State<CardBack> createState() => _CardBackState();
}

class _CardBackState extends State<CardBack> {
  List<MovieExtra> movieExtra = [];

  @override
  void initState() {
    super.initState();
    //MovieService.getExtraMovieInfo(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15.0), // Abgerundete Ecken der Karte beibehalten
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Bild von der Vorderseite als Hintergrund
          Image.network(
            'https://image.tmdb.org/t/p/w500${widget.posterPath}',
            fit: BoxFit.cover,
          ),
          // Schwarze transparente Schicht
          Container(
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.9), // Schwarze transparente Farbe
            ),
          ),
          // Textinhalt zentriert auf der Karte
          Align(
            alignment: Alignment.topCenter,
            child: SingleChildScrollView(
              padding: EdgeInsets.all(20.0),
              child: Transform(
                transform: Matrix4.rotationY(math.pi), // Drehung um die Y-Achse um 180 Grad (pi Radiant)
                alignment: Alignment.center,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start, // Texte linksbündig ausrichten
                      children: [
                        Text(
                          widget.title,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8), // Platz zwischen den Texten
                        Align(
                          alignment: Alignment.centerRight, // Text rechtsbündig ausrichten
                          child: Text(
                            DateFormat('dd.MM.yyyy').format(DateTime.parse(widget.releaseDate)), // Datum im Format "dd.MM.yyyy"
                            textAlign: TextAlign.right, // Rechts ausrichten
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18.0,
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 10), // Abstand zwischen Titel und Beschreibung
                    Text(
                      widget.description,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.0,

                      ),
                    ),
                    SizedBox(height: 10), // Abstand zwischen Titel und Beschreibung

                    Text(
                      'Bewertung',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22.0,
                        fontWeight: FontWeight.bold

                      ),
                    ),
                    SizedBox(height: 10), // Abstand zwischen Titel und Beschreibung
                    DonutChart(voteAverage: widget.voteAverage),
                    SizedBox(height: 10), // Abstand zwischen Titel und Beschreibung
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}



class CardData {
  String title;
  String description;
  String posterPath;
  double voteAverage;
  String releaseDate;
  bool isFrontVisible;
  int id;

  CardData({required this.id,required this.title, required this.description, this.isFrontVisible = true, required this.posterPath, required this.voteAverage, required this.releaseDate});

  static List<CardData> fromMovies(List<Movie> movies) {
    return movies.map((movie) => CardData(
      id: movie.id,
      title: movie.title,
      description: movie.overview,
      posterPath: movie.posterPath,
      voteAverage: movie.voteAverage,
      releaseDate: movie.releaseDate,
    )).toList();
  }
}
