import 'package:basic_chat_app/data/services/paired_user_storage_service.dart';
import 'package:basic_chat_app/feature/qr/widget/scan_qr_page.dart';
import 'package:flutter/material.dart';
import 'package:basic_chat_app/core/localization/app_localization.dart';
import 'package:basic_chat_app/data/models/user_model.dart';


class PairingPage extends StatefulWidget {
  const PairingPage({super.key});

  @override
  State<PairingPage> createState() => _PairingPageState();
}

class _PairingPageState extends State<PairingPage> {
  UserModel? scannedUser;

  @override
  void initState() {
    super.initState();
    _loadLatestPairedUser();
  }

  Future<void> _loadLatestPairedUser() async {
    final users = await PairedUserStorageService().getUsers();
    if (users.isNotEmpty) {
      setState(() {
        scannedUser = users.last; // show latest paired user
      });
    }
  }

  void handleScannedUser(UserModel user) async {
    await PairedUserStorageService().addUser(user);
    setState(() {
      scannedUser = user;
    });
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(t.translate('paired_user'))),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            scannedUser == null
                ? Text(t.translate('no_device_paired'))
                : Text(
                    t.translate('paired_with_user', params: {
                      'name': scannedUser!.name,
                      'email': scannedUser!.email,
                    }),
                    textAlign: TextAlign.center,
                  ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              icon: const Icon(Icons.qr_code_scanner),
              label: Text(t.translate('scan_qr')),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ScanQrPage(
                      onScanComplete: handleScannedUser, // 👈 Now passes user
                    ),
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
