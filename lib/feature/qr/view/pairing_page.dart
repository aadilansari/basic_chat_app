import 'package:basic_chat_app/data/services/paired_user_storage_service.dart';
import 'package:basic_chat_app/feature/auth/viewmodel/auth_viewmodel.dart';
import 'package:basic_chat_app/feature/qr/widget/scan_qr_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:basic_chat_app/core/localization/app_localization.dart';
import 'package:basic_chat_app/data/models/user_model.dart';

class PairingPage extends ConsumerStatefulWidget {
  const PairingPage({super.key});

  @override
  ConsumerState<PairingPage> createState() => _PairingPageState();
}

class _PairingPageState extends ConsumerState<PairingPage> {
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
        scannedUser = users.last;
      });
    }
  }

  void handleScannedUser(UserModel user) async {
    await PairedUserStorageService().addUser(user);
   //ref.read(pairedUserProvider.notifier).addUser(user);

    setState(() {
      scannedUser = user;
    });
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final currentUser = ref.watch(authProvider);

    return Scaffold(
      appBar: AppBar(title: Text(t.translate('paired_user'))),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (currentUser != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Text(
                  t.translate('current_user', params: {
                    'name': currentUser.name,
                    'email': currentUser.email,
                  }),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
           scannedUser == null
    ? Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          t.translate('no_device_paired'),
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[600],
            fontStyle: FontStyle.italic,
          ),
          textAlign: TextAlign.center,
        ),
      )
    : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          t.translate('paired_with_user', params: {
            'name': scannedUser!.name,
            'email': scannedUser!.email,
          }),
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.green,
          ),
          textAlign: TextAlign.center,
        ),
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
                      onScanComplete: handleScannedUser,
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
