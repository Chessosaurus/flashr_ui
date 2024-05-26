import 'dart:async';
import 'dart:convert';
import 'package:flasher_ui/src/models/movie_extra.dart';
import 'package:flasher_ui/src/widgets/donut_chart.dart';
import 'package:flasher_ui/src/widgets/header.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math;
import '../models/filter.dart';
import '../models/media.dart';
import '../models/media_extra.dart';
import '../models/movie.dart';
import '../models/tv.dart';
import '../services/movie_service.dart';
import '../services/tv_service.dart';
import '../widgets/navbar.dart';

class MovieSwipe extends StatefulWidget {
  const MovieSwipe({Key? key}) : super(key: key);

  @override
  State<MovieSwipe> createState() => _MovieSwipeState();
}

class _MovieSwipeState extends State<MovieSwipe>
    with SingleTickerProviderStateMixin {
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
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    fetchMediaCards();
  }

  Future<void> fetchMediaCards() async {
    try {
      final filterModel = Provider.of<FilterModel>(context);

      if (filterModel.selectedFilter == FilterType.movies) {
        final movies = await MovieService.fetchSwipeMovieRecommendation(10);
        setState(() {
          cards = CardData.fromMedia(movies.cast<Media>());
        });
      } else {
        final tvShows = await TvService.fetchSwipeTvRecommendation(10);
        setState(() {
          cards = CardData.fromMedia(tvShows.cast<Media>());
        });
      }
    } catch (e) {
      print('Failed to fetch media recommendations: $e');
    }
  }

  Future<void> _setMovieStatusUninterested(Media mediaItem) async {
    try {
      if (mediaItem is Movie) {
        await MovieService.setMovieStatusUninterested(mediaItem.id);
      } else if (mediaItem is Tv) {
        await TvService.setTVStatusUninterested(mediaItem.id);
      }
    } on Exception catch (error) {
      _handleError('Fehler beim Setzen des Status auf "Uninteressiert"', error);
    }
  }

  Future<void> _setMovieStatusInterested(Media mediaItem) async {
    try {
      if (mediaItem is Movie) {
        await MovieService.setMovieStatusInterested(mediaItem.id);
      } else if (mediaItem is Tv) {
        await TvService.setTVStatusInterested(mediaItem.id);
      }
    } on Exception catch (error) {
      _handleError('Fehler beim Setzen des Status auf "Interessiert"', error);
    }
  }

  Future<void> _setMovieStatusWatched(Media mediaItem) async {
    try {
      if (mediaItem is Movie) {
        await MovieService.setMovieStatusWatched(mediaItem.id);
      } else if (mediaItem is Tv) {
        await TvService.setTVStatusWatched(mediaItem.id);
      }
    } on Exception catch (error) {
      _handleError('Fehler beim Setzen des Status auf "Gesehen"', error);
    }
  }

  void _handleError(String message, Exception error) {
    print('$message: $error');
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
    final filterModel = Provider.of<FilterModel>(context);
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
              children: cards.asMap().entries.map((entry) {
                int index = entry.key;
                CardData card = entry.value;
                return DraggableCard(
                  cardData: card,
                  onSwipe: () {
                    setState(() {
                      cards.removeAt(
                          index); // Karte an bestimmtem Index entfernen
                      if (cards.length < 3) {
                        // Wenn weniger als 5 Karten übrig sind
                        fetchMediaCards(); // Neue Karten laden
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
                  zIndex: (cards.length - index).toDouble(),
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
                          _setMovieStatusUninterested(
                              cards.removeLast().mediaItem);
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        fixedSize: Size.fromHeight(40),
                      ),
                      child: const Text(
                        'Nicht interessiert',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _setMovieStatusInterested(
                              cards.removeLast().mediaItem);
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
                          _setMovieStatusWatched(cards.removeLast().mediaItem);
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
              ))
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

  Future<void> _setMovieStatusUninterested(int mediaId) async {
    try {
      final mediaItem = widget.cardData.mediaItem;
      if (mediaItem is Movie) {
        await MovieService.setMovieStatusUninterested(mediaId);
      } else if (mediaItem is Tv) {
        await TvService.setTVStatusUninterested(mediaId);
      }
    } on Exception catch (error) {
      _handleError('Fehler beim Setzen des Status auf "Uninteressiert"', error);
    }
  }

  Future<void> _setMovieStatusInterested(int mediaId) async {
    try {
      final mediaItem = widget.cardData.mediaItem;
      if (mediaItem is Movie) {
        await MovieService.setMovieStatusInterested(mediaId);
      } else if (mediaItem is Tv) {
        await TvService.setTVStatusInterested(mediaId);
      }
    } on Exception catch (error) {
      _handleError('Fehler beim Setzen des Status auf "Interessiert"', error);
    }
  }

  Future<void> _setMovieStatusWatched(int mediaId) async {
    try {
      final mediaItem = widget.cardData.mediaItem;
      if (mediaItem is Movie) {
        await MovieService.setMovieStatusWatched(mediaId);
      } else if (mediaItem is Tv) {
        await TvService.setTVStatusWatched(mediaId);
      }
    } on Exception catch (error) {
      _handleError('Fehler beim Setzen des Status auf "Gesehen"', error);
    }
  }

  void _handleError(String message, Exception error) {
    print('$message: $error');
  }

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
              if (widget.cardData.isFrontVisible) {
                _position += details
                    .delta; // Aktualisiere die Position basierend auf der Verschiebung
                double deltaX = _position.dx - _startPosition.dx;

                // Berechne den Abstand der Karte zur Bildschirmmitte
                double distanceToCenter =
                    (_position.dx + screenWidth / 2) - screenCenterX;

                // Berechne den maximalen Neigungswinkel basierend auf der Distanz zur Mitte
                double maxRotationAngle = math.pi / 8;
                double normalizedDistance =
                    distanceToCenter / (screenWidth / 2);
                _rotationAngle = normalizedDistance * maxRotationAngle;
              }
            });
          },
          onPanEnd: (details) {
            double deltaX1 = _position.dx - _startPosition.dx;
            double deltaX2 = _startPosition.dx - _position.dx;
            double deltaY = _startPosition.dy - _position.dy;
            if (widget.cardData.isFrontVisible && deltaX1 > 100) {
              //Überprüfung auf Rechts-Swipe
              widget.onSwipe();
              _setMovieStatusWatched(widget.cardData.mediaItem.id);
              print("rechts");
            } else if (widget.cardData.isFrontVisible && deltaX2 > 350) {
              //Überprüfung auf Links-Swipe
              widget.onSwipe();
              _setMovieStatusUninterested(widget.cardData.mediaItem.id);
              print("links");
            } else if (widget.cardData.isFrontVisible && deltaY > 700) {
              //Überprüfung auf Oben-Swipe
              widget.onSwipe();
              _setMovieStatusInterested(widget.cardData.mediaItem.id);
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
                    angle:
                        _rotationAngle, // Dynamisch berechneter Neigungswinkel
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
                    ? CardFront(title: widget.cardData.mediaItem.posterPath)
                    : CardBack(mediaItem: widget.cardData.mediaItem)),
          ),
        );
      },
    );
  }
}

