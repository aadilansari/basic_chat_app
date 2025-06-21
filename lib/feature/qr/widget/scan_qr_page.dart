import 'dart:convert';
import 'package:basic_chat_app/data/models/user_model.dart';
import 'package:basic_chat_app/data/services/paired_user_storage_service.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class ScanQrPage extends StatefulWidget {
  final void Function(UserModel)? onScanComplete;
  const ScanQrPage({super.key, this.onScanComplete});

  @override
  State<ScanQrPage> createState() => _ScanQrPageState();
}

class _ScanQrPageState extends State<ScanQrPage> {
  bool _isScanned = false;

  void _handleScan(String code) async {
    if (_isScanned) return;
    _isScanned = true;

    try {
      final json = jsonDecode(code);
      final user = UserModel.fromJson(json);

      await PairedUserStorageService().addUser(user);

      if (context.mounted) {
        widget.onScanComplete?.call(user); // Pass back user 💡
        Navigator.pop(context);
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Invalid QR Code")));
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Scan QR Code")),
      body: MobileScanner(
        controller: MobileScannerController(),
        onDetect: (barcode) {
          final code = barcode.raw.toString();
          if (code != null) _handleScan(code);
        },
      ),
    );
  }
}
