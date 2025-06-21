import 'package:basic_chat_app/data/services/token_storage_service.dart';
import 'package:basic_chat_app/feature/qr/widget/scan_qr_page.dart';
import 'package:flutter/material.dart';

class PairingPage extends StatefulWidget {
  const PairingPage({super.key});

  @override
  State<PairingPage> createState() => _PairingPageState();
}

class _PairingPageState extends State<PairingPage> {
  String? scannedToken;

  void handleScannedToken(String token) async {
    await TokenStorageService().saveToken(token);
    setState(() {
      scannedToken = token;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Pair Device")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(scannedToken == null
                ? 'No device paired yet.'
                : 'Paired with:\n$scannedToken'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ScanQrPage(onScanComplete: handleScannedToken),
                  ),
                );
              },
              child: const Text("Scan QR Code"),
            ),
          ],
        ),
      ),
    );
  }
}
