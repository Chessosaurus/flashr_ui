import 'package:flasher_ui/src/services/friends_service.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../services/supabase_auth_service.dart';

class QRScreens extends StatefulWidget {
  @override
  _QRScreensState createState() => _QRScreensState();
}

class _QRScreensState extends State<QRScreens> {
  int _currentIndex = 0; // Start auf der ersten Seite ("Freunde")

  final List<Widget> _pages = [
    QRCodeDisplayPage(), // Seite zum Anzeigen des QR-Codes
    QRCodeGeneratorPage(), // Seite zum Generieren des QR-Codes
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('QR-Code Freundescodes')),
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
            backgroundColor: _currentIndex == 0 ? Colors.redAccent : Colors.grey,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.qr_code),
            label: 'QR Code',
            backgroundColor: _currentIndex == 1 ? Colors.redAccent : Colors.grey,
          ),
        ],
      ),
    );
  }
}

class QRCodeGeneratorPage extends StatefulWidget {
  @override
  _QRCodeGeneratorPageState createState() => _QRCodeGeneratorPageState();
}

class _QRCodeGeneratorPageState extends State<QRCodeGeneratorPage> {
  String _qrData = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              onChanged: (value) {
                setState(() {
                  _qrData = value;
                });
              },
              decoration: InputDecoration(
                hintText: 'Freundescode eingeben',
              ),
            ),
            SizedBox(height: 20), // Oder ein Platzhalter-Widget anzeigen
          ],
        ),
      ),
    );
  }
}



class QRCodeDisplayPage extends StatefulWidget {
  @override
  _QRCodeDisplayPageState createState() => _QRCodeDisplayPageState();
}

class _QRCodeDisplayPageState extends State<QRCodeDisplayPage> {
  MobileScannerController cameraController = MobileScannerController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MobileScanner(
          controller: cameraController,
          onDetect: (capture) { // Only one argument now
            final List<Barcode> barcodes = capture.barcodes;
            final barcode = barcodes.first;
            if (barcode.rawValue == null) {
              debugPrint('Failed to scan QRCode');
            } else {
              final String code = barcode.rawValue!;
              debugPrint('QRCode found! $code');

              try {
                int friendId = int.parse(code);
                FriendsService.requestFriendship(friendId); // Call the method defined below
              } catch (e) {
                debugPrint('Invalid QR Code: $e');
              }
            }
          }),
    );
  }

}