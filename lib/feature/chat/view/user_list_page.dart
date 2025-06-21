import 'package:basic_chat_app/core/widgets/theme_toggle_button.dart';
import 'package:basic_chat_app/data/repository/auth_repository.dart';
import 'package:basic_chat_app/data/repository/user_repository.dart';
import 'package:basic_chat_app/feature/auth/viewmodel/auth_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'chat_page.dart';

class UserListPage extends ConsumerStatefulWidget {
  const UserListPage({super.key});

  @override
  ConsumerState<UserListPage> createState() => _UserListPageState();
}

class _UserListPageState extends ConsumerState<UserListPage> {
  @override
  Widget build(BuildContext context) {
    final users = UserRepository().getPairedUsers();
    final user = ref.watch(authProvider); // now works correctly

    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome ${user!.name ?? ''}'),
        actions: [ThemeToggleButton()],
      ),
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
