import 'package:basic_chat_app/core/localization/app_localization.dart';
import 'package:basic_chat_app/data/models/user_model.dart';
import 'package:basic_chat_app/data/services/paired_user_storage_service.dart';
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
  List<UserModel> users = [];

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }  

  Future<void> _loadUsers() async {
    users = await PairedUserStorageService().getUsers();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final currentUser = ref.watch(authProvider);

    return Scaffold(
      appBar: AppBar(title: Text("Home")),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (currentUser != null)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                 Text("Welcome", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                  const SizedBox(height: 4),
                  Text('${currentUser.name} (${currentUser.email}) ${currentUser.phone}', 
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue, fontSize: 20),),
                ],
              ),
            ),
          const Divider(),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text("Chat list", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
            ),
          Expanded(
            child: users.isEmpty
                ? Center(child: Text(t.translate('no_paired_user_found')))
                : ListView.builder(
                    itemCount: users.length,
                    itemBuilder: (_, index) {
                      final user = users[index];
                      return ListTile(
                        title: Text(user.name),
                        subtitle: Text(user.email),
                        selectedTileColor: Colors.blueAccent,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ChatPage(user: user),
                            ),
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
