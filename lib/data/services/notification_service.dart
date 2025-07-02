// ignore_for_file: avoid_print, use_build_context_synchronously

import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:basic_chat_app/data/models/message_model.dart';
import 'package:basic_chat_app/data/models/user_model.dart';
import 'package:basic_chat_app/data/services/database_service.dart';
import 'package:basic_chat_app/data/services/paired_user_storage_service.dart';
import 'package:basic_chat_app/main.dart';
import 'package:basic_chat_app/main_navigation_page.dart';

class NotificationService {
  NotificationService._();

  static final DatabaseService _db = DatabaseService();
  static final List<String> _recentHashes = [];
  static String _makeHash(MessageModel m) {
    final key =
        '${m.sender}|${m.message}|${m.timestamp.millisecondsSinceEpoch ~/ 1000}';
    return sha256.convert(utf8.encode(key)).toString();
  }

  static bool _isDuplicate(String hash) => _recentHashes.contains(hash);

  static void _remember(String hash) {
    _recentHashes..add(hash);
    if (_recentHashes.length > 5) _recentHashes.removeAt(0);
  }


  static Future<void> onForeground(RemoteMessage message) async {
    debugPrint('Foreground notification: ${message.data}');

    final senderName  = message.data['sender']  ?? 'Unknown';
    final senderEmail = message.data['email']   ?? '';
    final text        = message.data['message'] ?? '';
    final phone       = message.data['phone']   ?? '';
    final fcmToken    = message.data['fcm']     ?? '';

    final prefs            = await SharedPreferences.getInstance();
    final currentUserEmail = prefs.getString('user_email') ??
        'unknown_user@example.com';

    final newMsg = MessageModel(
      sender: senderEmail,
      receiver: currentUserEmail,
      message: text,
      timestamp: DateTime.now(),
    );

    final hash = _makeHash(newMsg);
    if (_isDuplicate(hash)) {
      debugPrint('Duplicate message blocked (hash match)');
      return;
    }
    _remember(hash);

    await _db.insertMessage(newMsg);

    final pairedUsers  = await PairedUserStorageService().getUsers();
    final alreadyPaired =
        pairedUsers.any((u) => u.email == senderEmail);

    if (!alreadyPaired) {
      final newUser = UserModel(
        email: senderEmail,
        name: senderName,
        fcmToken: fcmToken,
        country: '',
        phone: phone,
        password: '',
      );
      await PairedUserStorageService().addUser(newUser);
      debugPrint('Paired new user: ${newUser.email}');
    }

 
    final ctx = globalNavigatorKey.currentContext;
    if (ctx != null) {
      ScaffoldMessenger.of(ctx).showSnackBar(
        SnackBar(
          content: Text('New message from $senderName'),
          backgroundColor: Colors.blue,
        ),
      );
    }
  }


  static void onTap(RemoteMessage message) {
    debugPrint('Notification clicked: ${message.data}');
    globalNavigatorKey.currentState?.push(
      MaterialPageRoute(builder: (_) => const MainNavigationPage()),
    );
  }
}
