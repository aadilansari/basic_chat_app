import 'package:basic_chat_app/data/models/message_model.dart';
import 'package:basic_chat_app/data/models/user_model.dart';
import 'package:basic_chat_app/data/services/database_service.dart';
import 'package:basic_chat_app/data/services/push_notification_service.dart';
import 'package:basic_chat_app/data/services/token_storage_service.dart';
import 'package:basic_chat_app/feature/auth/viewmodel/auth_viewmodel.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// DB service
final dbServiceProvider = Provider((ref) => DatabaseService());

/// Token and push services
final tokenServiceProvider = Provider((ref) => TokenStorageService());
final pushServiceProvider = Provider((ref) => PushNotificationService());

/// Chat provider with partnerId (FCM token)
final chatProvider = StateNotifierProvider.family<ChatViewModel, List<MessageModel>, UserModel>(
  (ref, partnerUser) {
    final db = ref.read(dbServiceProvider);
    final currentUser = ref.read(authProvider);
    final pushService = ref.read(pushServiceProvider);

    return ChatViewModel(
      db: db,
      partnerUser: partnerUser,
      currentUserEmail: currentUser?.email ?? '',
      pushService: pushService,
    );
  },
);

class ChatViewModel extends StateNotifier<List<MessageModel>> {
  final DatabaseService db;
  final String currentUserEmail;
  final UserModel partnerUser;
  final PushNotificationService pushService;

  ChatViewModel({
    required this.db,
    required this.currentUserEmail,
    required this.partnerUser,
    required this.pushService,
  }) : super([]) {
    loadMessages();
  }

  Future<void> loadMessages() async {
    state = await db.getMessages(currentUserEmail, partnerUser.fcmToken);
  }


 void refreshMessages() async {
  await loadMessages(); // just reloads from DB
}
  Future<void> sendMessage(String msg) async {
    final message = MessageModel(
      sender: currentUserEmail,
      receiver: partnerUser.fcmToken,
      message: msg,
      timestamp: DateTime.now(),
    );

    await db.insertMessage(message);
    await loadMessages();

    await pushService.sendPushNotification(
      targetToken: partnerUser.fcmToken,
      senderName: currentUserEmail,
      message: msg,
    );
  }
}