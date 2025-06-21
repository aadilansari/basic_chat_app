import 'package:basic_chat_app/main.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import '../models/message_model.dart';
import 'database_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationService {
  final _firebaseMessaging = FirebaseMessaging.instance;
  final _db = DatabaseService();

  Future<void> initialize() async {
    // Request notification permissions (iOS, Android 13+)
    final settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    print('Notification permission status: ${settings.authorizationStatus}');

    // Get device token
    final token = await _firebaseMessaging.getToken();
    print('FCM Device Token: $token');

    // TODO: Send this token to your backend or save it as needed
  }

  void setupForegroundListener() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      final sender = message.data['sender'] ?? 'Unknown';
      final body = message.data['message'] ?? '';

      print("📥 Message from: $sender | $body");

      // Get logged-in user email from SharedPreferences or your auth provider
      final prefs = await SharedPreferences.getInstance();
      final currentUserEmail = prefs.getString('user_email') ?? 'unknown_user@example.com';

      // Save to SQLite
      final newMsg = MessageModel(
        sender: sender,
        receiver: currentUserEmail,
        message: body,
        timestamp: DateTime.now(),
      );

      // Show SnackBar using your global navigator key context
      final context = globalNavigatorKey.currentContext;
      if (context != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("New message from $sender")),
        );
      }

      await _db.insertMessage(newMsg);
    });
  }
}
