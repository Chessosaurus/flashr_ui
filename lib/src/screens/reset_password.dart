import 'package:flutter/material.dart';

class ResetPassword extends StatelessWidget {
  const ResetPassword({super.key});

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
                      'Passwort zurücksetzen',
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
                    ElevatedButton(
                      onPressed: () {
                        // Aktion für den Reset-Button hier einfügen
                      },
                      child: Text('Passwort zurücksetzen'),
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
