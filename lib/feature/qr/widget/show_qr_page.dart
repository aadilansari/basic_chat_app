import 'package:basic_chat_app/provider/notification_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qr_flutter/qr_flutter.dart';


class ShowQrPage extends ConsumerWidget {
  const ShowQrPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifService = ref.read(notificationProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Your QR Code')),
      body: FutureBuilder(
        future: notifService.getDeviceToken(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final token = snapshot.data!;
          return Center(
            child: QrImageView(
              data: token,
              size: 250,
              version: QrVersions.auto,
            ),
          );
        },
      ),
    );
  }
}
