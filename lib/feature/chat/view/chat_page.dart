import 'dart:async';

import 'package:basic_chat_app/core/widgets/custom_appbar.dart';
import 'package:basic_chat_app/data/models/user_model.dart';
import 'package:basic_chat_app/feature/auth/viewmodel/auth_viewmodel.dart';
import 'package:basic_chat_app/feature/chat/viewmodel/chat_viewmodel.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class ChatPage extends ConsumerStatefulWidget {
  final UserModel user;

  const ChatPage({super.key, required this.user});

  @override
  ConsumerState<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends ConsumerState<ChatPage> {
  final msgController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  late final FirebaseMessaging messaging;

  @override
  void initState() {
    super.initState();

    Timer.periodic(const Duration(seconds: 2), (_) {
      if (mounted) {
        ref.read(chatProvider(widget.user).notifier).refreshMessages();
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Future.delayed(Duration.zero, () {
      ref.read(chatProvider(widget.user).notifier).refreshMessages();
    });
  }

  void scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void didUpdateWidget(covariant ChatPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    scrollToBottom();
  }

  @override
  Widget build(BuildContext context) {
    final myUser = ref.watch(authProvider);
    final messages = ref.watch(chatProvider(widget.user));

    WidgetsBinding.instance.addPostFrameCallback((_) {
      scrollToBottom();
    });

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Chat with ${widget.user.name}',
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: messages.length,
              padding: const EdgeInsets.all(8),
              itemBuilder: (_, index) {
                final msg = messages[index];
                final isMe = msg.sender == myUser?.email;

                final timestamp =
                    DateFormat('MMM d, h:mm a').format(msg.timestamp);

                return Align(
                  alignment:
                      isMe ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isMe ? Colors.blue : Colors.grey[300],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: isMe
                          ? CrossAxisAlignment.end
                          : CrossAxisAlignment.start,
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
                      scrollToBottom();
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

  @override
  void dispose() {
    _scrollController.dispose();
    msgController.dispose();
    super.dispose();
  }
}
