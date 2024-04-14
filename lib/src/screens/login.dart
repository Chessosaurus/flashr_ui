import 'package:flasher_ui/src/screens/reset_password.dart';
import 'package:flasher_ui/src/screens/signup.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

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
                      autofocus: true,
                      decoration: InputDecoration(
                        labelText: 'E-Mail',
                      ),
                    ),
                    SizedBox(height: 20),
                    TextField(
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
                      onPressed: () {
                        // Aktion für den Login Button hier einfügen
                      },
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
