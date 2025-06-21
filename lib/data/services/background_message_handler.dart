import 'package:basic_chat_app/data/models/message_model.dart';
import 'package:basic_chat_app/data/services/database_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';


@pragma('vm:entry-point')
Future<void> firebaseBackgroundMessageHandler(RemoteMessage message) async {
  final sender = message.data['sender'] ?? 'Unknown';
  final text = message.data['message'] ?? '';
 final prefs = await SharedPreferences.getInstance();
  final currentUserEmail = prefs.getString('user_email') ?? 'unknown_user@example.com';

  final newMessage = MessageModel(
    sender: sender,
    receiver: currentUserEmail, // Replace with actual login logic
    message: text,
    timestamp: DateTime.now(),
  );

  final db = DatabaseService();
  await db.insertMessage(newMessage);

  print("📥 [BG] Message stored from $sender");
}

