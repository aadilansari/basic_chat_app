import 'package:basic_chat_app/data/models/message_model.dart';
import 'package:basic_chat_app/data/services/database_service.dart';
import 'package:basic_chat_app/data/services/push_notification_service.dart';
import 'package:basic_chat_app/data/services/token_storage_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final dbServiceProvider = Provider((ref) => DatabaseService());

final chatProvider =
    StateNotifierProvider.family<ChatViewModel, List<MessageModel>, String>((
      ref,
      partnerId,
    ) {
      final db = ref.read(dbServiceProvider);
      return ChatViewModel(db, partnerId);
    });

final tokenService = TokenStorageService();
final pushService = PushNotificationService();
Future<void> sendMessageWithPush(String receiverName, String message) async {
  final token = await tokenService.getToken();

  if (token != null) {
    await pushService.sendPushNotification(
      targetToken: token,
      senderName: "You",
      message: message,
    );
  }
}

class ChatViewModel extends StateNotifier<List<MessageModel>> {
  final DatabaseService _db;
  final String _receiverId;

  ChatViewModel(this._db, this._receiverId) : super([]) {
    loadMessages();
  }

  Future<void> loadMessages() async {
    // Simulated sender
    const sender = 'current_user@example.com';
    state = await _db.getMessages(sender, _receiverId);
  }



  void refreshMessages() async {
  await loadMessages(); // just reloads from DB
}

  Future<void> sendMessage(String msg) async {
    const sender = 'current_user@example.com'; // Should come from login
    final message = MessageModel(
      sender: sender,
      receiver: _receiverId,
      message: msg,
      timestamp: DateTime.now(),
    );
    await _db.insertMessage(message);
    await loadMessages();

    // Send FCM Push Notification
    final token = await TokenStorageService().getToken();
    if (token != null) {
      await PushNotificationService().sendPushNotification(
        targetToken: token,
        senderName: sender,
        message: msg,
      );
    }
  }
}
