import 'package:flasher_ui/src/models/user_flashr.dart';
import 'package:flasher_ui/src/services/supabase_auth_service.dart';
import 'package:flasher_ui/src/widgets/snackbarwidget.dart';
import 'package:flasher_ui/src/widgets/swipe_card.dart';
import 'package:flutter/material.dart';
import 'package:flasher_ui/src/screens/home.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
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
        title: Text('Filmtitel'),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            // Implementiere die Zurück-Funktion hier
            _navigateBack(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
            child: Text('Test'),
          ),
        ),
      );
  }

  void _navigateBack(BuildContext context) {
    Navigator.of(context).pushReplacementNamed('/homepage');
  }
}

