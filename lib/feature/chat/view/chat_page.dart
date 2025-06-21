import 'package:basic_chat_app/feature/chat/viewmodel/chat_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatPage extends ConsumerStatefulWidget { 
  final String partnerId;

  const ChatPage({super.key, required this.partnerId});

  @override
  ConsumerState<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends ConsumerState<ChatPage> {
  final msgController = TextEditingController();
  String? email;

  @override
  void initState() {
    super.initState();
    getmyUser();
  }

  getmyUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userEmail = prefs.getString('user_email');
    if (userEmail == null) {
      // Handle case where user is not logged in
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('User not logged in')));
      return;
    }
    else {
      email = userEmail;
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Call refresh every time user returns to this page
    Future.delayed(Duration.zero, () {
      ref.read(chatProvider(widget.partnerId).notifier).refreshMessages();
    });
  }

  @override
  Widget build(BuildContext context) {
    final messages = ref.watch(chatProvider(widget.partnerId));

    return Scaffold(
      appBar: AppBar(title: Text('Chat with ${widget.partnerId}')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              padding: const EdgeInsets.all(8),
              itemBuilder: (_, index) {
                final msg = messages[index];
                final isMe =
                    msg.sender ==
                    email; 
                return Align(
                  alignment: isMe
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isMe ? Colors.blue : Colors.grey[300],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      msg.message,
                      style: TextStyle(
                        color: isMe ? Colors.white : Colors.black,
                      ),
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
                    if (msgController.text.trim().isNotEmpty) {
                      ref
                          .read(chatProvider(widget.partnerId).notifier)
                          .sendMessage(msgController.text.trim());
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
