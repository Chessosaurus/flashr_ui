import 'dart:async';
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
  List<CardData> cards = [];
  static const int thresholdToFetchMore = 1;

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
    if (!mounted) return;
    try {
      final filterModel = Provider.of<FilterModel>(context, listen: false);

      if (filterModel.selectedFilter == FilterType.movies) {
        final movies = await MovieService.fetchSwipeMovieRecommendation(10);
        if (mounted) {
          setState(() {
            cards.addAll(CardData.fromMedia(movies.cast<Media>()));
          });
        }
      } else {
        final tvShows = await TvService.fetchSwipeTvRecommendation(10);
        if (mounted) {
          setState(() {
            cards.addAll(CardData.fromMedia(tvShows.cast<Media>()));
          });
        }
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
    switch (index) {
      case 0:
        Navigator.of(context).pushReplacementNamed('/homepage');
        break;
      case 1:
        Navigator.of(context).pushReplacementNamed('/movieswipe');
        break;
      case 2:
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
                      cards.removeAt(index);
                      if (cards.length <= thresholdToFetchMore) {
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
                  zIndex: (cards.length - index).toDouble(), // Stelle die Karten im Stapel dar
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
                      },
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
                      },
                      style: ElevatedButton.styleFrom(
                        fixedSize: const Size.fromHeight(40),
                      ),
                      child: const Text('Gesehen'),
                    ),
                  ),
                  const SizedBox(width: 8),
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
  final double zIndex;

  DraggableCard({
    required this.cardData,
    required this.onSwipe,
    required this.onTap,
    required this.controller,
    required this.zIndex,
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
          onPanEnd: (details) async {
            double deltaX1 = _position.dx - _startPosition.dx;
            double deltaX2 = _startPosition.dx - _position.dx;
            double deltaY = _startPosition.dy - _position.dy;
            if (widget.cardData.isFrontVisible && deltaX1 > 100) {
              //Überprüfung auf Rechts-Swipe
              await _setMovieStatusWatched(widget.cardData.mediaItem.id);
              widget.onSwipe();
              print("rechts");
            } else if (widget.cardData.isFrontVisible && deltaX2 > 350) {
              //Überprüfung auf Links-Swipe
              await _setMovieStatusUninterested(widget.cardData.mediaItem.id);
              widget.onSwipe();
              print("links");
            } else if (widget.cardData.isFrontVisible && deltaY > 700) {
              //Überprüfung auf Oben-Swipe
              await _setMovieStatusInterested(widget.cardData.mediaItem.id);
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
            BorderRadius.circular(15.0),
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
        borderRadius: BorderRadius.circular(15.0),
        child: Image.network(
          'https://image.tmdb.org/t/p/w500${title}',
          fit: BoxFit
              .cover,
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
                child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
                child: Text('Fehler: ${snapshot.error}'));
          } else {
            final mediaExtra = snapshot.data!;

            return LayoutBuilder(
              builder: (contex, constraints) {
                return Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.network(
                      'https://image.tmdb.org/t/p/w500${widget.mediaItem.posterPath}',
                      fit: BoxFit.cover,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.9),
                      ),
                    ),
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
                                        height: 8),
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
                                DonutChart(
                                    voteAverage: widget.mediaItem.voteAverage),
                                SizedBox(height: 20),
                                Text(
                                  'Streaminganbieter',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 22.0,
                                      fontWeight: FontWeight.bold),
                                ),
                                if (mediaExtra.flatrate != null)
                                  Center(
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: mediaExtra.flatrate!
                                            .map((providerData) {
                                          return Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              children: [
                                                Image.network(
                                                  'https://image.tmdb.org/t/p/w500${providerData['logo_path']}',
                                                  fit: BoxFit.cover,
                                                  height: 50,
                                                ),
                                                SizedBox(height: 4),
                                                Text(providerData['provider_name']),
                                              ],
                                            ),
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                  )
                                else
                                  Center(
                                    child: Text('Keine Streaminganbieter gefunden'),
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
  String? posterPath;
  bool isFrontVisible;
  Media mediaItem;

  CardData({required this.mediaItem, this.isFrontVisible = true});

  static List<CardData> fromMedia(List<Media> mediaList) {
    return mediaList.map((media) => CardData(mediaItem: media)).toList();
  }
}
