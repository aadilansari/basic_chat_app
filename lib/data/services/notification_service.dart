
import 'package:basic_chat_app/data/models/user_model.dart';
import 'package:basic_chat_app/data/services/paired_user_storage_service.dart';
import 'package:basic_chat_app/feature/chat/view/user_list_page.dart';
import 'package:basic_chat_app/main.dart';
import 'package:basic_chat_app/provider/notification_provider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
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

 FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
  print('📲 Notification clicked with data: ${message.data}');

  final senderEmail = message.data['sender'];
  if (senderEmail != null) {
   
    globalNavigatorKey.currentState?.push(
      MaterialPageRoute(
        builder: (_) => UserListPage(), 
      ),
    );
  }
});


   FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
  print('🔔 Received foreground message: ${message.data}');

  final sender = message.data['sender'] ?? 'Unknown';
  final senderEmail = message.data['email']?? '';
  final text = message.data['message'] ?? '';

  print("📥 Message from: $sender | $text");

  // Get logged-in user email
  final prefs = await SharedPreferences.getInstance();
  final currentUserEmail = prefs.getString('user_email') ?? 'unknown_user@example.com';

  final newMessage = MessageModel(
    sender: sender,
    receiver: currentUserEmail,
    message: text,
    timestamp: DateTime.now(),
  );

  // Save to SQLite
  await _db.insertMessage(newMessage);
  print("📥 [FG] Message stored from $sender");

  final allMessages = await _db.getMessages(sender, currentUserEmail);
for (var msg in allMessages) {
  print("📦 [DB] ${msg.sender} ➡ ${msg.receiver}: ${msg.message}");
}

   // ✅ Add sender to paired users if not already added
  final pairedUsers = await PairedUserStorageService().getUsers();
  final alreadyPaired = pairedUsers.any((user) => user.email == senderEmail);

  if (!alreadyPaired) {
    final newUser = UserModel(
      email: senderEmail,
      name: sender, 
      fcmToken: message.data['fcm'] ?? '', 
      country: '',
      phone:  message.data['phone'] ?? '', password: '',
    );

    await PairedUserStorageService().addUser(newUser);


    print("✅ Added new user to paired list: ${newUser.email}");
  }


  // Show SnackBar
  final context = globalNavigatorKey.currentContext;
  if (context != null) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("New message from $sender")),
    );
  }

  // Optionally show local notification if available in message
  final notification = message.notification;
  final android = message.notification?.android;

  if (notification != null && android != null) {
    const androidDetails = AndroidNotificationDetails(
      'default_channel_id',
      'Default Channel',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
    );

    const platformDetails = NotificationDetails(android: androidDetails);

    await flutterLocalNotificationsPlugin.show(
      notification.hashCode,
      notification.title ?? 'New Message from FL $sender',
      notification.body ?? text,
      platformDetails,
      payload: 'chat',
    );
  }
});

  }
}
