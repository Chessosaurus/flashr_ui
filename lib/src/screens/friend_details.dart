import 'package:flasher_ui/src/models/user_flashr.dart';
import 'package:flasher_ui/src/services/supabase_auth_service.dart';
import 'package:flasher_ui/src/widgets/snackbarwidget.dart';
import 'package:flutter/material.dart';
import 'package:flasher_ui/src/screens/home.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../widgets/category_section.dart';

class FriendDetailPage extends StatefulWidget {
  const FriendDetailPage({Key? key}) : super(key: key);

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
        title: Text('Profil'),
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
          child: ProfileView(),
        ),
      ),
    );
  }
}


class ProfileView extends StatefulWidget {
  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  bool _isLoading = false;
  final User? user = Supabase.instance.client.auth.currentUser;

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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              MoviePoster(title: 'Lieblingsfilm 1'), // Lieblingsfilme hier einfügen
              MoviePoster(title: 'Lieblingsfilm 2'),
              MoviePoster(title: 'Lieblingsfilm 3'),
            ],
          ),
          SizedBox(height: 40),
          CategorySection(title: 'Watchlist', movies: []),
          SizedBox(height: 20),
          CategorySection(title: 'Zuletzt gesehen', movies: [])
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
