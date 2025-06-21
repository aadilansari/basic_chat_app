import 'package:basic_chat_app/data/models/message_model.dart';
import 'package:basic_chat_app/data/models/user_model.dart';
import 'package:basic_chat_app/data/services/database_service.dart';
import 'package:basic_chat_app/feature/auth/viewmodel/auth_viewmodel.dart';
import 'package:basic_chat_app/feature/chat/viewmodel/chat_viewmodel.dart';
import 'package:basic_chat_app/main.dart';
import 'package:basic_chat_app/provider/notification_provider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatPage extends ConsumerStatefulWidget {
  final UserModel user;

  const ChatPage({super.key, required this.user});

  @override
  ConsumerState<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends ConsumerState<ChatPage> {
  final msgController = TextEditingController();


  late final FirebaseMessaging messaging;

  @override
  void initState() {
    super.initState();
    messaging = FirebaseMessaging.instance;

    // Request permissions (iOS/Android 13+)
    requestNotificationPermissions();

    // Get the FCM token and print it (send to your backend or share with sender)
    messaging.getToken().then((token) {
      print('🔑 FCM Token: $token');
      // TODO: Save/send token to backend or relevant user logic
    });

    // Listen to foreground messages
   FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
  print('🔔 Received foreground message: ${message.data}');

  final sender = message.data['sender'] ?? 'Unknown';
  final text = message.data['message'] ?? '';

  final prefs = await SharedPreferences.getInstance();
  final currentUserEmail = prefs.getString('user_email') ?? 'unknown_user@example.com';

  final newMessage = MessageModel(
    sender: sender,
    receiver: currentUserEmail,
    message: text,
    timestamp: DateTime.now(),
  );

  final db = DatabaseService();
  await db.insertMessage(newMessage);

  print("📥 [FG] Message stored from $sender");

  // Show local notification
  RemoteNotification? notification = message.notification;
  AndroidNotification? android = message.notification?.android;

  if (notification != null && android != null) {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'default_channel_id', // channel id
      'Default Channel', // channel name
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
    );

    const NotificationDetails platformDetails = NotificationDetails(android: androidDetails);

    await flutterLocalNotificationsPlugin.show(
      notification.hashCode,
      notification.title ?? 'New Message from $sender',
      notification.body ?? text,
      platformDetails,
      payload: 'chat', // optional, can pass data for handling on tap
    );
  }
});

    // Handle user tapping on notification when app is in background but opened via notification
   FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
  print('📲 Notification clicked with data: ${message.data}');

  final senderEmail = message.data['sender'];
  if (senderEmail != null) {
   
    globalNavigatorKey.currentState?.push(
      MaterialPageRoute(
        builder: (_) => ChatPage(user: widget.user), 
      ),
    );
  }
});

  }

  Future<void> requestNotificationPermissions() async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    print('🔔 User granted permission: ${settings.authorizationStatus}');
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Future.delayed(Duration.zero, () {
      ref.read(chatProvider(widget.user).notifier).refreshMessages();
    });
  }

  @override
  Widget build(BuildContext context) {
    final myUser = ref.watch(authProvider);
    final messages = ref.watch(chatProvider(widget.user));

    return Scaffold(
      appBar: AppBar(title: Text('Chat with ${widget.user.name}')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              padding: const EdgeInsets.all(8),
              itemBuilder: (_, index) {
                final msg = messages[index];
                final isMe = msg.sender == myUser?.email;

                final timestamp =
                    DateFormat('MMM d, h:mm a').format(msg.timestamp);

                return Align(
                  alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isMe ? Colors.blue : Colors.grey[300],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment:
                          isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                      children: [
                        Text(
                          msg.message,
                          style: TextStyle(
                            color: isMe ? Colors.white : Colors.black,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          timestamp,
                          style: TextStyle(
                            fontSize: 11,
                            color: isMe ? Colors.white70 : Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: msgController,
                    decoration: const InputDecoration(
                      hintText: 'Type a message',
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {
                    final text = msgController.text.trim();
                    if (text.isNotEmpty) {
                      ref
                          .read(chatProvider(widget.user).notifier)
                          .sendMessage(text);
                      msgController.clear();
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