class CardFront extends StatelessWidget {
  final String? title;

  CardFront({required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius:
            BorderRadius.circular(15.0), // abgerundete Ecken der Karte
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: ClipRRect(
        // um die abgerundeten Ecken zu behalten
        borderRadius: BorderRadius.circular(15.0),
        child: Image.network(
          'https://image.tmdb.org/t/p/w500${title}',
          fit: BoxFit
              .cover, // das Bild so skalieren, dass es die komplette Fläche abdeckt
        ),
      ),
    );
  }
}

class CardBack extends StatefulWidget {
  final Media mediaItem;

  const CardBack({Key? key, required this.mediaItem}) : super(key: key);

  @override
  State<CardBack> createState() => _CardBackState();
}

class _CardBackState extends State<CardBack> {
  late Future<MediaExtra> mediaExtra;

  @override
  void initState() {
    super.initState();
    // Überprüfen, ob es sich um einen Film handelt
    if (widget.mediaItem is Movie) {
      mediaExtra = MovieService.getExtraMovieInfo(widget.mediaItem.id);
    } else if (widget.mediaItem is Tv) {
      mediaExtra = TvService.getExtraTvInfo(widget.mediaItem.id);
    } else {
      mediaExtra = Future.value(MovieExtra(
        runtime: 0,
        releaseDate: '',
        watchProviderLink: '',
        flatrate: [],
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15.0),
      child: FutureBuilder<MediaExtra>(
        future: mediaExtra,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: CircularProgressIndicator()); // Ladeanzeige
          } else if (snapshot.hasError) {
            return Center(
                child: Text('Fehler: ${snapshot.error}')); // Fehleranzeige
          } else {
            final mediaExtra = snapshot.data!; // Extrahiere MediaExtra-Daten

            return LayoutBuilder(
              builder: (contex, constraints) {
                return Stack(
                  fit: StackFit.expand,
                  children: [
                    // Bild von der Vorderseite als Hintergrund
                    Image.network(
                      'https://image.tmdb.org/t/p/w500${widget.mediaItem.posterPath}',
                      fit: BoxFit.cover,
                    ),
                    // Schwarze transparente Schicht
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.9),
                      ),
                    ),
                    // Textinhalt zentriert auf der Karte
                    Align(
                      alignment: Alignment.topCenter,
                      child: SizedBox(
                        height: constraints.maxHeight - 40,
                        child: SingleChildScrollView(
                          padding: EdgeInsets.all(20.0),
                          child: Transform(
                            transform: Matrix4.rotationY(math.pi),
                            alignment: Alignment.center,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      widget.mediaItem.title,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 28,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(
                                        height: 8), // Platz zwischen den Texten
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            '${mediaExtra.runtime} min',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18.0,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Align(
                                            alignment: Alignment.centerRight,
                                            child: Text(
                                              DateFormat('dd.MM.yyyy').format(
                                                  DateTime.parse(
                                                      mediaExtra.releaseDate)),
                                              textAlign: TextAlign.right,
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 18.0,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10),
                                // Abstand zwischen Titel und Beschreibung
                                Text(
                                  widget.mediaItem.overview,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18.0,
                                  ),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  'Bewertung',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 22.0,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 10),
                                // Abstand zwischen Titel und Beschreibung
                                DonutChart(
                                    voteAverage: widget.mediaItem.voteAverage),
                                SizedBox(height: 10),
                                Text(
                                  mediaExtra.watchProviderLink,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18.0,
                                  ),
                                ),
                                if (mediaExtra.flatrate != null)
                                  Row(
                                    children: mediaExtra.flatrate!
                                        .map((providerData) {
                                      return Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          // Spalte für Logo und Namen
                                          children: [
                                            Image.network(
                                              'https://image.tmdb.org/t/p/w500${providerData['logo_path']}',
                                              fit: BoxFit.cover,
                                              height:
                                                  50, // Begrenze die Höhe des Logos
                                            ),
                                            SizedBox(
                                                height:
                                                    4), // Abstand zwischen Logo und Name
                                            Text(providerData[
                                                'provider_name']), // Anbietername
                                          ],
                                        ),
                                      );
                                    }).toList(),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            );
          }
        },
      ),
    );
  }
}

class CardData {
  String? posterPath; // Jetzt optional
  bool isFrontVisible;
  Media mediaItem;
  // Jetzt Media-Objekt

  CardData({required this.mediaItem, this.isFrontVisible = true});

  static List<CardData> fromMedia(List<Media> mediaList) {
    return mediaList.map((media) => CardData(mediaItem: media)).toList();
  }
}
