import 'dart:convert';
import 'package:basic_chat_app/core/localization/app_localization.dart';
import 'package:basic_chat_app/core/widgets/custom_appbar.dart';
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
     final t = AppLocalizations.of(context);
    return Scaffold(
      appBar: CustomAppBar(title: t.translate('qr_actions')),
      body: user == null
          ?  Center(child: Text(t.translate('please_login')))
          : Center(
            child: Column(
             mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                       
              children: [
               Text(t.translate('your_qr_code'), style: TextStyle(fontSize: 17, fontWeight: FontWeight.w400 ),),
                const SizedBox(height: 16),
                QrImageView(
                  data: jsonEncode(user.toJson()), 
                  size: 250,
                  version: QrVersions.auto,
                ),
                const SizedBox(height: 32),
                ElevatedButton.icon(
                  icon: const Icon(Icons.qr_code_scanner),
                  label:  Text(t.translate('scan_to_pair_user'),style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400 )),
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
