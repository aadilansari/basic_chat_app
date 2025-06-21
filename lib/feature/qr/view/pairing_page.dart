import 'package:basic_chat_app/feature/qr/widget/scan_qr_page.dart';
import 'package:flutter/material.dart';
import '../../../data/services/token_storage_service.dart';

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
  void initState() {
    super.initState();
    _loadExistingToken();
  }

  Future<void> _loadExistingToken() async {
    final saved = await TokenStorageService().getToken();
    setState(() {
      scannedToken = saved;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pair Device')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              scannedToken == null
                  ? 'No device paired yet.'
                  : 'Paired with:\n$scannedToken',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              icon: const Icon(Icons.qr_code_scanner),
              label: const Text("Scan Partner QR Code"),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ScanQrPage(onScanComplete: handleScannedToken),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
