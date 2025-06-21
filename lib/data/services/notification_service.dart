import 'package:basic_chat_app/main.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import '../models/message_model.dart';
import 'database_service.dart';

class NotificationService {
  final _firebaseMessaging = FirebaseMessaging.instance;
  final _db = DatabaseService(); // ✅ Inject or instantiate

  Future<String?> getDeviceToken() async {
    await _firebaseMessaging.requestPermission();
    return await _firebaseMessaging.getToken();
  }

  void setupForegroundListener() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      final sender = message.data['sender'] ?? 'Unknown';
      final body = message.data['message'] ?? '';

      print("📥 Message from: $sender | $body");

      // ✅ Save to SQLite
      final newMsg = MessageModel(
        sender: sender,
        receiver: 'current_user@example.com', // <-- update to logged-in user
        message: body,
        timestamp: DateTime.now(),
      );

      ScaffoldMessenger.of(
        globalNavigatorKey.currentContext!,
      ).showSnackBar(SnackBar(content: Text("New message from $sender")));
      await _db.insertMessage(newMsg);
    });
  }
}
