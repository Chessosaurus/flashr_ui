import 'package:flasher_ui/src/screens/home.dart';
import 'package:flasher_ui/src/services/supabase_auth_service.dart';
import 'package:flasher_ui/src/widgets/snackbarwidget.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final SupabaseAuthService _auth = SupabaseAuthService();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _redirecting = false;


  Future<void> _signUp() async {
   if (_emailController.text.isNotEmpty && _passwordController.text.isNotEmpty && _usernameController.text.isNotEmpty){
     try{
       final newUser = await _auth.signUpWithEmailAndPassword(email: _emailController.text, password: _passwordController.text, username: _usernameController.text);
        if (mounted) {
          _emailController.clear();
          _passwordController.clear();
          _redirecting = true;
          Navigator.of(context).pushReplacementNamed('/homepage');
        }
     } on AuthException catch (error) {
       context.showErrorSnackBar(message: error.message);
     } catch (error) {
       context.showErrorSnackBar(message: "Unexpected error occurred");
     }
    } else {
      showDialog(context: context, builder: (context){
        return AlertDialog(
          content: Text("No Input"),
        );
      });
    }

  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 3,
              child: Container(
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset('logo/flashr_logo.png', width: 200),
                    SizedBox(height: 100),
                    Text(
                      'Registrieren',
                      style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 4,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextField(
                      controller: _usernameController,
                      autofocus: true,
                      decoration: InputDecoration(
                        labelText: 'Username',
                      ),
                    ),
                    SizedBox(height: 20),
                    TextField(
                      controller: _emailController,
                      autofocus: true,
                      decoration: InputDecoration(
                        labelText: 'E-Mail',
                      ),
                    ),
                    SizedBox(height: 20),
                    TextField(
                      controller: _passwordController,
                      autofocus: true,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Passwort',
                      ),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _signUp,
                      child: Text('Sign Up'),
                    ),
                    SizedBox(height: 30),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context); // Zurück zur vorherigen Seite
                      },
                      child: Text(
                        'Zurück zum Login',
                        style: TextStyle(fontSize: 14),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
