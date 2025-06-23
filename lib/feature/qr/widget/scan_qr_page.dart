// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:basic_chat_app/core/widgets/custom_appbar.dart';
import 'package:basic_chat_app/data/models/user_model.dart';
import 'package:basic_chat_app/data/services/paired_user_storage_service.dart';
import 'package:basic_chat_app/main_navigation_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class ScanQrPage extends ConsumerStatefulWidget {
  final void Function(UserModel)? onScanComplete;
  const ScanQrPage({super.key, this.onScanComplete});

  @override
  ConsumerState<ScanQrPage> createState() => _ScanQrPageState();
}
class _ScanQrPageState extends ConsumerState<ScanQrPage> {
  bool _isScanned = false;

  void _handleScan(String code) async {
    if (_isScanned) return;
    _isScanned = true;

    try {
      final json = jsonDecode(code);
      final user = UserModel.fromJson(json);

      // Use ref here safely
       await PairedUserStorageService().addUser(user);

      if (context.mounted) {
        widget.onScanComplete?.call(user);
        Navigator.pop(context);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const MainNavigationPage()),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Invalid QR Code")),
        );
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Scan QR Code",
         onBack: () =>  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const MainNavigationPage()),
                  ),
      
      ),
      body: MobileScanner(
        controller: MobileScannerController(),
        onDetect: (barcode) {
          final code = barcode.barcodes[0].displayValue;
          if (code != null) _handleScan(code);
        },
      ),
    );
  }
}
