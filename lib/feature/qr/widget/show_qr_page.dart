import 'dart:convert';
import 'package:basic_chat_app/feature/auth/viewmodel/auth_viewmodel.dart';
import 'package:basic_chat_app/feature/qr/view/pairing_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qr_flutter/qr_flutter.dart';


class ShowQrPage extends ConsumerWidget {
  const ShowQrPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('QR Actions')),
      body: user == null
          ? const Center(child: Text("Please log in first"))
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Your QR Code (includes name/email/token)"),
                  const SizedBox(height: 16),
                  QrImageView(
                    data: jsonEncode(user.toJson()), // 👈 full user info
                    size: 250,
                    version: QrVersions.auto,
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.qr_code_scanner),
                    label: const Text("Scan to Pair with User"),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const PairingPage(),
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
