import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QRScanPage extends StatefulWidget {
  const QRScanPage({super.key});

  @override
  State<QRScanPage> createState() => _QRScanPageState();
}

class _QRScanPageState extends State<QRScanPage> {
  final MobileScannerController _controller = MobileScannerController();
  String? scannedToken;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onDetect(BarcodeCapture capture) {
    final Barcode? barcode = capture.barcodes.first;
    final String? code = barcode?.rawValue;
    if (code != null && scannedToken == null) {
      setState(() => scannedToken = code);
      _controller.stop(); // Optional: stop scanning after first result
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          MobileScanner(
            controller: _controller,
            onDetect: _onDetect,
          ),
          if (scannedToken != null)
            Positioned(
              bottom: 40,
              child: Container(
                padding: const EdgeInsets.all(12),
                color: Colors.black.withOpacity(0.7),
                child: Text(
                  'Scanned: $scannedToken',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
