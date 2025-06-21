import 'package:basic_chat_app/core/widgets/theme_toggle_button.dart';
import 'package:basic_chat_app/data/repository/user_repository.dart';
import 'package:flutter/material.dart';
import 'chat_page.dart';

class UserListPage extends StatelessWidget {
  const UserListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final users = UserRepository().getPairedUsers();

    return Scaffold(
      appBar: AppBar(title: const Text('Select User to Chat'),  actions: [
      ThemeToggleButton(), // Add to AppBar
    ],),
      body: ListView.builder(
        itemCount: users.length,
        itemBuilder: (_, index) {
          final user = users[index];
          return ListTile(
            leading: const Icon(Icons.person),
            title: Text(user.name),
            subtitle: Text(user.email),
            trailing: const Icon(Icons.chat),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ChatPage(partnerId: user.fcmToken),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
