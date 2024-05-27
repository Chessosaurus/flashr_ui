import 'package:flutter/material.dart';
import '../models/friend.dart';
import '../models/movie.dart';
import '../services/movie_service.dart';
import '../widgets/category_section.dart';

class FriendDetailPage extends StatefulWidget {
  final Friend friend;
  const FriendDetailPage({Key? key, required this.friend}) : super(key: key);

  @override
  State<FriendDetailPage> createState() => _FriendDetailPageState();
}

class _FriendDetailPageState extends State<FriendDetailPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profil von ' + widget.friend.friendName),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pushReplacementNamed('/slide_to_friends');
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: FriendView(friend: widget.friend),
        ),
      ),
    );
  }
}


class FriendView extends StatefulWidget {
  final Friend friend;
  const FriendView({Key? key, required this.friend}) : super(key: key);

  @override
  State<FriendView> createState() => _FriendViewState();
}

class _FriendViewState extends State<FriendView> {
  late Future<List<Movie>> watchlist;
  late Future<List<Movie>> recentlyWatchedList;
  late Future<List<Movie>> favoriteList;

  @override
  void initState() {
    super.initState();
    watchlist = MovieService.fetchMovieWatchlistofFriend(widget.friend.friendId);
    recentlyWatchedList = MovieService.fetchRecentlyWatchedMoviesofFriend(widget.friend.friendId);
    favoriteList = MovieService.fetchFavoriteMoviesOfFriend(widget.friend.friendId);
  }

  @override
  Widget build(BuildContext context) {

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 80,
            backgroundImage: AssetImage('assets/logo/flashr_logo.png'),
          ),
          SizedBox(height: 20),
          Text(
            style: TextStyle(fontSize: 18),
            "Favoriten von " + widget.friend.friendName
          ),
          SizedBox(height: 20),
          FutureBuilder<List<Movie>>(
            future: favoriteList,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                return CategorySection(
                  title: 'Favoriten',
                  media: snapshot.data!,
                );
              }
            },
          ),
          SizedBox(height: 40),
          FutureBuilder<List<Movie>>(
            future: watchlist,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                return CategorySection(
                  title: 'Seine Watchlist',
                  media: snapshot.data!,
                );
              }
            },
          ),
          SizedBox(height: 20),
          FutureBuilder<List<Movie>>(
            future: recentlyWatchedList,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                return CategorySection(
                  title: 'Zuletzt gesehen',
                  media: snapshot.data!,
                );
              }
            },
          ),
        ],
      ),
    );
  }
}

//Platzhalter
class MoviePoster extends StatelessWidget {
  final String title;

  MoviePoster({required this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 120,
          height: 180,
          color: Colors.grey,
        ),
      ],
    );
  }
}
