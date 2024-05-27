import 'package:flasher_ui/src/models/user_flashr.dart';
import 'package:flasher_ui/src/services/friends_service.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';

import '../services/supabase_auth_service.dart';

class QRScreens extends StatefulWidget {
  @override
  _QRScreensState createState() => _QRScreensState();
}

class _QRScreensState extends State<QRScreens> {
  int _currentIndex = 0;
  UserFlashr? user;
  String? userId;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final fetchedUser = await SupabaseAuthService().user;
    String? uuid = fetchedUser?.userUuid;

    if (uuid != null) {
      try {
        int userIdTemp = await SupabaseAuthService().getUserId(uuid);
        setState(() {
          user = fetchedUser;
          userId = userIdTemp.toString();
        });
      } catch (e) {
        debugPrint('Error fetching userId: $e');
        // Handle the error (e.g., show a Snackbar)
      }
    }
  }


    @override
    Widget build(BuildContext context) {
      final _pages = [
        QRCodeDisplayPage(user),
        QRCodeGeneratorPage(userId: userId),
      ];
      return Scaffold(
        appBar: AppBar(
            title: Text('QR-Freundescodes'),
            centerTitle: true,
              leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.of(context).pushReplacementNamed('/friends');
                },
              ),
            ),
        body: _pages[_currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.qr_code_scanner),
              label: 'Scannen',
              backgroundColor: _currentIndex == 0
                  ? Theme.of(context).colorScheme.primary
                  : Colors.grey,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.qr_code),
              label: 'QR Code',
              backgroundColor: _currentIndex == 1
                  ? Theme.of(context).colorScheme.primary
                  : Colors.grey,
            ),
          ],
          selectedItemColor: Theme.of(context).colorScheme.primary,
          unselectedItemColor: Colors.grey,
        ),
      );
    }
  }

class QRCodeGeneratorPage extends StatelessWidget {
  final String? userId;

  const QRCodeGeneratorPage({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('QR-Code Generator')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (userId != null) ...[
                // QR Code using qr_flutter
                QrImageView(
                  data: userId!,
                  version: QrVersions.auto,
                  size: 300.0,
                  backgroundColor: Colors.white,
                  embeddedImageStyle: const QrEmbeddedImageStyle(
                    size: Size(100, 100),
                  ),
                ),
                const SizedBox(height: 24),
              ] else
                const CircularProgressIndicator(),
            ],
          ),
        ),
      ),
    );
  }
}



class QRCodeDisplayPage extends StatefulWidget {
  final UserFlashr? user;
  QRCodeDisplayPage(this.user, {super.key});

  @override
  _QRCodeDisplayPageState createState() => _QRCodeDisplayPageState();
}

class _QRCodeDisplayPageState extends State<QRCodeDisplayPage> {
  MobileScannerController cameraController = MobileScannerController();
  bool hasSentRequest = false; // Flag, um zu verfolgen, ob eine Anfrage gesendet wurde


  Future<void> _sendFriendRequest(int? userId) async {
    if (hasSentRequest) return; // Anfrage nicht erneut senden
    setState(() => hasSentRequest = true); // Flag setzen

    try {
      await FriendsService.requestFriendship(userId); // Overlay schließen nach erfolgreicher Erstellung
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Benutzer wurde eine Freundschaftsanfrage gesendet!')),
      );
      cameraController.stop();
    } catch (e) {
      print('Fehler beim Senden einer Freundschaftsanfrage: $e');
      showDialog(
        context: context,
        builder: (context) =>
            AlertDialog(
              title: Text('Fehler'),
              content: Text(
                  'Dem Benutzer konnte keine Freundschaftsanfrage gesendet werden.'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('OK'),
                ),
              ],
            ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('QR Scanner')),
      body: MobileScanner(
        controller: cameraController, // Controller hinzufügen
        onDetect: (capture) {
          final List<Barcode> barcodes = capture.barcodes;
          for (final barcode in barcodes) {
            final rawValue = barcode.rawValue;
            if (rawValue != null) {
              try {
                final userId = int.parse(rawValue);
                _sendFriendRequest(userId);
              } catch (e) {
                print('Fehler beim Parsen der User ID: $e');
                // Optional: Fehlermeldung für ungültigen QR-Code anzeigen
              }
            }
          }
        },
      ),
    );
  }
}