import 'package:flasher_ui/src/models/user_flashr.dart';
import 'package:flasher_ui/src/services/supabase_auth_service.dart';
import 'package:flasher_ui/src/widgets/snackbarwidget.dart';
import 'package:flutter/material.dart';
import 'package:flasher_ui/src/screens/home.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/movie.dart';
import '../services/movie_service.dart';
import '../widgets/category_section.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _auth = SupabaseAuthService();

  Future<void> _signOut() async {
    try{
      await _auth.signOut();
      if (mounted) {
        Navigator.of(context).pushReplacementNamed('/login');
      }
    } on AuthException catch (error) {
      context.showErrorSnackBar(message: error.message);
    } catch (error) {
      context.showErrorSnackBar(message: "Unexpected error occurred");
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profil'),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            // Implementiere die Zurück-Funktion hier
            _navigateBack(context);
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed:  (){
              _navigateToSettings(context);
            }
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: ProfileView(),
        ),
      ),
    );
  }

  void _navigateBack(BuildContext context) {
    Navigator.of(context).pushReplacementNamed('/slide_to_home');
  }
}

void _navigateToSettings(BuildContext context) {
  Navigator.of(context).pushReplacementNamed('/settings');
}

class ProfileView extends StatefulWidget {
  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  bool _isLoading = false;
  final User? user = Supabase.instance.client.auth.currentUser;
  late Future<List<Movie>> watchlist;
  late Future<List<Movie>> recentlyWatchedList;

  late Future<List<Movie>> favoriteList;
  @override
  void initState() {
    super.initState();
    watchlist = MovieService.fetchMovieWatchlist();
    recentlyWatchedList = MovieService.fetchRecentlyWatchedMovies();
    favoriteList = MovieService.fetchMovieFavorite();
  }

  @override
  Widget build(BuildContext context) {

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 80,
            backgroundImage: AssetImage('assets/logo/flashr_logo.png'), // Profilbild hier einfügen
          ),
          SizedBox(height: 20),
          Text(
            style: TextStyle(fontSize: 18), // Benutzername hier einfügen
            user?.userMetadata?["username"] != null ? user!.userMetadata!['username'].toString(): "not defined",
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
                  title: 'Deine Watchlist',
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
          color: Colors.grey, // Platzhalterfarbe für Filmplakat
        ),
      ],
    );
  }
}

