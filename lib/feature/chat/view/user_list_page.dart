import 'package:basic_chat_app/core/localization/app_localization.dart';
import 'package:basic_chat_app/data/services/paired_user_storage_service.dart';
import 'package:flutter/material.dart';
import '../../../data/models/user_model.dart';
import 'chat_page.dart';

class UserListPage extends StatefulWidget {
  const UserListPage({super.key});

  @override
  State<UserListPage> createState() => _UserListPageState();
}

class _UserListPageState extends State<UserListPage> {
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
    return Scaffold(
      appBar: AppBar(title:  Text(t.translate('paired_user'))),
      body: users.isEmpty
          ?  Center(child: Text(t.translate('no_paired_user_found')))
          : ListView.builder(
              itemCount: users.length,
              itemBuilder: (_, index) {
                final user = users[index];
                return ListTile(
                  title: Text(user.name),
                  subtitle: Text(user.email),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ChatPage(user:user),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
