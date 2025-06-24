import 'package:basic_chat_app/core/widgets/custom_appbar.dart';
import 'package:basic_chat_app/data/services/paired_user_storage_service.dart';
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
    setState(() {
      scannedUser = user;
    });
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);

    return Scaffold(
      appBar: CustomAppBar(title: t.translate('paired_user')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
          
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
        child: Container()
      ),
            const SizedBox(height: 24),
          
            Padding(
              padding: const EdgeInsets.symmetric(horizontal:  16.0),
              child: SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton.icon(
                          icon: const Icon(Icons.qr_code_scanner, color: Colors.white,),
                          label: Text(t.translate('scan_qr'), style: TextStyle(color: Colors.white),),
                        style: ElevatedButton.styleFrom(
                          backgroundColor:Colors.blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
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
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
