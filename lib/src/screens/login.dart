import 'package:flasher_ui/src/screens/reset_password.dart';
import 'package:flasher_ui/src/screens/signup.dart';
import 'package:flasher_ui/src/widgets/snackbarwidget.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key, required this.supabase});
  final SupabaseClient supabase;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _redirecting = false;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();


  @override
  void dispose(){
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
  @override
  void initState() {
    widget.supabase.auth.onAuthStateChange.listen((data) {
      if(_redirecting) return;
      final session = data.session;
      if(session != null) {
        _redirecting = true;
        Navigator.of(context).pushReplacementNamed('/homepage');
      }
    });
    super.initState();
  }

  Future<void> _signIn() async {
    try{
      await widget.supabase.auth.signInWithPassword(email: _emailController.text, password: _passwordController.text);
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
  }
  Future<AuthResponse> _googleSignIn() async {
    /// TODO: update the Web client ID with your own.
    ///
    /// Web Client ID that you registered with Google Cloud.
    const webClientId = '350231170936-9etbngphcacguff0vughr37st6m4gtfa.apps.googleusercontent.com';

    /// TODO: update the iOS client ID with your own.
    ///
    /// iOS Client ID that you registered with Google Cloud.
    const iosClientId = 'my-ios.apps.googleusercontent.com';

    // Google sign in on Android will work without providing the Android
    // Client ID registered on Google Cloud.

    final GoogleSignIn googleSignIn = GoogleSignIn(
      clientId: iosClientId,
      serverClientId: webClientId,
    );
    final googleUser = await googleSignIn.signIn();
    final googleAuth = await googleUser!.authentication;
    final accessToken = googleAuth.accessToken;
    final idToken = googleAuth.idToken;

    if (accessToken == null) {
      throw 'No Access Token found.';
    }
    if (idToken == null) {
      throw 'No ID Token found.';
    }

    return Supabase.instance.client.auth.signInWithIdToken(
      provider: OAuthProvider.google,
      idToken: idToken,
      accessToken: accessToken,
    );
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
                    Image.asset('assets/logo/flashr_logo.png', width: 200),
                    SizedBox(height: 100),
                    Text(
                      'Anmelden',
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
                    SizedBox(height: 10),
                    Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: () {
                          _navigateToResetPassword(context);
                        },
                        child: Text(
                          'Passwort vergessen',
                          style: TextStyle(fontSize: 12, color: Color(0xFFF31531)),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                        onPressed: _googleSignIn,
                        child: const Text('Google login')
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _signIn,
                      child: Text('Log In'),
                    ),
                    SizedBox(height: 30),
                    Row(
                      mainAxisAlignment:  MainAxisAlignment.center,
                      children: [
                        Text(
                          'Sie haben noch keinen Account? ',
                          style: TextStyle(fontSize: 14),
                          textAlign: TextAlign.center,
                        ),
                        GestureDetector(
                          onTap: () {
                            _navigateToSignUp(context);
                          },
                          child: Text(
                            ' Sign Up',
                            style: TextStyle(fontSize: 14, color: Color(0xFFF31531)),
                            textAlign: TextAlign.center,
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToResetPassword(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ResetPassword()),
    );
  }

  void _navigateToSignUp(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Signup()),
    );
  }
}
