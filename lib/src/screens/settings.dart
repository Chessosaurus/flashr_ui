import 'package:flasher_ui/src/services/supabase_auth_service.dart';
import 'package:flasher_ui/src/widgets/snackbarwidget.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Settings extends StatefulWidget {
  const Settings ({Key? key}) : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
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
        title: Text('Einstellungen'),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            _navigateBack(context);
          },
        ),
        actions: [
          IconButton(
              icon: Icon(Icons.logout),
              onPressed:  _signOut
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Allgemein',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              ListTile(
                title: Text('Sprache'),
                trailing: Icon(Icons.language),
                onTap: () {
                },
              ),
              ListTile(
                title: Text('Benachrichtigungen'),
                trailing: Icon(Icons.notifications),
                onTap: () {
                },
              ),
              SizedBox(height: 20),
              Text(
                'Konto',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              ListTile(
                title: Text('Profil bearbeiten'),
                trailing: Icon(Icons.edit),
                onTap: () {
                },
              ),
              ListTile(
                title: Text('Passwort ändern'),
                trailing: Icon(Icons.lock),
                onTap: () {
                },
              ),
              ListTile(
                title: Text('Konto löschen'),
                trailing: Icon(Icons.delete),
                onTap: () {
                },
              ),
              SizedBox(height: 40),
              Center(
                child: Image.asset(
                  'images/tmdb.png',
                  width: MediaQuery.of(context).size.height * 0.15,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateBack(BuildContext context) {
    Navigator.of(context).pushReplacementNamed('/profile');
  }
}

