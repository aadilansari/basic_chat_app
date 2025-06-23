// ignore_for_file: avoid_print

import 'package:basic_chat_app/data/models/user_model.dart';
import 'package:basic_chat_app/data/services/paired_user_storage_service.dart';
import 'package:basic_chat_app/main.dart';
import 'package:basic_chat_app/main_navigation_page.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/message_model.dart';
import 'database_service.dart';

import 'dart:convert';
import 'package:crypto/crypto.dart';

class NotificationService {
  final _firebaseMessaging = FirebaseMessaging.instance;
  final _db = DatabaseService();
  final List<String> _recentHashes = [];

  Future<void> initialize() async {
    final settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    print('Notification permission: ${settings.authorizationStatus}');

    final token = await _firebaseMessaging.getToken();
    print('FCM Token: $token');
  }

  /// Creates a hash signature for a message based on sender+message+timestamp(rounded)
  String _generateMessageHash(MessageModel message) {
    final key = "${message.sender}|${message.message}|${message.timestamp.millisecondsSinceEpoch ~/ 1000}";
    return sha256.convert(utf8.encode(key)).toString();
  }

  bool _isDuplicateHash(String hash) {
    return _recentHashes.contains(hash);
  }

  void _addHash(String hash) {
    _recentHashes.add(hash);
    if (_recentHashes.length > 5) {
      _recentHashes.removeAt(0);
    }
  }

  void setupForegroundListener() {
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('Notification clicked: ${message.data}');
      final senderEmail = message.data['sender'];
      if (senderEmail != null) {
        globalNavigatorKey.currentState?.push(
          MaterialPageRoute(builder: (_) => MainNavigationPage()),
        );
      }
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      print('Foreground notification: ${message.data}');

      final sender = message.data['sender'] ?? 'Unknown';
      final senderEmail = message.data['email'] ?? '';
      final text = message.data['message'] ?? '';
      final phone = message.data['phone'] ?? '';
      final fcmToken = message.data['fcm'] ?? '';

      final prefs = await SharedPreferences.getInstance();
      final currentUserEmail =
          prefs.getString('user_email') ?? 'unknown_user@example.com';

      final newMessage = MessageModel(
        sender: senderEmail,
        receiver: currentUserEmail,
        message: text,
        timestamp: DateTime.now(),
      );

      final hash = _generateMessageHash(newMessage);
      if (_isDuplicateHash(hash)) {
        debugPrint("Duplicate message blocked via hash check");
        return;
      }

      _addHash(hash);
      await _db.insertMessage(newMessage);

      final pairedUsers = await PairedUserStorageService().getUsers();
      final alreadyPaired = pairedUsers.any((user) => user.email == senderEmail);

      if (!alreadyPaired) {
        final newUser = UserModel(
          email: senderEmail,
          name: sender,
          fcmToken: fcmToken,
          country: '',
          phone: phone,
          password: '',
        );
        await PairedUserStorageService().addUser(newUser);
        print("Paired new user: ${newUser.email}");
      }

      final context = globalNavigatorKey.currentContext;
      if (context != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("New message from $sender"),
            backgroundColor: Colors.blue,
          ),
        );
      }
    });
  }
}
